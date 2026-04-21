import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/database/firebase_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: 'Settings',
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // Search action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // -- Profile Header --
            _buildProfileHeader(),

            const SizedBox(height: 32),

            // -- Account & Appearance --
            _buildSectionHeader('ACCOUNT & APPEARANCE'),

            _buildSettingsTile(
              icon: Icons.person_outline,
              title: 'Personal Information',
              subtitle: 'Name, email, and phone number',
              iconColor: themeColor,
            ),
            _buildSettingsTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: isDarkMode ? 'Enabled' : 'Disabled',
              iconColor: themeColor,
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
                activeThumbColor: themeColor,
              ),
            ),
            _buildSettingsTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'English (US)',
              iconColor: themeColor,
            ),

            const SizedBox(height: 24),

            // -- Security & Privacy --
            _buildSectionHeader('SECURITY & PRIVACY'),

            _buildSettingsTile(
              icon: Icons.lock_outline,
              title: 'Password & Security',
              subtitle: 'Update your credentials',
              iconColor: themeColor,
            ),
            _buildSettingsTile(
              icon: Icons.security_outlined,
              title: 'Privacy Controls',
              subtitle: 'Manage what data we share',
              iconColor: themeColor,
            ),
            _buildSettingsTile(
              icon: Icons.notifications_none_outlined,
              title: 'Notifications',
              subtitle: 'Push, Email, and SMS',
              iconColor: themeColor,
            ),

            const SizedBox(height: 24),

            // -- Support & Help --
            _buildSectionHeader('SUPPORT & HELP'),

            _buildSettingsTile(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'FAQs and user guides',
              iconColor: themeColor,
            ),
            _buildSettingsTile(
              icon: Icons.chat_bubble_outline,
              title: 'Contact Support',
              subtitle: 'Chat with our 24/7 team',
              iconColor: themeColor,
            ),
            _buildSettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: '',
              iconColor: themeColor,
            ),

            const SizedBox(height: 24),

            // -- Premium Upgrade Card --
            _buildPremiumCard(),

            const SizedBox(height: 16),

            // -- Sign Out Button --
            _buildSettingsTile(
              icon: Icons.logout,
              title: 'Sign Out',
              subtitle: 'Log out of your account',
              iconColor: Colors.redAccent,
              titleColor: Colors.redAccent,
              showChevron: false,
              onTap: () {
                _showSignOutDialog(context);
              },
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
      ),
    );
  }

  // Reusable Widget: Profile Header

  Widget _buildProfileHeader() {
    final themeColor = Theme.of(context).primaryColor;

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
              child: const CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80',
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(Icons.verified, color: themeColor, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Sarah Jenkins',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'sarah.j@modernapp.io',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: themeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'PRO MEMBER',
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
    Color titleColor = Colors.black87,
    Widget? trailing,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
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
          color: titleColor,
        ),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            )
          : null,
      trailing:
          trailing ??
          (showChevron
              ? const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                )
              : null),
    );
  }

  // Reusable Widget: Premium Upgrade Card
  Widget _buildPremiumCard() {
    final themeColor = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: 0.05),
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
              const Text(
                'Premium Membership',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: Text(
              'Unlock advanced insights and priority support today.',
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
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
