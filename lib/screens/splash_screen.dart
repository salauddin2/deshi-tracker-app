import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/providers/auth_provider.dart';
import '../providers/data_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // Wait for animation or artificial delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    final authState = ref.read(authProvider);
    final storage = ref.read(storageServiceProvider);

    
    if (authState.user != null) {
      final role = authState.user!.role;
      if (role == 'staff') {
        context.go('/staff-dashboard');
      } else if (role == 'business_owner') {
        context.go('/business-dashboard');
      } else if (role == 'user') {
        context.go('/member-profile');
      } else {
        context.go('/');
      }
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3C5E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            )
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(delay: 200.ms),
            
            const SizedBox(height: 24),
            
            const Text(
              'DESI TRACKER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            )
            .animate()
            .fadeIn(delay: 500.ms)
            .slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 48),
            
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            )
            .animate()
            .fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}
