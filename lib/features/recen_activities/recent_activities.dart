import 'dart:io';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/storage_sevices/storage_model.dart';
import 'recent_activities_controller.dart';

class RecentActivitiesView extends GetView<RecentActivitiesController> {
  const RecentActivitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RecentActivitiesController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Recent Activities",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

         if (controller.activities.isEmpty) {
          return const EmptyState();
        }

         return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.activities.length,
          itemBuilder: (_, index) {
            final item = controller.activities[index];

            return ActivityCard(
              item: item,
              onDelete: () => controller.deleteItem(item.imagePath),
            );
          },
        );
      }),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.history_rounded,
            size: 80,
            color: Color(0xffC5C5D3),
          ),
          SizedBox(height: 16),
          Text(
            "No Recent Activities",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xff171827),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Your converted files will appear here",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff7A7D8C),
            ),
          ),
        ],
      ),
    );
  }
}


class ActivityCard extends StatelessWidget {
  final StorageModel item;
  final VoidCallback onDelete;

  const ActivityCard({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (item.imageFormat.toUpperCase() == 'PDF') {
          await OpenFilex.open(item.imagePath);
        } else {
          Get.to(() => FullScreenActivityView(item: item));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffE6E6E6)),
        ),
        child: Row(
          children: [
            // Image Preview
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(item.imagePath),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Icon(Icons.image, size: 60);
                },
              ),
            ),

            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.imageName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.imageFormat.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xff7A7D8C),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Delete Button
            IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Delete",
                  middleText: "Are you sure you want to delete this activity?",
                  textConfirm: "Delete",
                  textCancel: "Cancel",
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                  cancelTextColor: Colors.black,
                  onConfirm: () {
                    Get.back();
                    onDelete();
                  },
                );
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenActivityView extends StatelessWidget {
  final StorageModel item;
  const FullScreenActivityView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(item.imageName, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () async {
              final format = item.imageFormat.toUpperCase();
              if (format == 'PDF' || format == 'SVG') {
                await Share.shareXFiles([XFile(item.imagePath)]);
              } else {
                final success = await GallerySaver.saveImage(item.imagePath);
                if (success == true) {
                   Get.snackbar("Success", "Saved to Gallery", backgroundColor: Colors.white);
                } else {
                   Get.snackbar("Error", "Failed to save to Gallery", backgroundColor: Colors.white);
                }
              }
            },
          )
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(File(item.imagePath)),
        ),
      ),
    );
  }
}