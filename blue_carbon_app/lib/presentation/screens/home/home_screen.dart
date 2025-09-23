import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:blue_carbon_app/presentation/screens/auth/login_screen.dart';
import 'package:blue_carbon_app/presentation/screens/projects/projects_screen.dart';
import 'package:blue_carbon_app/presentation/screens/uploads/uploads_screen.dart';
import 'package:blue_carbon_app/presentation/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const ProjectsScreen(), const UploadsScreen(), const ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(
            context,
          ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
        }
      },
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.coastalTeal,
          unselectedItemColor: AppColors.charcoal.withOpacity(0.5),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.forest), label: 'Projects'),
            BottomNavigationBarItem(icon: Icon(Icons.cloud_upload), label: 'Uploads'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
