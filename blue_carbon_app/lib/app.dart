import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blue_carbon_app/core/theme/app_theme.dart';
import 'package:blue_carbon_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:blue_carbon_app/presentation/screens/splash_screen.dart';
import 'package:blue_carbon_app/data/repositories/auth_repository.dart';
import 'package:blue_carbon_app/presentation/screens/auth/login_screen.dart';
import 'package:blue_carbon_app/presentation/screens/home/home_screen.dart';

class App extends StatelessWidget {
  final AuthRepository authRepository;

  const App({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(authRepository: authRepository)..add(CheckAuthStatusEvent())),
      ],
      child: MaterialApp(
        title: 'Blue Carbon MRV',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/login': (_) => const LoginScreen(),
          '/home': (_) => const HomeScreen(),
        },
      ),
    );
  }
}
