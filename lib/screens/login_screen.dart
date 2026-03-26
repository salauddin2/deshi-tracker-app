import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/auth/providers/auth_provider.dart';
import '../providers/data_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    _loadRememberedData();
  }

  void _loadRememberedData() {
    final storage = ref.read(storageServiceProvider);
    setState(() {
      _rememberMe = storage.isRememberMe();
      if (_rememberMe) {
        _emailController.text = storage.getSavedEmail() ?? '';
      }
    });
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authProvider.notifier);
      final success = await authService.login(email, password);
      if (!mounted) return;
      
      if (success) {
        final role = ref.read(authProvider).role;
        final storage = ref.read(storageServiceProvider);
        if (_rememberMe) {
          await storage.setSavedEmail(email);
        } else {
          await storage.setSavedEmail('');
        }
        await storage.setRememberMe(_rememberMe);
        
        if (!mounted) return;
        if (role == UserRole.admin) {
          context.go('/admin');
        } else if (role == UserRole.staff) {
          context.go('/staff-dashboard');
        } else {
          context.go('/home');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please check your credentials.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(theme),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back',
                    style: GoogleFonts.jost(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Login to your account to continue',
                    style: GoogleFonts.jost(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email or Phone Number',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (value) => setState(() => _rememberMe = value!),
                          activeColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Remember Me',
                        style: GoogleFonts.jost(color: Colors.grey[700], fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.jost(fontWeight: FontWeight.w600, color: theme.primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildLoginButton(theme),
                  const SizedBox(height: 24),
                  _buildRegisterPrompt(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(80)),
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withValues(alpha: 0.8)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo.png', height: 100),
          const SizedBox(height: 16),
          Text(
            'DESI TRACKER',
            style: GoogleFonts.jost(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: GoogleFonts.jost(),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: Colors.grey[400]),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, size: 20, color: Colors.grey[400]),
                    onPressed: onToggleObscure,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(
                'LOG IN',
                style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
      ),
    );
  }

  Widget _buildRegisterPrompt(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.jost(color: Colors.grey[600]),
        ),
        GestureDetector(
          onTap: () => context.push('/register'),
          child: Text(
            'Sign Up',
            style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: theme.primaryColor),
          ),
        ),
      ],
    );
  }
}
