import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/data/models/user_model.dart';
import 'package:blue_carbon_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:blue_carbon_app/presentation/screens/auth/login_screen.dart';
import 'package:blue_carbon_app/presentation/widgets/common/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), backgroundColor: AppColors.deepOceanBlue),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(
              context,
            ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return _buildProfileContent(state.user);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildProfileContent(UserModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(user),
          const SizedBox(height: 24),
          _buildSectionTitle('Account'),
          _buildAccountSection(user),
          const SizedBox(height: 24),
          _buildSectionTitle('App Settings'),
          _buildSettingsSection(),
          const SizedBox(height: 24),
          _buildSectionTitle('About'),
          _buildAboutSection(),
          const SizedBox(height: 32),
          CustomButton(
            label: 'Sign Out',
            icon: Icons.logout,
            isOutlined: true,
            backgroundColor: Colors.transparent,
            textColor: AppColors.coralPink,
            onPressed: () {
              _showSignOutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader(UserModel user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.coastalTeal.withOpacity(0.2),
          child: Text(
            user.email.substring(0, 1).toUpperCase(),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.deepOceanBlue),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.email, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRoleColor(user.role).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getRoleName(user.role),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _getRoleColor(user.role)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.deepOceanBlue),
      ),
    );
  }

  Widget _buildAccountSection(UserModel user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildListTile('Email Address', user.email, Icons.email),
          const Divider(height: 1),
          _buildListTile('Account Created', _formatDate(user.createdAt), Icons.calendar_today),
          const Divider(height: 1),
          _buildListTile('Role', _getRoleName(user.role), Icons.badge),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            secondary: Icon(Icons.dark_mode, color: AppColors.deepOceanBlue),
            value: _isDarkMode,
            activeColor: AppColors.coastalTeal,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              // TODO: Implement theme switching
            },
          ),
          const Divider(height: 1),
          _buildListTile(
            'Notifications',
            'Manage notification settings',
            Icons.notifications,
            showArrow: true,
            onTap: () {
              // TODO: Navigate to notification settings
            },
          ),
          const Divider(height: 1),
          _buildListTile(
            'Privacy',
            'Privacy and data settings',
            Icons.privacy_tip,
            showArrow: true,
            onTap: () {
              // TODO: Navigate to privacy settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildListTile('Version', '1.0.0', Icons.info),
          const Divider(height: 1),
          _buildListTile(
            'Terms of Service',
            'Read our terms and conditions',
            Icons.description,
            showArrow: true,
            onTap: () {
              // TODO: Navigate to terms of service
            },
          ),
          const Divider(height: 1),
          _buildListTile(
            'Privacy Policy',
            'Read our privacy policy',
            Icons.policy,
            showArrow: true,
            onTap: () {
              // TODO: Navigate to privacy policy
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, IconData icon, {bool showArrow = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.coastalTeal),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: AppColors.charcoal.withOpacity(0.7))),
      trailing: showArrow ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
      onTap: onTap,
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: AppColors.charcoal)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutEvent());
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.coralPink),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.orgAdmin:
        return 'Organization Admin';
      case UserRole.verifier:
        return 'Verifier';
      case UserRole.member:
        return 'Member';
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppColors.deepOceanBlue;
      case UserRole.orgAdmin:
        return AppColors.coastalTeal;
      case UserRole.verifier:
        return AppColors.seagrassGreen;
      case UserRole.member:
        return AppColors.mangroveDark;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }
}
