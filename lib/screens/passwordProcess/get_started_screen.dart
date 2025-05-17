import 'package:flutter/material.dart';
import 'package:messages_apk/screens/auth/Welcome_screen.dart';
import 'package:messages_apk/screens/auth/sign_in_screen.dart';

class GetStartedScreen extends StatelessWidget {
  static const String screenRoute = 'get_started_screen';

  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              // Logo
              Image.asset(
                'images/logo.png', // Replace with your actual path
                height: 150,
              ),

              // const SizedBox(height: 10),

              // Coffee cup illustration
              Image.asset(
                'images/goublet.png', // Replace with your cup image
                height: 250,
              ),

              const SizedBox(height: 10),

              // Headline
              const Text(
                'find your supplies!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                ),
              ),

              const SizedBox(height: 10),

              // App name (stylized)
              // const Text(
              //   'Qahwty',
              //   style: TextStyle(
              //     fontFamily:
              //         'Pacifico', // Or whatever script/font you're using
              //     fontSize: 32,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.brown,
              //   ),
              // ),
              Image.asset('images/qahwaty.png',
                  height: 50), // Replace with your actual path
              const SizedBox(height: 10),

              // Subtitle
              const Text(
                'Morocco’s First Coffee Shop Supplies App!\n'
                'Easy to Use, Quick Delivery,\nPremium Quality.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Nunito',
                ),
              ),

              const Spacer(),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, WelcomeScreen.screenRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                            color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward,
                          color: Colors.white), // Arrow icon
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
