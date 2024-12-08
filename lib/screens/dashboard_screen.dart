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
  List<Map<String, dynamic>> notifications = [];
  int notificationCount = 0; // Notification count state
  int invitationCount = 0; // Invitation count state

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    getCurrentUser();
    fetchNotifications();
    fetchInvitationsCount();
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

  void fetchNotifications() {
    final currentUserEmail = signedInUser?.email;

    if (currentUserEmail != null) {
      _firestore
          .collectionGroup('chats')
          .where('receiver', isEqualTo: currentUserEmail)
          .snapshots()
          .listen((snapshot) {
        setState(() {
          notifications = snapshot.docs.map((doc) {
            return {
              'text': doc['text'],
              'sender': doc['sender'],
              'time': doc['time'],
            };
          }).toList();

          // Update notification count
          notificationCount = notifications.length;
        });
      });
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
            labelColor: const Color.fromARGB(255, 164, 21, 192),
            unselectedLabelColor: Colors.black54,
            indicatorColor: const Color.fromARGB(255, 164, 21, 192),
            isScrollable: true,
            tabs: [
              const Tab(text: 'Actua'),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Invitations'),
                    if (invitationCount > 0) // Show badge only if count > 0
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$invitationCount',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 164, 21, 192),
                              fontSize: 12,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                  ],
                ),
              ),
              const Tab(text: 'Friends'),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Notifications'),
                    if (notificationCount > 0) // Show badge only if count > 0
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$notificationCount',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 164, 21, 192),
                              fontSize: 12,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActuaTab(),
                _buildInvitationsTab(),
                _buildFriendsList(),
                _buildNotificationsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvitationsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('invitations')
          .where('receiver', isEqualTo: signedInUser?.email)
          .where('status', isEqualTo: 'pending') // Filter pending invitations
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final invitations = snapshot.data!.docs;

        if (invitations.isEmpty) {
          return Center(
            child: Text(
              'No pending invitations.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: invitations.length,
          itemBuilder: (context, index) {
            final invitation = invitations[index];
            final sender = invitation['sender'];
            final invitationId = invitation.id;

            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  'Invitation from $sender',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  'Tap to accept or decline.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => acceptInvitation(invitationId),
                      splashColor: Colors.green.withOpacity(0.3),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => declineInvitation(invitationId),
                      splashColor: Colors.red.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void acceptInvitation(String invitationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('invitations')
          .doc(invitationId)
          .update({'status': 'accepted'}); // Update status to 'accepted'

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invitation accepted successfully!')),
      );
    } catch (e) {
      print("Error accepting invitation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept invitation: $e')),
      );
    }
  }

  void declineInvitation(String invitationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('invitations')
          .doc(invitationId)
          .update({'status': 'declined'}); // Update status to 'declined'

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invitation declined.')),
      );
    } catch (e) {
      print("Error declining invitation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to decline invitation: $e')),
      );
    }
  }

  void fetchInvitationsCount() {
    final currentUserEmail = signedInUser?.email;

    if (currentUserEmail != null) {
      _firestore
          .collection('invitations')
          .where('receiver', isEqualTo: currentUserEmail)
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .listen((snapshot) {
        setState(() {
          invitationCount = snapshot.docs.length;
        });
      });
    }
  }

  void _sendInvitation(String receiverEmail) async {
    final currentUserEmail = signedInUser?.email;

    if (currentUserEmail != null) {
      // Check if the current user has already sent an invitation to the receiver
      final existingInvitation = await _firestore
          .collection('invitations')
          .where('sender', isEqualTo: currentUserEmail)
          .where('receiver', isEqualTo: receiverEmail)
          .where('status', isEqualTo: 'pending')
          .get();

      if (existingInvitation.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('You have already sent an invitation to $receiverEmail.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Send new invitation if none exists
      _firestore.collection('invitations').add({
        'sender': currentUserEmail,
        'receiver': receiverEmail,
        'message': 'You have a new invitation!',
        'status': 'pending', // Optional, for tracking invitation status
        'timestamp': Timestamp.now(), // For sorting invitations
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invitation sent to $receiverEmail'),
            backgroundColor: Colors.green,
          ),
        );
        fetchInvitationsCount(); // Refresh the invitation count after sending
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send invitation: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be signed in to send invitations.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildActuaTab() {
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

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final email = user['email'] ?? 'Unknown Email';

            // Skip the current user
            if (email == currentUserEmail) {
              return const SizedBox.shrink();
            }

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color.fromARGB(255, 113, 8, 134),
                      child: Text(
                        email[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Click invite to send a request.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _sendInvitation(email); // Call invitation logic
                      },
                      child: const Text(
                        'Invite',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color.fromARGB(255, 113, 8, 134),
                    child: Text(
                      email[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Online",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 164, 21, 192),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.chat, color: Colors.white),
                    label: const Text(
                      "Chat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              chatScreen(chatPartnerEmail: email),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }).toList();

        return ListView(children: friendWidgets);
      },
    );
  }

  Widget _buildNotificationsTab() {
    if (notifications.isEmpty) {
      return const Center(
        child: Text(
          "No notifications yet.",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final sender = notification['sender'] ?? 'Unknown Sender';
        final text = notification['text'] ?? 'No message content';
        final time =
            notification['time']?.toDate().toString() ?? 'Unknown time';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Navigate to chat on notification click
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => chatScreen(chatPartnerEmail: sender),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color.fromARGB(255, 164, 21, 192),
                    child: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sender,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _formatTime(time),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Helper function to format time
  String _formatTime(String time) {
    try {
      final dateTime = DateTime.parse(time);
      return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "Invalid time";
    }
  }
}
