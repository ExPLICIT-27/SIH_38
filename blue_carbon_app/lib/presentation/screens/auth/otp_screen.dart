import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:blue_carbon_app/presentation/screens/home/home_screen.dart';
import 'package:blue_carbon_app/presentation/widgets/common/custom_button.dart';
import 'package:blue_carbon_app/data/models/models.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final bool isSignup;
  final String? name;
  final Map<String, dynamic>? organizationData;
  final OrganizationModel? selectedOrganization;
  final UserRole? selectedRole;

  const OtpScreen({
    super.key,
    required this.email,
    this.isSignup = false,
    this.name,
    this.organizationData,
    this.selectedOrganization,
    this.selectedRole,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _submitOtp() {
    final otp = _controllers.map((c) => c.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter the complete OTP'), backgroundColor: Colors.red));
      return;
    }

    if (widget.isSignup && widget.name != null) {
      // For signup, we need to handle organization creation/joining
      context.read<AuthBloc>().add(SignupEvent(
            widget.email,
            otp,
            widget.name!,
            organizationData: widget.organizationData,
            selectedOrganization: widget.selectedOrganization,
            selectedRole: widget.selectedRole ?? UserRole.member,
          ));
    } else {
      context.read<AuthBloc>().add(LoginEvent(widget.email, otp));
    }
  }

  void _resendOtp() {
    context.read<AuthBloc>().add(RequestOtpEvent(widget.email));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('OTP has been resent to your email'), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.deepOceanBlue),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(
              context,
            ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.coralPink));
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter OTP',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.deepOceanBlue),
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'ve sent a verification code to ${widget.email}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.charcoal.withOpacity(0.7)),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) => _buildOtpDigitField(index)),
                ),
                const SizedBox(height: 40),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return CustomButton(label: 'Verify', isLoading: state is AuthLoading, onPressed: _submitOtp);
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: _resendOtp,
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(color: AppColors.coastalTeal, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpDigitField(int index) {
    return SizedBox(
      width: 45,
      height: 50,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.deepOceanBlue.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.coastalTeal, width: 2),
          ),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          }
        },
      ),
    );
  }
}
