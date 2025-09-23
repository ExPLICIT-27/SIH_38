import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:blue_carbon_app/presentation/screens/auth/otp_screen.dart';
import 'package:blue_carbon_app/presentation/screens/auth/signup_screen.dart';
import 'package:blue_carbon_app/presentation/widgets/common/custom_button.dart';
import 'package:blue_carbon_app/presentation/widgets/common/custom_text_field.dart';
import 'package:blue_carbon_app/data/models/models.dart';
import 'package:blue_carbon_app/data/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // New properties for enhanced login
  List<OrganizationModel> _userOrganizations = [];
  bool _isLoadingOrganizations = false;
  bool _showOrganizations = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _requestOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(RequestOtpEvent(_emailController.text.trim()));
    }
  }

  Future<void> _loadUserOrganizations() async {
    setState(() {
      _isLoadingOrganizations = true;
    });

    try {
      // In a real app, this would be a specific endpoint to get user's organizations
      // For now, we'll get all organizations and filter later
      final apiService = context.read<ApiService>();
      final allOrgs = await apiService.getOrganizations();

      // TODO: Filter organizations based on user membership
      // This would require a backend endpoint like: GET /v1/users/me/organizations
      setState(() {
        _userOrganizations = allOrgs;
        _isLoadingOrganizations = false;
        _showOrganizations = true;
      });
    } catch (e) {
      setState(() {
        _isLoadingOrganizations = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load organizations: $e'),
            backgroundColor: AppColors.coralPink,
          ),
        );
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSent) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => OtpScreen(email: state.email)));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.coralPink),
            );
          } else if (state is AuthAuthenticated) {
            // After successful login, show user organization info
            _loadUserOrganizations();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: AppColors.coastalGradient,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.coastalTeal.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.waves,
                              size: 40,
                              color: AppColors.pearlWhite.withOpacity(0.3),
                            ),
                            const Icon(
                              Icons.water_drop,
                              size: 60,
                              color: AppColors.pearlWhite,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.deepOceanBlue),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue to Blue Carbon MRV',
                      style:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.charcoal.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 40),

                    // Email input
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email address',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 24),

                    // Login actions
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthAuthenticated && _showOrganizations) {
                          return _buildUserProfile(state.user);
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomButton(
                              label: 'Request OTP',
                              isLoading: state is AuthLoading,
                              onPressed: _requestOtp,
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed('/home');
                              },
                              child: const Text('Skip for now'),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Sign up link
                    if (!_showOrganizations)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? ", style: Theme.of(context).textTheme.bodyMedium),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupScreen()));
                            },
                            child: Text(
                              'Sign Up',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.coastalTeal, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.coastalTeal,
                  child: Text(
                    user.email[0].toUpperCase(),
                    style: const TextStyle(color: AppColors.pearlWhite, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _getRoleDisplayName(user.role),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.coastalTeal,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Organizations section
            Text(
              'Your Organizations',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (_isLoadingOrganizations)
              const Center(child: CircularProgressIndicator())
            else if (_userOrganizations.isEmpty)
              Text(
                'No organizations found. You may need to join an organization.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.charcoal.withOpacity(0.7),
                    ),
              )
            else
              ...(_userOrganizations.map((org) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.pearlWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.charcoal.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.business,
                          color: AppColors.coastalTeal,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                org.name,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${org.type} • ${org.mode.name.toUpperCase()}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.charcoal.withOpacity(0.7),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.verified,
                          color: AppColors.coastalTeal,
                          size: 16,
                        ),
                      ],
                    ),
                  ))),

            const SizedBox(height: 16),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                label: 'Continue to Dashboard',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
            ),

            const SizedBox(height: 8),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                  setState(() {
                    _showOrganizations = false;
                    _userOrganizations.clear();
                  });
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'System Administrator';
      case UserRole.orgAdmin:
        return 'Organization Administrator';
      case UserRole.member:
        return 'Member';
      case UserRole.verifier:
        return 'Data Verifier';
    }
  }
}
