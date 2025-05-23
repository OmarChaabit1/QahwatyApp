import 'package:flutter/material.dart';
import 'package:messages_apk/screens/tabs_screen.dart';

class ThankYouScreen extends StatelessWidget {
  static const String screenRoute = '/thank_you_screen';

  // palette reused across app
  final Color kBg = const Color(0xFFF0DDC9); // beige
  final Color kGreen = Colors.green;
  final Color kText = const Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              TabsScreen.screenRoute,
              (route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --------------- Logo -----------------
            Image.asset('images/logo.png', height: 170),
            // --------------- Curved separator -----
            ClipPath(
              clipper: _CurveClipper(),
              child: Container(
                color: Colors.white,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
                child: Column(
                  children: [
                    // ✅ checkmark ddisplay -----------
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: kGreen,
                      child: const Icon(Icons.check,
                          size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    // Text block --------------
                    const Text(
                      'Thank you\nFor Your Order',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'We Will Call You Soon To\nConfirm Your Order',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Comic Neue', // playful handwritten font
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Guarantees -------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _Guarantee(
                          icon: Icons.thumb_up,
                          title: '100%\nGuarantee',
                        ),
                        Container(width: 1, height: 60, color: Colors.black26),
                        _Guarantee(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'Affordable\nPrice',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // --------------- Bottom bar --------------

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// ------------ helper widgets / clippers ----------------
class _Guarantee extends StatelessWidget {
  final IconData icon;
  final String title;
  const _Guarantee({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 34, color: Colors.teal),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// Creates the white curved top-right edge shown in the screenshot.
class _CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..moveTo(0, 0);
    path.lineTo(size.width * .6, 0);
    path.quadraticBezierTo(size.width * .9, 0, size.width, size.height * .15);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
