import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/data_providers.dart';

class LeaveReviewScreen extends ConsumerStatefulWidget {
  final String businessId;
  final String businessName;

  const LeaveReviewScreen({
    super.key,
    required this.businessId,
    required this.businessName,
  });

  @override
  ConsumerState<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends ConsumerState<LeaveReviewScreen> {
  int _selectedRating = 0;
  final _reviewController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitReview() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating first.')),
      );
      return;
    }
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write your review.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final bizRepo = ref.read(businessRepositoryProvider);
      await bizRepo.submitReview(
        businessId: widget.businessId,
        rating: _selectedRating,
        comment: _reviewController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review submitted! Thank you.'),
            backgroundColor: Color(0xFF15803D),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFB91C1C)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F1),
      appBar: AppBar(
        title: Text('Rate & Review', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.businessName,
              style: GoogleFonts.jost(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'How was your experience?',
              style: GoogleFonts.jost(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 48),
            _buildStarRating(),
            const SizedBox(height: 12),
            Text(
              _selectedRating == 0
                  ? 'Tap a star to rate'
                  : ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent!'][_selectedRating],
              style: GoogleFonts.jost(
                color: _selectedRating == 0 ? Colors.grey : Colors.amber[800],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 48),
            _buildReviewField(),
            const SizedBox(height: 48),
            _buildSubmitButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isSelected = _selectedRating >= starIndex;
        return GestureDetector(
          onTap: () => setState(() => _selectedRating = starIndex),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: isSelected ? 1.2 : 1.0),
              duration: const Duration(milliseconds: 200),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Icon(
                    isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 56,
                    color: isSelected ? Colors.amber : Colors.grey[300],
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildReviewField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Review',
          style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _reviewController,
          maxLines: 6,
          maxLength: 500,
          style: GoogleFonts.jost(),
          decoration: InputDecoration(
            hintText: 'Share more details about your experience...',
            hintStyle: GoogleFonts.jost(color: Colors.grey[400]),
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
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitReview,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: _isSubmitting
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(
                'SUBMIT REVIEW',
                style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
      ),
    );
  }
}
