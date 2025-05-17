import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  static const String screenRoute = 'notification_screen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final Color kBg = const Color(0xFFF0DDC9);

  final Color kText = const Color(0xFF333333);

  final Color kAccent = const Color(0xFF71503C);

  final List<Map<String, dynamic>> notifications = [
    {
      'avatar': 'images/user1.jpg',
      'title': 'Product Support',
      'subtitle': 'new product added',
      'time': '3m ago'
    },
    {
      'avatar': 'images/user2.jpg',
      'title': 'Payment Support',
      'subtitle': 'pending payment',
      'time': '5m ago'
    },
    {
      'avatar': 'images/user1.jpg',
      'title': 'Product Support',
      'subtitle': 'product price changed',
      'time': '2h ago'
    },
    {
      'avatar': 'images/user3.jpg',
      'title': 'Profile Support',
      'subtitle': 'enter your location',
      'time': '3h ago'
    },
    {
      'avatar': 'images/user4.jpg',
      'title': 'Order Support',
      'subtitle': 'your order in way',
      'time': '5h ago'
    },
    {
      'avatar': 'images/user4.jpg',
      'title': 'Order Support',
      'subtitle': 'Your Order Delivered',
      'time': '7h ago'
    },
    {
      'avatar': 'images/user5.jpg',
      'title': 'Profile Support',
      'subtitle': 'Saved your photo.',
      'time': 'Yesterday'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'NOTIFICATIONS',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Top Controls: Mark All Read / Sort By
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Mark All Read',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  Row(
                    children: [
                      Text('Sort By Time',
                          style: TextStyle(color: Colors.black87)),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_drop_down, color: Colors.black87)
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final n = notifications[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(n['avatar']),
                      ),
                      title: Text(
                        n['title'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      subtitle: Text(n['subtitle']),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(Icons.more_horiz, color: Colors.grey),
                          const SizedBox(height: 4),
                          Text(
                            n['time'],
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
