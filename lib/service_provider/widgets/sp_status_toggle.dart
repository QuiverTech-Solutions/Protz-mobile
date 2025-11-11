import 'package:flutter/material.dart';
import '../core/app_export.dart';
import '../core/controllers/provider_availability_controller.dart';

class SPStatusToggle extends StatelessWidget {
  final ProviderAvailabilityController controller;

  const SPStatusToggle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Semantics(
        label: 'Provider availability toggle',
        toggled: controller.isOnline,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
          decoration: BoxDecoration(
            color: appTheme.light_blue_50,
            borderRadius: BorderRadius.circular(16.h),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: controller.isOnline ? Colors.green : Colors.red, size: 12.h),
                  SizedBox(width: 8.h),
                  Text(
                    controller.isOnline ? 'You are Online' : 'You are Offline',
                    style: SPTextStyleHelper.instance.body12RegularPoppins,
                  ),
                ],
              ),
              Semantics(
                button: true,
                hint: controller.isOnline ? 'Switch to offline' : 'Switch to online',
                child: Switch(
                  value: controller.isOnline,
                  activeColor: appTheme.light_blue_900,
                  onChanged: (val) => controller.setOnline(val),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}