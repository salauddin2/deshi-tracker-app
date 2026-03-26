import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/auth/providers/auth_provider.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _pageController = PageController();
  int _currentStep = 1;
  String _accountType = 'user'; // 'user' (Member) or 'business_owner' (Owner)

  // Step 1 Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Step 2 Controllers
  final _businessNameController = TextEditingController();
  final _businessDescriptionController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _businessNameController.dispose();
    _businessDescriptionController.dispose();
    super.dispose();
  }

  void _handleContinue() async {
    if (_currentStep == 1) {
      if (_validateStep1()) {
        final success = await ref.read(authProvider.notifier).register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          phone: _phoneController.text.trim(),
        );

        if (success) {
          if (_accountType == 'business_owner') {
             setState(() => _currentStep = 2);
             _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          } else {
            if (mounted) context.go('/member-profile');
          }
        } else {
          _showError('Registration failed. Please try again.');
        }
      }
    } else {
      // Step 2: Business Info for Owners
       if (mounted) context.go('/business-dashboard');
    }
  }

  bool _validateStep1() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showError('Please fill in all fields');
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F1),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(theme),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(theme),
                  _buildStep2(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step $_currentStep of 2',
                style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: theme.primaryColor),
              ),
              Text(
                _currentStep == 1 ? 'Account Details' : 'Business Information',
                style: GoogleFonts.jost(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _currentStep / 2,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Account Details',
            style: GoogleFonts.jost(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildTextField(controller: _nameController, label: 'Full Name', icon: Icons.person_outline),
          const SizedBox(height: 16),
          _buildTextField(controller: _phoneController, label: 'Phone Number', icon: Icons.phone_android_outlined, keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          _buildTextField(controller: _emailController, label: 'Email Address', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscurePassword,
            onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            icon: Icons.lock_clock_outlined,
            isPassword: true,
            obscureText: _obscurePassword,
          ),
          const SizedBox(height: 24),
          Text(
            'Account Type',
            style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAccountTypeCard(
                  theme,
                  'user',
                  'Member',
                  Icons.person_pin,
                  'Browse businesses',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAccountTypeCard(
                  theme,
                  'business_owner',
                  'Owner',
                  Icons.business_center,
                  'Manage business',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildButton(theme, 'CONTINUE', _handleContinue),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => context.pop(),
              child: Text('Already have an account? Log In', style: GoogleFonts.jost(color: theme.primaryColor, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Business Information',
            style: GoogleFonts.jost(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            'You can fill this in now or skip and do it later from your dashboard.',
            style: GoogleFonts.jost(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          _buildTextField(controller: _businessNameController, label: 'Business Name', icon: Icons.business_outlined),
          const SizedBox(height: 16),
          _buildTextField(controller: _businessDescriptionController, label: 'Description', icon: Icons.description_outlined, maxLines: 3),
          const SizedBox(height: 48),
          _buildButton(theme, 'COMPLETE REGISTRATION', _handleContinue),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => context.go('/business-dashboard'),
              child: Text('Skip & do it later', style: GoogleFonts.jost(color: Colors.grey[600], fontWeight: FontWeight.bold)),
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
    TextInputType? keyboardType,
    int maxLines = 1,
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
          keyboardType: keyboardType,
          maxLines: maxLines,
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

  Widget _buildAccountTypeCard(ThemeData theme, String type, String title, IconData icon, String subtitle) {
    bool isSelected = _accountType == type;
    return GestureDetector(
      onTap: () => setState(() => _accountType = type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? theme.primaryColor : Colors.grey[200]!),
          boxShadow: isSelected ? [BoxShadow(color: theme.primaryColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey[400], size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87),
            ),
            Text(
              subtitle,
              style: GoogleFonts.jost(fontSize: 10, color: isSelected ? Colors.white.withValues(alpha: 0.8) : Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(ThemeData theme, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: ref.watch(authProvider).isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: ref.watch(authProvider).isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(
                text,
                style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
      ),
    );
  }
}

