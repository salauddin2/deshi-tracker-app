import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../features/auth/providers/auth_provider.dart';
import '../data/models/user.dart';

class OwnerProfileScreen extends ConsumerStatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  ConsumerState<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends ConsumerState<OwnerProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _saving = false;

  Future<void> _handleSave() async {
    if (_nameController.text.trim().isEmpty) return;
    
    setState(() => _saving = true);
    try {
      final success = await ref.read(authProvider.notifier).updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '✅ Profile updated successfully!' : '❌ Failed to update profile'),
            backgroundColor: success ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFB91C1C)),
        );
      }
    }
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo == null) return;

    setState(() => _saving = true);
    try {
      final success = await ref.read(authProvider.notifier).uploadProfilePhoto(photo.path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '✅ Photo uploaded!' : '❌ Upload failed'),
            backgroundColor: success ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFB91C1C)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildPhotoUpload(user, theme),
                const SizedBox(height: 48),
                _buildTextField(controller: _nameController, label: 'Full Name', icon: Icons.person_outline),
                const SizedBox(height: 24),
                _buildTextField(controller: _phoneController, label: 'Phone Number', icon: Icons.phone_android_outlined),
                const SizedBox(height: 24),
                _buildTextField(controller: _emailController, label: 'Email Address', icon: Icons.email_outlined),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _passwordController,
                  label: 'New Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                  icon: Icons.lock_clock_outlined,
                  isPassword: true,
                  obscureText: _obscurePassword,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3C5E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _saving
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(
                            'SAVE CHANGES',
                            style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
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

  Widget _buildPhotoUpload(User? user, ThemeData theme) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFFF4F8FD),
              backgroundImage: user?.profilePicUrl != null ? NetworkImage(user!.profilePicUrl!) : null,
              child: user?.profilePicUrl == null ? const Icon(Icons.person, size: 60, color: Colors.grey) : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A3C5E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _saving ? null : _pickAndUploadPhoto,
          child: Text(
            'Upload Photo',
            style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: const Color(0xFF1A3C5E)),
          ),
        ),
      ],
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
          style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFF1E293B)),
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
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
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
}
