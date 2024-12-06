import 'package:flutter/material.dart';

class MobileNavWidget extends StatefulWidget {
  const MobileNavWidget({
    super.key,
    required this.currentPage,
  });

  final String? currentPage;

  @override
  State<MobileNavWidget> createState() => _MobileNavWidgetState();
}

class _MobileNavWidgetState extends State<MobileNavWidget> {
  @override
  Widget build(BuildContext context) {
    bool isLiteUser = false; // Static value for demo purposes

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 110.0,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (!isLiteUser)
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/carrousel_screen'); // Navigate to Carrousel screen
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x3E000000),
                            offset: Offset(0.0, 0.0),
                            spreadRadius: 2.0,
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/logo.png', // Static asset
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    const Text('Carrousel'),
                  ],
                ),
              ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/dashboard_screen'); // Navigate to Dashboard
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x3E000000),
                          offset: Offset(0.0, 0.0),
                          spreadRadius: 2.0,
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.dashboard,
                      color: Colors.black,
                      size: 30.0,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  const Text('Tableau de bord'),
                ],
              ),
            ),
            if (!isLiteUser)
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/messageie_screen'); // Navigate to Messagerie
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x3E000000),
                            offset: Offset(0.0, 0.0),
                            spreadRadius: 2.0,
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chat,
                        color: Colors.black,
                        size: 30.0,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    const Text('Messagerie'),
                  ],
                ),
              ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/my_profil'); // Navigate to Profile
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x3E000000),
                          offset: Offset(0.0, 0.0),
                          spreadRadius: 2.0,
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(55.0),
                      child: Image.asset(
                        'assets/images/error_image.jpg', // Static asset for profile image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  const Text('Profil'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
