import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:blue_carbon_app/presentation/screens/auth/otp_screen.dart';
import 'package:blue_carbon_app/presentation/widgets/common/custom_button.dart';
import 'package:blue_carbon_app/presentation/widgets/common/custom_text_field.dart';
import 'package:blue_carbon_app/data/models/models.dart';
import 'package:blue_carbon_app/data/services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _organizationNameController = TextEditingController();
  final _organizationTypeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  OrganizationModel? _selectedOrganization;
  List<OrganizationModel> _organizations = [];
  bool _isLoadingOrganizations = false;
  bool _createNewOrganization = false;
  OrganizationMode _selectedMode = OrganizationMode.seller;
  UserRole _selectedRole = UserRole.member;

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _loadOrganizations();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _organizationNameController.dispose();
    _organizationTypeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadOrganizations() async {
    setState(() {
      _isLoadingOrganizations = true;
    });

    try {
      final apiService = context.read<ApiService>();
      final organizations = await apiService.getOrganizations();
      setState(() {
        _organizations = organizations;
        _isLoadingOrganizations = false;
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

  void _nextStep() {
    if (_currentStep == 0 && _formKey.currentState?.validate() == true) {
      setState(() {
        _currentStep = 1;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentStep == 1 && _validateOrganizationStep()) {
      _requestOtp();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateOrganizationStep() {
    if (_createNewOrganization) {
      return _organizationNameController.text.trim().isNotEmpty && _organizationTypeController.text.trim().isNotEmpty;
    } else {
      return _selectedOrganization != null;
    }
  }

  void _requestOtp() {
    context.read<AuthBloc>().add(RequestOtpEvent(_emailController.text.trim()));
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.deepOceanBlue),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _currentStep >= 0 ? AppColors.coastalTeal : AppColors.charcoal.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _currentStep >= 1 ? AppColors.coastalTeal : AppColors.charcoal.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSent) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OtpScreen(
                  email: state.email,
                  isSignup: true,
                  name: _nameController.text.trim(),
                  organizationData: _createNewOrganization
                      ? {
                          'name': _organizationNameController.text.trim(),
                          'type': _organizationTypeController.text.trim(),
                          'mode': _selectedMode.name.toUpperCase(),
                        }
                      : null,
                  selectedOrganization: _selectedOrganization,
                  selectedRole: _selectedRole,
                ),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.coralPink),
            );
          }
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildPersonalInfoStep(),
                _buildOrganizationStep(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.deepOceanBlue),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us about yourself',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.charcoal.withOpacity(0.7)),
          ),
          const SizedBox(height: 40),
          CustomTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            keyboardType: TextInputType.name,
            prefixIcon: Icons.person_outline,
            validator: _validateName,
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: _validateEmail,
          ),
          const SizedBox(height: 40),
          CustomButton(
            label: 'Next',
            onPressed: _nextStep,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account? ', style: Theme.of(context).textTheme.bodyMedium),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Sign In',
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
    );
  }

  Widget _buildOrganizationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Organization',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.deepOceanBlue),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose your organization and role',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.charcoal.withOpacity(0.7)),
          ),
          const SizedBox(height: 32),

          // Organization Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio<bool>(
                        value: false,
                        groupValue: _createNewOrganization,
                        onChanged: (value) {
                          setState(() {
                            _createNewOrganization = value!;
                            _selectedOrganization = null;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Join existing organization',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  if (!_createNewOrganization) ...[
                    const SizedBox(height: 16),
                    if (_isLoadingOrganizations)
                      const Center(child: CircularProgressIndicator())
                    else if (_organizations.isEmpty)
                      Text(
                        'No organizations available. Create a new one below.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.charcoal.withOpacity(0.7),
                            ),
                      )
                    else
                      DropdownButtonFormField<OrganizationModel>(
                        value: _selectedOrganization,
                        decoration: InputDecoration(
                          labelText: 'Select Organization',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _organizations.map((org) {
                          return DropdownMenuItem(
                            value: org,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(org.name, style: Theme.of(context).textTheme.bodyMedium),
                                Text(
                                  '${org.type} • ${org.mode.name.toUpperCase()}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.charcoal.withOpacity(0.7),
                                      ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedOrganization = value;
                          });
                        },
                      ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Create New Organization
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _createNewOrganization,
                        onChanged: (value) {
                          setState(() {
                            _createNewOrganization = value!;
                            _selectedOrganization = null;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Create new organization',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  if (_createNewOrganization) ...[
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _organizationNameController,
                      label: 'Organization Name',
                      hint: 'e.g., Green Coast Conservation',
                      prefixIcon: Icons.business,
                      validator: (value) {
                        if (_createNewOrganization && (value == null || value.isEmpty)) {
                          return 'Organization name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _organizationTypeController,
                      label: 'Organization Type',
                      hint: 'e.g., NGO, Government, Private',
                      prefixIcon: Icons.category,
                      validator: (value) {
                        if (_createNewOrganization && (value == null || value.isEmpty)) {
                          return 'Organization type is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<OrganizationMode>(
                      value: _selectedMode,
                      decoration: InputDecoration(
                        labelText: 'Organization Mode',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: OrganizationMode.values.map((mode) {
                        return DropdownMenuItem(
                          value: mode,
                          child: Text(mode.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMode = value!;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Role Selection
          Text(
            'Your Role',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<UserRole>(
            value: _selectedRole,
            decoration: InputDecoration(
              labelText: 'Select Role',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: UserRole.values.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Text(_getRoleDisplayName(role)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),

          const SizedBox(height: 40),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isValid = _validateOrganizationStep();
                    return CustomButton(
                      label: 'Create Account',
                      isLoading: state is AuthLoading,
                      onPressed: isValid ? _nextStep : () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ],
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
