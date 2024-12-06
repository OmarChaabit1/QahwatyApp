import 'package:flutter/material.dart';
// import 'package:midlv2/shared/widgets/Dashbord_widget.dart';
// import 'package:midlv2/shared/widgets/carrousel_wiget.dart';
// import 'package:midlv2/shared/widgets/messagerie_widget.dart';
// import 'package:midlv2/shared/widgets/profile_widget.dart';

class SimpleWebNavbarWidget extends StatefulWidget {
  const SimpleWebNavbarWidget({
    super.key,
    required this.onPageSelected,
    this.currentPage,
  });

  final Widget? currentPage; // Make it nullable to handle no page being passed
  final void Function(Widget) onPageSelected;

  @override
  State<SimpleWebNavbarWidget> createState() => _SimpleWebNavbarWidgetState();
}

class _SimpleWebNavbarWidgetState extends State<SimpleWebNavbarWidget> {
  late Widget _currentPage;

  @override
  void initState() {
    super.initState();
    // Set default page as CarrouselScreen if currentPage is null
    // _currentPage = widget.currentPage ?? CarrouselScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Section
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
            child: InkWell(
              onTap: () async {
                await launchURL('https://www.midljob.com/');
              },
              child: Container(
                width: 150.0,
                height: 80.0,
                decoration: const BoxDecoration(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/LOGO_MIDLJJOB.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Navbar Items
          Container(
            width: 400.0,
            height: 100.0,
            decoration: const BoxDecoration(),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Navbar Item: Carousel
                  InkWell(
                    onTap: () {
                      // widget.onPageSelected(CarrouselScreen());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 55.0,
                          height: 55.0,
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
                            padding: EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Text('Carrousel'),
                      ],
                    ),
                  ),

                  const SizedBox(width: 14.0), // Spacer between items

                  // Navbar Item: Dashboard
                  InkWell(
                    onTap: () {
                      // widget.onPageSelected(DashboardScreen());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 55.0,
                          height: 55.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x3E000000),
                                offset: Offset(0.0, 0.0),
                                spreadRadius: 2.0,
                              )
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.dashboard,
                            color: Colors.black,
                            size: 35.0,
                          ),
                        ),
                        const Text('Tableau de bord'),
                      ],
                    ),
                  ),

                  const SizedBox(width: 14.0), // Spacer between items

                  // Navbar Item: Chat
                  InkWell(
                    onTap: () {
                      // widget.onPageSelected(MessagerieScreen());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 55.0,
                          height: 55.0,
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
                          child: Icon(
                            Icons.chat,
                            color: Colors.black,
                            size: 35.0,
                          ),
                        ),
                        const Text('Messagerie'),
                      ],
                    ),
                  ),

                  const SizedBox(width: 14.0), // Spacer between items

                  // Navbar Item: Profile
                  InkWell(
                    onTap: () {
                      // widget.onPageSelected(ProfileScreen());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 55.0,
                          height: 55.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x3E000000),
                                offset: Offset(0.0, 0.0),
                                spreadRadius: 2.0,
                              )
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(55.0),
                            child: Image.asset(
                              'assets/images/error_image.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Text('Profil'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> launchURL(String url) async {
  print("Launching URL: $url");
}
