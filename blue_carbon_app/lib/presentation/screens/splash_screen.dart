import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:blue_carbon_app/presentation/screens/auth/login_screen.dart';
import 'package:blue_carbon_app/presentation/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
          } else if (state is AuthUnauthenticated) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
          }
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.oceanGradient,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo placeholder
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Center(child: Icon(Icons.water_drop, size: 80, color: AppColors.deepOceanBlue)),
              ),
              const SizedBox(height: 32),
              Text(
                'Blue Carbon MRV',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Monitoring, Reporting, Verification',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.8)),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
