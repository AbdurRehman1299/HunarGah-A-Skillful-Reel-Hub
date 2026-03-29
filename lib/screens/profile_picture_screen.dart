import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  // Holds the selected Image file
  File? _profileImage;

  // The tool that opens the phone's gallery/camera
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality:
            80, // Compress the image quality to save space in database
        maxHeight: 400,
        maxWidth: 400,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image $e");
    }
  }

  // Function to show Bottom Sheet (Camera vs Gallery Choice)
  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
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

                cameraListTile(context),
                galleryListTile(context),
              ],
            ),
          ),
        );
      },
    );
  }

  ListTile galleryListTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.photo_library, color: Colors.teal),
      title: const Text('Choose from Gallery'),
      onTap: () {
        Navigator.pop(context);
        _pickImage(ImageSource.gallery);
      },
    );
  }

  ListTile cameraListTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.camera_alt, color: Colors.teal),
      title: const Text('Take a photo'),
      onTap: () {
        Navigator.pop(context); // Close the bottom sheet
        _pickImage(ImageSource.camera);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    // Check if the user has uploaded the image or not
    final bool hasImage = _profileImage != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: 'Profile Picture',
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // -- Heading Section --
              headerSection(),

              const SizedBox(height: 12),

              descriptionSection(),

              const SizedBox(height: 48),

              // -- Avatar Section --
              avatarSection(themeColor, hasImage),

              const Spacer(),

              // -- Button Section --
              // Primary "Continue" button
              buttonSection(context, themeColor, hasImage),

              const SizedBox(height: 16),

              // "Skip for now" Button (Only show if user hasn't picked an image yet)
              if (!hasImage)
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              if (hasImage) const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Text descriptionSection() {
    return Text(
      'Put a face to your name. This helps Ustads\nand other learners recognize you.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
    );
  }

  Text headerSection() {
    return const Text(
      'Add a Profile Picture',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
    );
  }

  GestureDetector avatarSection(Color themeColor, bool hasImage) {
    return GestureDetector(
      onTap: _showImageSourceBottomSheet,
      child: Stack(
        children: [
          // The main image circular image
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
                      image: FileImage(_profileImage!),
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

          // The little Camera Badge at the bottom right
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

  SizedBox buttonSection(
    BuildContext context,
    Color themeColor,
    bool hasImage,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/dashboard');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          elevation: 0,
        ),
        child: Row(
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
            const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
