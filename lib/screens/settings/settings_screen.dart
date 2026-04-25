import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:hunargah/main.dart';
import 'package:hunargah/security/secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showSignOutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to logout of HunarGah?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              signOutUser(context);
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

  Future<void> signOutUser(BuildContext context) async {
    await FirebaseService().signOutUser();

    if (!context.mounted) return;

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logged out successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = FirebaseAuth.instance.currentUser;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: 'Settings',
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: isDark ? Colors.white : Colors.black87),
            onPressed: () {
              // Search action
            },
          ),
        ],
      ),
      body: currentUser == null ? Center(child: Text("Not logged in", style: TextStyle(color: isDark ? Colors.white : Colors.black))) : FutureBuilder<DocumentSnapshot>(
        future: FirebaseService().getUserProfile(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: themeColor,));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text(
                "User profile not found", style: TextStyle(color: textColor)));
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String userLanguage = (userData['language'] != null &&
              userData['language']
                  .toString()
                  .isNotEmpty) ? userData['language'].toString().toUpperCase() : 'English (US)';
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // -- Profile Header --
                _buildProfileHeader(userData, currentUser, isDark, themeColor),

                const SizedBox(height: 32),

                // -- Account & Appearance --
                _buildSectionHeader('ACCOUNT & APPEARANCE'),

                _buildSettingsTile(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    subtitle: 'Name, email, and phone number',
                    iconColor: themeColor,
                    context: context
                ),
                _buildSettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: isDark ? 'Enabled' : 'Disabled',
                  iconColor: themeColor,
                  context: context,
                  trailing: Switch(
                    value: isDark,
                    onChanged: (value) async {
                      themeNotifier.value =
                      value ? ThemeMode.dark : ThemeMode.light;
                      await SecureStorage.saveTheme(value ? 'dark' : 'light');
                    },
                    activeThumbColor: themeColor,
                  ),
                ),
                _buildSettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: userLanguage,
                  iconColor: themeColor,
                  context: context,
                ),

                const SizedBox(height: 24),

                // -- Security & Privacy --
                _buildSectionHeader('SECURITY & PRIVACY'),

                _buildSettingsTile(
                  icon: Icons.lock_outline,
                  title: 'Password & Security',
                  subtitle: 'Update your credentials',
                  iconColor: themeColor,
                  context: context,
                ),
                _buildSettingsTile(
                  icon: Icons.security_outlined,
                  title: 'Privacy Controls',
                  subtitle: 'Manage what data we share',
                  iconColor: themeColor,
                  context: context,
                ),
                _buildSettingsTile(
                  icon: Icons.notifications_none_outlined,
                  title: 'Notifications',
                  subtitle: 'Push, Email, and SMS',
                  iconColor: themeColor,
                  context: context,
                ),

                const SizedBox(height: 24),

                // -- Support & Help --
                _buildSectionHeader('SUPPORT & HELP'),

                _buildSettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'FAQs and user guides',
                  iconColor: themeColor,
                  context: context,
                ),
                _buildSettingsTile(
                  icon: Icons.chat_bubble_outline,
                  title: 'Contact Support',
                  subtitle: 'Chat with our 24/7 team',
                  iconColor: themeColor,
                  context: context,
                ),
                _buildSettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  subtitle: 'Read the terms of our app',
                  iconColor: themeColor,
                  context: context,
                  onTap: () => Navigator.pushNamed(context, '/terms'),
                ),

                const SizedBox(height: 24),

                // -- Premium Upgrade Card --
                _buildPremiumCard(themeColor, isDark),

                const SizedBox(height: 16),

                // -- Sign Out Button --
                _buildSettingsTile(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  subtitle: 'Log out of your account',
                  iconColor: Colors.redAccent,
                  titleColor: Colors.redAccent,
                  showChevron: false,
                  context: context,
                  onTap: () => _showSignOutDialog(context),
                ),

                const SizedBox(height: 32),

                // -- Footer --
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
                const SizedBox(height: 40),
              ],
            ),
          );
        }
        ),
    );
  }

  // Reusable Widget: Profile Header

  Widget _buildProfileHeader(Map<String, dynamic> userData, User currentUser, bool isDark, Color themeColor) {
    final textColor = isDark ? Colors.white : Colors.black87;

        String? imageString = userData['profileImageUrl'];
        ImageProvider? imageProvider;

        if (imageString != null && imageString.isNotEmpty) {
          if (imageString.startsWith('http')) {
            imageProvider = NetworkImage(imageString);
          } else {
            try {
              final String cleanBase64 = imageString.contains(',')
                  ? imageString.split(',').last
                  : imageString;
              imageProvider = MemoryImage(base64Decode(cleanBase64));
            } catch (e) {
              debugPrint('Error decoding base64 image: $e');
            }
          }
        }

        imageProvider ??= const NetworkImage('https://i.pravatar.cc/150?img=11');

        return Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: themeColor.withValues(alpha: 0.2),
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: imageProvider,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: isDark ? Colors.grey[800]! : Colors.white, width: 2),
                    ),
                    child: Icon(Icons.verified, color: themeColor, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              userData['username'] ?? 'HunarGah User',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userData['email'] ?? currentUser.email ?? 'No email provided',
              style: TextStyle(fontSize: 14, color: isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                userData['role']?.toString().toUpperCase() ?? 'LEARNER',
                style: TextStyle(
                  color: themeColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        );
  }

  // Reusable Widget: Section Header
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

  // Reusable Widget: Settings Tile
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required BuildContext context,
    Color? titleColor,
    Widget? trailing,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 4.0,
      ),
      onTap: onTap ?? () {},
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
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
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[500]),
            )
          : null,
      trailing:
          trailing ??
          (showChevron
              ? Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDark ? Colors.grey[600] : Colors.grey,
                )
              : null),
    );
  }

  // Reusable Widget: Premium Upgrade Card
  Widget _buildPremiumCard(Color themeColor, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : themeColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.credit_card, color: themeColor, size: 24),
              const SizedBox(width: 12),
              Text(
                'Premium Membership',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: Text(
              'Unlock advanced insights and priority support today.',
              style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey[700]),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: ElevatedButton(
              onPressed: () {
                // Upgrade logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text(
                'Upgrade Now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
