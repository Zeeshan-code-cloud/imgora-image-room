import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imageconvertor/utils/app_asset.dart';
import 'package:imageconvertor/widgets/animated_gradient_background.dart';
import 'package:imageconvertor/features/history_view/history_controller.dart';
import 'package:imageconvertor/widgets/app_text.dart';
import 'package:imageconvertor/widgets/custom_platform_widget.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryController());

    return AnimatedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'History',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final activities = controller.activities;
          if (activities.isEmpty) {
            return  Center(
              child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 12.h,),
                    Image.asset(AppAsset.emptyHistory, fit: BoxFit.contain,),
                   ],
                  
                ),
            );
          }

          Map<String, List<dynamic>> grouped = {
            "Today": [],
            "Yesterday": [],
            "A week ago": [],
            "A month ago": [],
            "Older": [],
          };

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final yesterday = today.subtract(const Duration(days: 1));
          final weekAgo = today.subtract(const Duration(days: 7));
          final monthAgo = DateTime(now.year, now.month - 1, now.day);

          for (var item in activities) {
            if (item.date == null || item.date!.isEmpty) {
              grouped["Older"]!.add(item);
              continue;
            }
            try {
              final date = DateTime.parse(item.date!);
              final itemDay = DateTime(date.year, date.month, date.day);

              if (itemDay == today) {
                grouped["Today"]!.add(item);
              } else if (itemDay == yesterday) {
                grouped["Yesterday"]!.add(item);
              } else if (itemDay.isAfter(weekAgo)) {
                grouped["A week ago"]!.add(item);
              } else if (itemDay.isAfter(monthAgo)) {
                grouped["A month ago"]!.add(item);
              } else {
                grouped["Older"]!.add(item);
              }
            } catch (e) {
              grouped["Older"]!.add(item);
            }
          }

          List<dynamic> listItems = [];
          for (var key in [
            "Today",
            "Yesterday",
            "A week ago",
            "A month ago",
            "Older",
          ]) {
            if (grouped[key]!.isNotEmpty) {
              listItems.add(key);
              listItems.addAll(grouped[key]!);
            }
          }

          return ListView.builder(
            itemCount: listItems.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              final listItem = listItems[index];

              if (listItem is String) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Text(
                    listItem,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              final item = listItem; // This is a StorageModel
              final isPdf = item.imageFormat.toUpperCase() == "PDF";

              String dateStr = item.date ?? "";
              try {
                if (dateStr.isNotEmpty) {
                  final parsedDate = DateTime.parse(dateStr);
                  final months = [
                    "Jan",
                    "Feb",
                    "Mar",
                    "Apr",
                    "May",
                    "Jun",
                    "Jul",
                    "Aug",
                    "Sep",
                    "Oct",
                    "Nov",
                    "Dec",
                  ];
                  dateStr = "${months[parsedDate.month - 1]} ${parsedDate.day}";
                }
              } catch (e) {
                // ignore
              }

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade200.withOpacity(0.3),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GestureDetector(
                  onTap: () async {
                    if (isPdf) {
                      await OpenFilex.open(item.imagePath);
                    } else {
                      Get.to(ImageFullPreview(image: item.imagePath,));
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 20.h,
                          child: isPdf
                              ? Container(
                                  color: Colors.red.withOpacity(0.2),
                                  child: const Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.redAccent,
                                    size: 50,
                                  ),
                                )
                              : (File(item.imagePath).existsSync()
                                    ? ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                        child: Image.file(
                                          File(item.imagePath),
                                          width: double.infinity,
                                          height: 20.h,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        color: Colors.white24,
                                        child: const Icon(
                                          Icons.image,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      )),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 1.h,
                                left: 4.w,
                                bottom: 2.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.operationType ?? 'Unknown',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    dateStr,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 2.w, bottom: 2.h),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.blueGrey,
                                    ),
                                    onPressed: () async {
                                      if (File(item.imagePath).existsSync()) {
                                        await Share.shareXFiles(
                                          [XFile(item.imagePath)],
                                          text: 'Check out my converted file!',
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.blueGrey,
                                    ),
                                    onPressed: () {
                                      CustomPlatformWidget.showDefaultDialog(
                                        context: context,
                                        title: 'Delete Item',
                                        message:
                                            'Are you sure you want to delete this item?',
                                        onConfirm: () {
                                          controller.deleteItem(item.imagePath);
                                          Get.back();
                                        },
                                        confirmColor: Colors.redAccent,
                                        confirmText: "Delete",
                                        onCancel: () => Get.back(),
                                        cancelText: "Cancel",
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class ImageFullPreview extends StatelessWidget {
  final String image;

  const ImageFullPreview({
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(
              File(image),
            ),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}