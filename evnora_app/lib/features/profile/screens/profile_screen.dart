import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../config/routes.dart';
import '../../../config/themes.dart';
import '../../../config/constants.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/custom_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(context, user?.fullName ?? '', user?.email ?? '', user?.profileImage),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: AppColors.white),
                onPressed: () {
                  // TODO: Navigate to settings
                },
              ),
            ],
          ),
          
          // Profile Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Stats
                  _buildStatsCard(context),
                  
                  const SizedBox(height: 24),
                  
                  // Profile Completion
                  if (user != null && !user.isProfileComplete)
                    _buildProfileCompletionCard(context),
                  
                  const SizedBox(height: 24),
                  
                  // Menu Items
                  _buildMenuSection(
                    context,
                    title: 'My Profile',
                    items: [
                      _MenuItem(
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        onTap: () => context.push(AppRoutes.editProfile),
                      ),
                      _MenuItem(
                        icon: Icons.description_outlined,
                        title: 'My Resume',
                        subtitle: user?.resumeUrl != null ? 'Uploaded' : 'Not uploaded',
                        onTap: () {
                          // TODO: View resume
                        },
                      ),
                      _MenuItem(
                        icon: Icons.edit_document,
                        title: 'Resume Builder',
                        subtitle: 'Create ATS-friendly resume',
                        onTap: () => context.push(AppRoutes.resumeBuilder),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildMenuSection(
                    context,
                    title: 'My Activities',
                    items: [
                      _MenuItem(
                        icon: Icons.work_outline,
                        title: 'Applied Jobs',
                        onTap: () {
                          // TODO: Navigate to applied jobs
                        },
                      ),
                      _MenuItem(
                        icon: Icons.bookmark_outline,
                        title: 'Saved Jobs',
                        onTap: () {
                          // TODO: Navigate to saved jobs
                        },
                      ),
                      _MenuItem(
                        icon: Icons.school_outlined,
                        title: 'My Programs',
                        onTap: () {
                          // TODO: Navigate to enrolled programs
                        },
                      ),
                      _MenuItem(
                        icon: Icons.verified_outlined,
                        title: 'My Certificates',
                        onTap: () => context.push(AppRoutes.certificates),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildMenuSection(
                    context,
                    title: 'Settings',
                    items: [
                      _MenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        onTap: () {
                          // TODO: Navigate to notifications settings
                        },
                      ),
                      _MenuItem(
                        icon: Icons.location_on_outlined,
                        title: 'Location Preferences',
                        onTap: () {
                          // TODO: Navigate to location settings
                        },
                      ),
                      _MenuItem(
                        icon: Icons.lock_outline,
                        title: 'Privacy & Security',
                        onTap: () {
                          // TODO: Navigate to privacy settings
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildMenuSection(
                    context,
                    title: 'Support',
                    items: [
                      _MenuItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {
                          // TODO: Navigate to help
                        },
                      ),
                      _MenuItem(
                        icon: Icons.info_outline,
                        title: 'About Evnora',
                        onTap: () {
                          // TODO: Navigate to about
                        },
                      ),
                      _MenuItem(
                        icon: Icons.article_outlined,
                        title: 'Terms & Privacy Policy',
                        onTap: () {
                          // TODO: Open terms
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Logout button
                  CustomButton(
                    text: 'Logout',
                    variant: ButtonVariant.outlined,
                    icon: Icons.logout,
                    textColor: AppColors.error,
                    backgroundColor: AppColors.error,
                    onPressed: () => _showLogoutDialog(context, ref),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // App version
                  Center(
                    child: Text(
                      'Version ${AppConstants.appVersion}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.grey400,
                          ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name, String email, String? imageUrl) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.grey200,
                          child: const Icon(Icons.person, size: 50, color: AppColors.grey400),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.grey200,
                          child: const Icon(Icons.person, size: 50, color: AppColors.grey400),
                        ),
                      )
                    : Container(
                        color: AppColors.white,
                        child: Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            // Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 4),
            // Email
            Text(
              email,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey900.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, '12', 'Applied'),
          _buildDivider(),
          _buildStatItem(context, '5', 'Saved'),
          _buildDivider(),
          _buildStatItem(context, '2', 'Programs'),
          _buildDivider(),
          _buildStatItem(context, '3', 'Certificates'),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey500,
              ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.grey200,
    );
  }

  Widget _buildProfileCompletionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary.withOpacity(0.1), AppColors.secondary.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete your profile',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add your skills and resume to get noticed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey600,
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.grey400,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey900.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: item.subtitle != null
                        ? Text(
                            item.subtitle!,
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        : null,
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.grey400,
                    ),
                    onTap: item.onTap,
                  ),
                  if (index < items.length - 1)
                    const Divider(height: 1, indent: 72),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authStateProvider.notifier).logout();
              context.go(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });
}
