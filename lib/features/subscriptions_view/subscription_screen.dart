import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'subscription_controller.dart';

class SubscriptionScreen extends GetView<SubscriptionController> {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
          Positioned.fill(child: _buildBackgroundGlow()),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _buildCrownHeader(),
                        const SizedBox(height: 28),
                        _buildFeatureList(),
                        const SizedBox(height: 28),
                        _buildPlanSelector(),
                        const SizedBox(height: 20),
                        _buildTrustRow(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildStickyCTA(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGlow() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0A0F), Color(0xFF14101F), Color(0xFF0A0A0F)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -80, left: -60, child: _glowCircle(const Color(0xFFFFB800), 220)),
          Positioned(top: 100, right: -100, child: _glowCircle(const Color(0xFF8B5CF6), 260)),
        ],
      ),
    );
  }

  Widget _glowCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.25), color.withOpacity(0.0)],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close_rounded, color: Colors.white70),
          ),
          TextButton(
            onPressed: controller.restorePurchases,
            child: const Text(
              'Restore',
              style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrownHeader() {
    return Column(
      children: [

        AnimatedBuilder(
          animation: controller.crownAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, controller.crownAnim.value),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFF8A00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB800).withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 34),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Unlock Imgora Pro',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create without limits. Cancel anytime.',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: controller.features.map((f) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB800).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(f.icon, color: const Color(0xFFFFB800), size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.title,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(f.subtitle,
                        style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 12.5)),
                  ],
                ),
              ),
              Icon(Icons.check_circle_rounded,
                  color: const Color(0xFFFFB800).withOpacity(0.9), size: 20),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPlanSelector() {

    return Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          else if(controller.availableProducts.isEmpty){
            return const Center(child: Text("no products found"));
          }

            return  Column(
              children:  List.generate(controller.availableProducts.length, (index) {
                final plan = controller.planDisplayName[index];
                final isSelected = controller.selectedPlan.value == index;

                return  GestureDetector(
                  onTap: () => controller.selectPlan(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: isSelected
                          ? const LinearGradient(
                        colors: [Color(0xFF1F1B2E), Color(0xFF251C33)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : null,
                      color: isSelected ? null : Colors.white.withOpacity(0.04),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFFB800) : Colors.white.withOpacity(0.08),
                        width: isSelected ? 1.6 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: const Color(0xFFFFB800).withOpacity(0.15),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? const Color(0xFFFFB800) : Colors.white24,
                              width: 2,
                            ),
                            color: isSelected ? const Color(0xFFFFB800) : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 14, color: Colors.black)
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      plan,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(

                                        color: Colors.white,
                                        fontSize: 11.5,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                ],
                              ),


                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(controller.availableProducts.value[index].price,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),

                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }
    );
  }

  Widget _buildTrustRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline_rounded, size: 14, color: Colors.white.withOpacity(0.35)),
        const SizedBox(width: 6),
        Text('Secure payment • Cancel anytime',
            style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 12)),
      ],
    );
  }

  Widget _buildStickyCTA() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0F).withOpacity(0.85),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: controller.purchase,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB800),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFF8A00),Color(0xFFFF8A03)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Obx(
                  () =>
                      Container(
                    alignment: Alignment.center,
                    child:  controller.isPurchasing.value == true ? CircularProgressIndicator() :  Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}