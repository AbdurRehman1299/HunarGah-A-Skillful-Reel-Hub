import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  String? _base64Image;
  File? _newImage;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fetch User's Data
  Future<void> _loadUserData() async {
    try {
      final userData = await FirebaseService().getUserData();

      if (userData != null) {
        setState(() {
          _nameController.text = userData['username'] ?? '';
          _cityController.text = userData['city'] ?? '';
          _base64Image = userData['profileImageUrl'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (pickedFile != null) {
        setState(() {
          _newImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  // Save User's Data
  Future<void> _saveUserData() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    String? finalBase64Image = _base64Image;
    if (_newImage != null) {
      List<int> imageBytes = await _newImage!.readAsBytes();
      finalBase64Image = base64Encode(imageBytes);
    }

    final String? errorMessage = await FirebaseService().updateProfileDetails(
      _nameController.text.trim(),
      _cityController.text.trim(),
      profileImageUrl: finalBase64Image,
    );

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  ImageProvider? _getProfileImage() {
    if (_newImage != null) {
      return FileImage(_newImage!);
    } else if (_base64Image != null && _base64Image!.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(_base64Image!));
      } catch (e) {
        return null;
      }
    }
    return const NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: 'Account Settings',
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(color: themeColor)) : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -- Profile Photo Section --
                  profilePhotoSection(themeColor, isDark),

                  const SizedBox(height: 32),

                  // -- Personal Identification Section --
                  _buildSectionHeader(
                    'Personal Identification',
                    'Update your display name as it appears to other members.',
                    isDark,
                  ),

                  const SizedBox(height: 16),

                  // Name Input Card
                  nameInput(isDark),

                  const SizedBox(height: 32),

                  // -- Local Community Section --
                  _buildSectionHeader(
                    'Local Community',
                    'Setting your city helps us show you relevant local events.',
                    isDark,
                  ),

                  const SizedBox(height: 16),

                  // Location Input Card
                  locationInput(themeColor, isDark),

                  const SizedBox(height: 24),

                  // -- Info Alert Box --
                  infoAlert(themeColor, isDark),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // -- Save Button --
          saveButton(themeColor, isDark),
        ],
      ),
    );
  }

  Container saveButton(Color themeColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(color: isDark ? Colors.grey[900] : Colors.white),
      child: ElevatedButton.icon(
        onPressed: _isSaving ? null : _saveUserData,
        icon: _isSaving ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
        ) : Icon(Icons.save_outlined, color: Colors.white, size: 20),
        label: Text(
          _isSaving ? 'Saving..' : 'Save Changes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          disabledBackgroundColor: themeColor.withValues(alpha: 0.6),
          minimumSize: const Size(double.infinity, 54),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Container infoAlert(Color themeColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? themeColor.withValues(alpha: 0.1) : themeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: themeColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your name and city will be visible on your public profile. You can change these settings at any time in your privacy dashboard.',
              style: TextStyle(
                color: themeColor,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container locationInput(Color themeColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'City / Location',
            style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 8),
          _buildCustomTextField(
            controller: _cityController,
            icon: Icons.location_on_outlined,
            isDark: isDark,
          ),
          const SizedBox(height: 16),

          // Location suggestion chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDetectLocationChip(themeColor, isDark),
                const SizedBox(width: 8),
                _buildStandardChip('Lahore', isDark),
                const SizedBox(width: 8),
                _buildStandardChip('Karachi', isDark),
                const SizedBox(width: 8),
                _buildStandardChip('Islamabad', isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container nameInput(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Full Name',
            style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 8),
          _buildCustomTextField(
            controller: _nameController,
            icon: Icons.person_outline,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: isDark ? Colors.grey[400] : Colors.grey[500]),
              const SizedBox(width: 6),
              Text(
                'Use your real name for verification purposes.',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Center profilePhotoSection(Color themeColor, bool isDark) {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: themeColor.withValues(alpha: 0.3),
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: _getProfileImage(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: themeColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: isDark ? Colors.grey[900]! : Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Change Profile Photo',
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Widget: Build Header Section

  Widget _buildSectionHeader(String title, String subtitle, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600])),
      ],
    );
  }

  // Reusable Widget: Custom Text Field
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: isDark ? Colors.grey[400] : Colors.grey[500], size: 20),
          suffixIcon: Icon(
            Icons.check_circle_outline,
            color: isDark ? Colors.grey[400] : Colors.grey[800],
            size: 18,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // Reusable Widget: Detect Location Chip
  Widget _buildDetectLocationChip(Color themeColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: isDark ? 0.1 : 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: themeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.near_me, size: 14, color: themeColor),
          const SizedBox(width: 6),
          Text(
            'Detect Current',
            style: TextStyle(
              color: themeColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Widget: Standard Location Chip
  Widget _buildStandardChip(String label, bool isDark) {
    return InkWell(
      onTap: () {
        setState(() {
          _cityController.text = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
