import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared/utils/pages.dart';
import '../core/app_export.dart';
import '../widgets/service_select_card.dart';
import '../widgets/sp_upload_field.dart';
import '../widgets/sp_primary_button.dart';

class DocumentVerificationScreen extends StatefulWidget {
  const DocumentVerificationScreen({super.key});

  @override
  State<DocumentVerificationScreen> createState() => _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState extends State<DocumentVerificationScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedService; // 'towing' or 'water'
  int _licenseCount = 0;
  int _registrationCount = 0;
  int _photosCount = 0;
  int _insuranceCount = 0; // optional

  Future<void> _pickImages(String key) async {
    final images = await _picker.pickMultiImage();
    final count = images.length;
    setState(() {
      switch (key) {
        case 'license':
          _licenseCount = count;
          break;
        case 'registration':
          _registrationCount = count;
          break;
        case 'photos':
          _photosCount = count;
          break;
        case 'insurance':
          _insuranceCount = count;
          break;
      }
    });
  }

  void _onNext(BuildContext context) {
    final hasService = _selectedService != null;
    final hasRequiredUploads = _licenseCount > 0 && _registrationCount > 0 && _photosCount > 0;
    if (!hasService || !hasRequiredUploads) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Select a service and upload all required documents.')),
      );
      return;
    }
    GoRouterHelper.go(context, AppRoutes.providerHome);
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: appTheme.white_A700,
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  child: Center(
                    child: SizedBox(
                      width: 345.h,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Header
                            Column(
                              children: [
                                Text(
                                  'Documentation',
                                  style: SPTextStyleHelper.instance
                                      .headline24MediumPoppins,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Provide the required details to proceed',
                                  style: SPTextStyleHelper.instance
                                      .body12RegularPoppins,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),

                            SizedBox(height: 40.h),

                            // Which service provider are you signing up as?
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Which service provider are you signing up as?',
                                style: SPTextStyleHelper.instance
                                    .label10RegularPoppins,
                              ),
                            ),
                            SizedBox(height: 8.h),

                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 130.h,
                                    child: SPServiceSelectCard(
                                      icon: SPImageConstant.imgTowing,
                                      title: 'Towing Service',
                                      caption: 'Sign up to tow vehicles from one point to another safely.',
                                      selected: _selectedService == 'towing',
                                      onTap: () => setState(() => _selectedService = 'towing'),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.h),
                                Expanded(
                                  child: SizedBox(
                                    height: 130.h,
                                    child: SPServiceSelectCard(
                                      icon: SPImageConstant.imgWaterDelivery,
                                      title: 'Bulk Water Supplier',
                                      caption: 'Sign up to deliver water to homes and offices in bulk.',
                                      selected: _selectedService == 'water',
                                      onTap: () => setState(() => _selectedService = 'water'),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 24.h),

                            // Upload fields
                            SPUploadField(
                              label: '*Driver’s License - Front & Back',
                              count: _licenseCount,
                              onTap: () => _pickImages('license'),
                            ),
                            SizedBox(height: 20.h),
                            SPUploadField(
                              label: '*Vehicle Registration',
                              count: _registrationCount,
                              onTap: () => _pickImages('registration'),
                            ),
                            SizedBox(height: 20.h),
                            SPUploadField(
                              label: '*Photos of Vehicle',
                              count: _photosCount,
                              onTap: () => _pickImages('photos'),
                            ),
                            SizedBox(height: 20.h),
                            SPUploadField(
                              label: 'Insurance Document (Optional)',
                              count: _insuranceCount,
                              onTap: () => _pickImages('insurance'),
                            ),

                            SizedBox(height: 24.h),

                            // Next button
                            SPPrimaryButton(
                              title: 'Next',
                              onPressed: () => _onNext(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Actions: Back button
                Positioned(
                  left: 0,
                  top: 2.h,
                  child: Padding(
                    padding: EdgeInsets.all(8.h),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: 40.h,
                        height: 40.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.chevron_left),
                      ),
                    ),
                  ),
                ),

                // Step indicator
                Positioned(
                  right: 0,
                  top: 5.h,
                  child: SizedBox(
                    width: 345.h,
                    child: Text(
                      'Step 2/3',
                      textAlign: TextAlign.right,
                      style: SPTextStyleHelper.instance.body12RegularPoppins,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Moved inner widgets to lib/service_provider/widgets/ and wired interactions