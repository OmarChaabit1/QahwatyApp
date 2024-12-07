import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class dashboardScreen extends StatefulWidget {
  static const screenRoute = '/dashboard_screen';

  const dashboardScreen({super.key});

  @override
  _dashboardScreenState createState() => _dashboardScreenState();
}

class _dashboardScreenState extends State<dashboardScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? signedInUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      signedInUser = _auth.currentUser;
      if (signedInUser == null) {
        throw Exception("No signed-in user found");
      }
    } catch (e) {
      print("Error fetching current user: $e");
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Color.fromARGB(255, 164, 21, 192),
            unselectedLabelColor: Colors.black54,
            indicatorColor: Color.fromARGB(255, 164, 21, 192),
            isScrollable: true,
            tabs: const [
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
                _buildFriendsList(),
                buildTabContent('Notifications'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabContent(String tabName) {
    return Center(
      child: Text(
        'Content for $tabName',
        style: const TextStyle(fontSize: 18, color: Colors.black87),
      ),
    );
  }

  Widget _buildFriendsList() {
    final currentUserEmail = signedInUser?.email;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error fetching users.",
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "No users found.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }

        final users = snapshot.data!.docs;

        final friendWidgets = users.where((user) {
          final email = user['email'] ?? '';
          return email != currentUserEmail;
        }).map((user) {
          final email = user['email'] ?? 'Unknown Email';

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 113, 8, 134),
              child: Text(
                email[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(email),
            trailing: IconButton(
              icon: const Icon(Icons.chat,
                  color: Color.fromARGB(255, 164, 21, 192)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => chatScreen(chatPartnerEmail: email),
                  ),
                );
              },
            ),
          );
        }).toList();

        return ListView(children: friendWidgets);
      },
    );
  }
}
