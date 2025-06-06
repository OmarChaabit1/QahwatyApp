import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class RateAppScreen extends StatefulWidget {
  static const String screenRoute = 'rate_app_screen';

  @override
  State<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {
  double _rating = 0;
  bool _submitted = false;

  void showToast(BuildContext context, String title, String description,
      ToastificationType type) {
    Color primaryColor;
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case ToastificationType.success:
        primaryColor = const Color(0xFFFFC107);
        backgroundColor = Colors.white;
        icon = Icons.check_circle;
        break;
      case ToastificationType.info:
        primaryColor = Colors.purple;
        backgroundColor = Colors.white;
        icon = Icons.info_outline;
        break;
      case ToastificationType.warning:
        primaryColor = const Color(0xFFFFC107);
        backgroundColor = Colors.white;
        icon = Icons.warning_amber;
        break;
      default:
        primaryColor = const Color(0xFFF44336);
        backgroundColor = Colors.white;
        icon = Icons.error;
    }

    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 4),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      description: Text(
        description,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      alignment: Alignment.bottomRight,
      animationDuration: const Duration(milliseconds: 300),
      icon: Icon(icon),
      showIcon: true,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 12,
          offset: const Offset(0, 8),
        ),
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  Future<void> _submitRating() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showToast(
        context,
        'Login Required',
        'You must be logged in to rate the app.',
        ToastificationType.warning,
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('app_ratings')
          .doc(user.uid)
          .set({
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
        'email': user.email,
      });

      showToast(
        context,
        'Thank You!',
        'Thanks for rating us $_rating star${_rating > 1 ? 's' : ''}!',
        ToastificationType.success,
      );

      setState(() {
        _submitted = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      showToast(
        context,
        'Error',
        'Error saving rating: $e',
        ToastificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Rate the App",
          style: GoogleFonts.playfairDisplay(
            color: const Color(0xFF333333),
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF333333)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0DDC9), Color(0xFFE6D2BC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              "We'd love your feedback!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "Tap the stars to rate the app.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 36,
                  ),
                  onPressed: _submitted
                      ? null
                      : () {
                          setState(() {
                            _rating = index + 1.0;
                          });
                        },
                );
              }),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[600],
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _submitted ? null : _submitRating,
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
