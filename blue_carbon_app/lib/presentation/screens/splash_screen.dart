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
  bool _minTimeElapsed = false;
  Widget? _targetScreen;

  @override
  void initState() {
    super.initState();
    // Ensure splash shows for ~3 seconds minimum
    Future.delayed(const Duration(seconds: 3)).then((_) {
      _minTimeElapsed = true;
      _maybeNavigate();
    });

    // Kick off auth check immediately; navigate only after min time
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
  }

  void _setTarget(Widget screen) {
    _targetScreen = screen;
    _maybeNavigate();
  }

  void _maybeNavigate() {
    if (!mounted) return;
    if (_minTimeElapsed && _targetScreen != null) {
      final Widget target = _targetScreen!;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => target),
      );
      _targetScreen = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              _setTarget(const HomeScreen());
            } else if (state is AuthUnauthenticated) {
              _setTarget(const LoginScreen());
            }
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.3, 0.6, 1.0],
                colors: AppColors.oceanDepthGradient + [AppColors.aquaMarine],
              ),
            ),
            child: Stack(
              children: [
                // Subtle wave pattern overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.3, -0.5),
                        radius: 1.5,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double logoSize = (constraints.maxWidth * 0.35).clamp(120.0, 200.0);
                    final double spacingLarge = (constraints.maxHeight * 0.06).clamp(32.0, 72.0);
                    final double spacingMedium = (constraints.maxHeight * 0.015).clamp(12.0, 24.0);

                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 480),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.9, end: 1.0),
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: Opacity(
                                      opacity: value.clamp(0.0, 1.0),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: logoSize,
                                  height: logoSize,
                                  decoration: BoxDecoration(
                                    color: AppColors.pearlWhite,
                                    borderRadius: BorderRadius.circular(32),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                      BoxShadow(
                                        color: AppColors.coastalTeal.withOpacity(0.3),
                                        blurRadius: 40,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.waves,
                                        size: logoSize * 0.38,
                                        color: AppColors.seaFoam,
                                      ),
                                      Icon(
                                        Icons.water_drop,
                                        size: logoSize * 0.5,
                                        color: AppColors.coastalTeal,
                                      ),
                                      Positioned(
                                        top: logoSize * 0.28,
                                        right: logoSize * 0.28,
                                        child: Container(
                                          width: logoSize * 0.075,
                                          height: logoSize * 0.075,
                                          decoration: BoxDecoration(
                                            color: AppColors.seagrassGreen,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: spacingMedium * 2),
                              Text(
                                'Blue Carbon MRV',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: AppColors.pearlWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 32,
                                  letterSpacing: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: spacingMedium),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  'Monitoring • Reporting • Verification',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppColors.pearlWhite.withOpacity(0.9),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: spacingLarge),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: const SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.pearlWhite),
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
