import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/view/components/app_bar.dart';
import 'package:hunargah/viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    final themeColor = Theme.of(context).primaryColor;

    return Obx(() {
      final bool isDark = controller.isDark.value;
      final Color textColor = isDark ? Colors.white : Colors.black87;

      return Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        appBar: CustomAppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Get.back(),
          ),
          title: 'Settings',
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: textColor),
              onPressed: () {},
            ),
          ],
        ),
        body: controller.isLoading.value
            ? Center(child: CircularProgressIndicator(color: themeColor))
            : controller.userData.isEmpty
            ? const Center(child: Text("User profile not found"))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildProfileHeader(controller, themeColor, isDark),
                    const SizedBox(height: 32),

                    _buildSectionHeader('ACCOUNT & APPEARANCE'),
                    _buildSettingsTile(
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                      subtitle: 'Name, email, and phone number',
                      iconColor: themeColor,
                      isDark: isDark,
                    ),
                    _buildSettingsTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      subtitle: isDark ? 'Enabled' : 'Disabled',
                      iconColor: themeColor,
                      isDark: isDark,
                      trailing: Switch(
                        value: isDark,
                        onChanged: controller.toggleTheme,
                        activeThumbColor: themeColor,
                      ),
                    ),
                    _buildSettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle:
                          controller.userData['language']
                              ?.toString()
                              .toUpperCase() ??
                          'ENGLISH (US)',
                      iconColor: themeColor,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 24),
                    _buildSectionHeader('SECURITY & PRIVACY'),
                    _buildSettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Password & Security',
                      subtitle: 'Update your credentials',
                      iconColor: themeColor,
                      isDark: isDark,
                    ),
                    _buildSettingsTile(
                      icon: Icons.notifications_none_outlined,
                      title: 'Notifications',
                      subtitle: 'Push, Email, and SMS',
                      iconColor: themeColor,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 24),
                    _buildPremiumCard(themeColor, isDark),
                    const SizedBox(height: 16),

                    _buildSettingsTile(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      subtitle: 'Log out of your account',
                      iconColor: Colors.redAccent,
                      titleColor: Colors.redAccent,
                      showChevron: false,
                      isDark: isDark,
                      onTap: () => _showSignOutDialog(context, controller),
                    ),

                    const SizedBox(height: 32),
                    footerSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
      );
    });
  }

  // --- UI Components ---

  void _showSignOutDialog(BuildContext context, SettingsController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: controller.isDark.value
            ? Colors.grey[900]
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to logout of HunarGah?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.signOut();
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    SettingsController controller,
    Color themeColor,
    bool isDark,
  ) {
    final data = controller.userData;
    ImageProvider imageProvider = const NetworkImage(
      'https://i.pravatar.cc/150?img=11',
    );

    String? imgStr = data['profileImageUrl'];
    if (imgStr != null && imgStr.isNotEmpty) {
      if (imgStr.startsWith('http')) {
        imageProvider = NetworkImage(imgStr);
      } else {
        try {
          imageProvider = MemoryImage(base64Decode(imgStr.split(',').last));
        } catch (_) {}
      }
    }

    return Column(
      children: [
        CircleAvatar(radius: 40, backgroundImage: imageProvider),
        const SizedBox(height: 12),
        Text(
          data['username'] ?? 'User',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          data['email'] ?? '',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
        const SizedBox(height: 12),
        Chip(
          label: Text(
            data['role']?.toString().toUpperCase() ?? 'LEARNER',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          backgroundColor: themeColor.withValues(alpha: isDark ? 0.1 : 0.08),
          side: BorderSide(color: themeColor),
          labelStyle: TextStyle(color: themeColor),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required bool isDark,
    Color? titleColor,
    Widget? trailing,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: iconColor.withValues(alpha: 0.1),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: titleColor ?? (isDark ? Colors.white : Colors.black87),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
      trailing:
          trailing ??
          (showChevron
              ? const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey,
                )
              : null),
    );
  }

  Widget _buildPremiumCard(Color themeColor, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : themeColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: themeColor),
              const SizedBox(width: 8),
              Text(
                'Premium Membership',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              minimumSize: const Size(double.infinity, 40),
            ),
            child: const Text(
              'Upgrade Now',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget footerSection() {
    return Column(
      children: [
        Text(
          'Version 1.0.0',
          style: TextStyle(color: Colors.grey[500], fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          'MADE WITH ❤️ FOR MODERN USERS',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 10,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
