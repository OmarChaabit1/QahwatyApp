import 'package:flutter/material.dart';
import 'package:messages_apk/shared/navbar/mobile_nav_widget.dart';

class dashboardScreen extends StatefulWidget {
  static const screenRoute = '/dashboard_screen';

  const dashboardScreen({super.key});

  @override
  _dashboardScreenState createState() => _dashboardScreenState();
}

class _dashboardScreenState extends State<dashboardScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // Check if the layout is for tablet
  bool isTabletLayout(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 700 && screenWidth < 1000;
  }

  // Check if the layout is for mobile
  bool isMobileLayout(BuildContext context) {
    return MediaQuery.of(context).size.width < 600; // Mobile threshold
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = isMobileLayout(context);
    bool isTablet = isTabletLayout(context);

    return Scaffold(
      backgroundColor: Colors.white,
      // No app bar for web version
      body: isMobile
          ? _buildMobileLayout()
          : isTablet
              ? _buildTabletLayout() // New tablet layout
              : _buildWebLayout(context),
      // Web version doesn't need the mobile nav
    );
  }

  // Mobile layout
  // Mobile layout
  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Ensure no extra space or padding is around the TabBar
        TabBar(
          controller: _tabController,
          labelColor: Color.fromARGB(255, 46, 37, 88),
          unselectedLabelColor: Colors.black,
          indicatorColor: Color.fromARGB(255, 74, 55, 155),
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true, // This enables scrolling for the tabs
          tabs: [
            Tab(text: 'Actua'),
            Tab(text: 'Invitations'),
            Tab(text: 'Friends'),
            Tab(text: 'Notifications'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              buildTabContent('Actua'),
              buildTabContent('Invitations'),
              buildTabContent('Friends'),
              buildTabContent('Notifications'),
            ],
          ),
        ),
      ],
    );
  }

  // Web layout
  // Web layout
  Widget _buildWebLayout(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.all(50.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 20.0,
              bottom: 5.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(
                color: Color(0xFF34C8A9),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Explorer',
                    style: TextStyle(
                      color: Color(0xFF064088),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(color: Colors.grey),
                TabBar(
                  controller: _tabController,
                  labelColor: Color(0xFF064088),
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Color(0xFF064088),
                  indicatorSize: TabBarIndicatorSize.label,
                  // Use alignment to distribute tabs across the width
                  tabs: [
                    Tab(text: 'Actua'),
                    Tab(text: 'Invitations'),
                    Tab(text: 'Friends'),
                    Tab(text: 'Notifications'),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      buildTabContent('Actua'),
                      buildTabContent('Invitations'),
                      buildTabContent('Friends'),
                      buildTabContent('Notifications'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Content for each tab
  Widget buildTabContent(String tabName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tabName,
          style: TextStyle(
            color: Color(0xFF064088),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Ces profils aimeraient discuter avec vous.",
          style: TextStyle(color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "Likez-les en retour pour démarrer une conversation.",
          style: TextStyle(color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Image.asset(
          'images/messageMe.png',
          width: 150,
          height:
              150, // Ensure this image is placed correctly in your           height: 100,
        ),
        SizedBox(height: 20),
        Text(
          'Aucun like pour le moment',
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      ],
    );
  }

  // Tablet layout (Similar to web but with scrollable TabBar)
  Widget _buildTabletLayout() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width *
            0.8, // Slightly narrower than web
        height: MediaQuery.of(context).size.height * 0.8, // Adjust height
        padding: EdgeInsets.all(30.0), // Moderate padding
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xFF34C8A9),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Explorer',
                style: TextStyle(
                  color: Color(0xFF064088),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(color: Colors.grey),
            // Scrollable TabBar for tablet layout
            TabBar(
              controller: _tabController,
              labelColor: Color(0xFF064088),
              unselectedLabelColor: Colors.black,
              indicatorColor: Color(0xFF064088),
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true, // Enables scrolling for tabs on tablet
              tabs: [
                Tab(text: 'Vous a liké.e'),
                Tab(text: 'Matchés'),
                Tab(text: 'Likés'),
                Tab(text: 'Favoris'),
                Tab(text: 'Ignorés'),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildTabContent('Vous a liké.e'),
                  buildTabContent('Matchés'),
                  buildTabContent('Likés'),
                  buildTabContent('Favoris'),
                  buildTabContent('Ignorés'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
