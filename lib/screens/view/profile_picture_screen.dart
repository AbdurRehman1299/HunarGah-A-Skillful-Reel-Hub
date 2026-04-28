import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/screens/viewmodels/profile_picture_viewmodel.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureScreen extends StatelessWidget {
  const ProfilePictureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfilePictureController());

    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: 'Profile Picture',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              headerSection(isDark),
              const SizedBox(height: 12),
              descriptionSection(isDark),
              const SizedBox(height: 48),

              // -- Avatar Section --
              Obx(
                () => avatarSection(
                  themeColor,
                  controller.profileImage.value,
                  () => _showImageSourceBottomSheet(context, controller),
                ),
              ),

              const Spacer(),

              // -- Button Section --
              Obx(
                () => buttonSection(
                  themeColor,
                  controller.profileImage.value != null,
                  controller.isUploading.value,
                  controller,
                ),
              ),

              const SizedBox(height: 16),

              // "Skip for now"
              Obx(() {
                if (controller.profileImage.value != null) {
                  return const SizedBox(height: 48);
                }
                return TextButton(
                  onPressed: controller.skipStep,
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Text headerSection(bool isDark) {
    return Text(
      'Add a Profile Picture',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Text descriptionSection(bool isDark) {
    return Text(
      'Put a face to your name. This helps Ustads\nand other learners recognize you.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
        height: 1.5,
      ),
    );
  }

  Widget avatarSection(
    Color themeColor,
    dynamic imageFile,
    VoidCallback onTap,
  ) {
    final bool hasImage = imageFile != null;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: .1),
              shape: BoxShape.circle,
              border: Border.all(
                color: hasImage ? themeColor : Colors.transparent,
                width: 3,
              ),
              image: hasImage
                  ? DecorationImage(
                      image: FileImage(imageFile),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: !hasImage
                ? Icon(
                    Icons.person,
                    size: 80,
                    color: themeColor.withValues(alpha: 0.5),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Icon(
                hasImage ? Icons.edit : Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonSection(
    Color themeColor,
    bool hasImage,
    bool isUploading,
    ProfilePictureController controller,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isUploading
            ? null
            : () => hasImage
                  ? controller.saveProfilePicture()
                  : Get.offAllNamed('/dashboard'),
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          elevation: 0,
        ),
        child: isUploading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hasImage ? 'Save & Continue' : 'Continue',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
      ),
    );
  }

  void _showImageSourceBottomSheet(
    BuildContext context,
    ProfilePictureController controller,
  ) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color:
              Theme.of(context).bottomSheetTheme.backgroundColor ??
              Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose profile picture',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.teal),
                  title: const Text('Take a photo'),
                  onTap: () => controller.pickImage(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.teal),
                  title: const Text('Choose from Gallery'),
                  onTap: () => controller.pickImage(ImageSource.gallery),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
