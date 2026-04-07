import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isCreatorMode = false;
  int _selectedTabIndex = 0;

  void _showShareBottomSheet(BuildContext context) {
    final Color themeColor = const Color(0xFF00BFA5);
    final String profileLink = "hunargah.app/@alex_creativ";
    final String shareText =
        "Check out Alex Chen's profile on Hunargah: $profileLink";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(
            top: 12,
            left: 24,
            right: 24,
            bottom: 32,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- Drag Handle --
              dragHandle(),

              // -- Title --
              shareTitle(),

              const SizedBox(height: 24),

              // -- Social Icons Row --
              socialIcons(context, shareText),

              const SizedBox(height: 32),

              // -- Copy Link Box --
              copyLink(),

              const SizedBox(height: 8),

              copyLinkButton(profileLink, context, themeColor),
            ],
          ),
        );
      },
    );
  }

  Container copyLinkButton(
    String profileLink,
    BuildContext context,
    Color themeColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.link, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              profileLink,
              style: TextStyle(color: Colors.grey[800], fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () async {
              // Native copy to clipboard functionality
              await Clipboard.setData(ClipboardData(text: profileLink));

              if (context.mounted) {
                Navigator.pop(context); // Close the bottom sheet
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Link copied to clipboard!'),
                    backgroundColor: themeColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Copy',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text copyLink() {
    return const Text(
      'Page Link',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  SingleChildScrollView socialIcons(BuildContext context, String shareText) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildShareIcon(
            icon: Icons.chat_bubble,
            label: 'WhatsApp',
            bgColor: const Color(0xFF25D366),
            onTap: () {
              // Use url_launcher to open a wa.me link
              Navigator.pop(context);
            },
          ),
          _buildShareIcon(
            icon: Icons.facebook,
            label: 'Facebook',
            bgColor: const Color(0xFF1877F2),
            onTap: () {
              // Use url_launcher to open FB intent
              Navigator.pop(context);
            },
          ),
          _buildShareIcon(
            icon: Icons.alternate_email,
            label: 'Twitter',
            bgColor: Colors.black,
            onTap: () {
              // Use url_launcher for twitter intent
              Navigator.pop(context);
            },
          ),
          _buildShareIcon(
            icon: Icons.more_horiz,
            label: 'More',
            bgColor: Colors.grey[700]!,
            onTap: () {
              // Close the bottom sheet first so it doesn't block the native UI
              Navigator.pop(context);

              // Trigger the iOS/Android native share menu!
              SharePlus.instance.share(ShareParams(text: shareText));
            },
          ),
        ],
      ),
    );
  }

  Text shareTitle() {
    return const Text(
      'Share Profile',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Center dragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: '@alex_creativity',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -- Profile Header(Avatar & Stats) --
            avatarAndStats(),

            // -- Bio Section --
            profileBio(),

            const SizedBox(height: 20),

            // -- Action Buttons --
            profileActionButtons(themeColor),

            const SizedBox(height: 20),

            // -- Creator Toggle --
            switchToCreator(themeColor),

            const SizedBox(height: 24),

            // -- Custom Tabs --
            customTabs(),

            Divider(color: Colors.grey[200], height: 1, thickness: 1),

            const SizedBox(height: 16),

            // -- Grid View --
            if (_selectedTabIndex == 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.85, // Adjusts height vs width of cards
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return _buildGridCard(index);
                  },
                ),
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text(
                    'No certificates yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Row customTabs() {
    return Row(
      children: [
        _buildTabItem(0, 'Saved', Icons.bookmark_outline),
        _buildTabItem(1, 'Certificates', Icons.workspace_premium_outlined),
      ],
    );
  }

  Padding switchToCreator(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.bolt, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Switch to Creator',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Access analytics & monetization',
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isCreatorMode,
              activeThumbColor: themeColor,
              onChanged: (val) {
                setState(() {
                  _isCreatorMode = val;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding profileActionButtons(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/edit-profile');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showShareBottomSheet(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Share Profile',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding profileBio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Alex Chen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.verified, color: Colors.cyan[400], size: 18),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Digital Product Designer & Tech Educator. Helping 10k+ students master modern UI/UX workflows. 🚀',
            style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 12),
          // Tags
          Row(
            children: [
              _buildTag('UI/UX Design'),
              const SizedBox(width: 8),
              _buildTag('Education'),
            ],
          ),
        ],
      ),
    );
  }

  Padding avatarAndStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          // Avatar with Online Status Dot
          profileAvatar(),

          const SizedBox(width: 24),

          // Stats
          profileStats(),
        ],
      ),
    );
  }

  Expanded profileStats() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatColumn('128', 'Posts'),
          _buildStatColumn('14.2k', 'Followers'),
          _buildStatColumn('842', 'Following'),
        ],
      ),
    );
  }

  Stack profileAvatar() {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.green[500],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
        ),
      ],
    );
  }

  // Reusable Widget: Build Stat Column
  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  // Reusable Widget: Build Bio Tag
  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  // Reusable Widget: Build custom tabs
  Widget _buildTabItem(int index, String title, IconData icon) {
    final themeColor = Theme.of(context).primaryColor;
    bool isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? themeColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.black87 : Colors.grey[500],
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black87 : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Widget: Build Grid Items
  Widget _buildGridCard(int index) {
    // Mock data for the visual
    final List<Map<String, String>> mockData = [
      {
        'title': 'UI Inspiration',
        'count': '24 items',
        'image':
            'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=300&auto=format&fit=crop',
      },
      {
        'title': 'Color Palettes',
        'count': '12 items',
        'image':
            'https://images.unsplash.com/photo-1550684848-fac1c5b4e853?q=80&w=300&auto=format&fit=crop',
      },
      {
        'title': 'UX Research',
        'count': '8 items',
        'image':
            'https://images.unsplash.com/photo-1542435503-956c469947f6?q=80&w=300&auto=format&fit=crop',
      },
      {
        'title': 'Case Studies',
        'count': '15 items',
        'image':
            'https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=300&auto=format&fit=crop',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(mockData[index]['image']!),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Item count pill at bottom right
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      mockData[index]['count']!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          mockData[index]['title']!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Resuable Widget: Build share icon + label for bottom sheet
  Widget _buildShareIcon({
    required IconData icon,
    required String label,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: bgColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
