import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_export.dart';
import '../../../auth/widgets/auth_text_field.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'John Williams');
  final TextEditingController _emailController =
      TextEditingController(text: 'johnwilliams69@gmail.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '0244666419');
  final TextEditingController _addressController =
      TextEditingController(text: 'No. 1 Ashongman Estates');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.white_A700,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appTheme.blue_gray_900),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Your Profile',
          style: TextStyleHelper.instance.title18MediumPoppins,
        ),
        centerTitle: false,
      ),
      body: Sizer(
        builder: (context, orientation, deviceType) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 12.h),
                // Avatar
                CircleAvatar(
                  radius: 36.h,
                  backgroundImage: AssetImage(ImageConstant.imgAvatar),
                ),
                SizedBox(height: 12.h),
                // Edit Profile photo row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.h,
                  children: [
                    Text(
                      'Edit Profile photo',
                      style: TextStyle(
                        fontSize: 14.fSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: appTheme.light_blue_900,
                      ),
                    ),
                    Icon(
                      Icons.edit_outlined,
                      color: appTheme.light_blue_900,
                      size: 18.h,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Divider
                Container(
                  width: double.infinity,
                  height: 1,
                  color: appTheme.grey200,
                ),
                SizedBox(height: 12.h),
                Text(
                  'View and update your profile details here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.fSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: appTheme.blue_gray_400,
                  ),
                ),
                SizedBox(height: 16.h),

                // Fields
                AuthTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hintText: 'Enter full name',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: appTheme.light_blue_900,
                    size: 20.h,
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                SizedBox(height: 14.h),
                AuthTextField(
                  controller: _emailController,
                  label: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Enter email address',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: appTheme.light_blue_900,
                    size: 20.h,
                  ),
                ),
                SizedBox(height: 14.h),
                AuthTextField(
                  controller: _phoneController,
                  label: 'Phone number',
                  keyboardType: TextInputType.phone,
                  hintText: 'Enter phone number',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: appTheme.light_blue_900,
                    size: 20.h,
                  ),
                ),
                SizedBox(height: 14.h),
                AuthTextField(
                  controller: _addressController,
                  label: 'Default delivery address',
                  hintText: 'Enter delivery address',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: appTheme.light_blue_900,
                    size: 20.h,
                  ),
                ),
                SizedBox(height: 20.h),

                // Save Changes Button
                CustomButton(
                  text: 'Save Changes',
                  onPressed: () {
                    //TODO: Integrate save functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated')),
                    );
                  },
                  backgroundColor: appTheme.light_blue_900,
                  textColor: appTheme.white_A700,
                  isFullWidth: true,
                  borderRadius: 12.h,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        },
      ),
    );
  }
}