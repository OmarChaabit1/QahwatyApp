import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:messages_apk/screens/tabs_screen.dart';

class HelpScreen extends StatelessWidget {
  static const String screenRoute = 'help_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, TabsScreen.screenRoute);
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to the Help Section!',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color.fromARGB(255, 113, 8, 134),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'How to Use the App:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                '1. Dashboard Navigation: Use the tabs at the top to view different sections such as "Actua", "Invitations", "Friends", and "Notifications". Tap on a tab to switch between them.',
              ),
              SizedBox(height: 10.0),
              Text(
                '2. Chat with Friends: Go to the "Friends" tab under the Dashboard. Tap the chat icon next to a user\'s name to start a conversation with them.',
              ),
              SizedBox(height: 10.0),
              Text(
                '3. Profile Management: Access your profile from the bottom navigation bar. Here, you can view and update your personal details.',
              ),
              SizedBox(height: 10.0),
              Text(
                '4. Saved Messages: Visit the "Messages" tab from the bottom navigation bar to access your saved chats or messages.',
              ),
              SizedBox(height: 20.0),
              Text(
                'Frequently Asked Questions (FAQ):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Q: How do I log out of the app?\n'
                'A: Open the app drawer (menu) and select the "Logout" option to securely sign out.',
              ),
              SizedBox(height: 10.0),
              Text(
                'Q: How do I find new friends?\n'
                'A: Navigate to the "Friends" tab. You can view a list of users and start a chat by tapping the chat icon next to their name.',
              ),
              SizedBox(height: 10.0),
              Text(
                'Q: What if I forget my password?\n'
                'A: On the login screen, tap the "Forgot Password" link to reset your password via email.',
              ),
              SizedBox(height: 10.0),
              Text(
                'Q: How can I receive notifications?\n'
                'A: Ensure you have enabled notifications for the app in your device\'s settings. Notifications for new chats or updates will appear in the "Notifications" tab.',
              ),
              SizedBox(height: 20.0),
              Text(
                'Need more help?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'For additional support, please contact our team through the "Contact Us" option in the app drawer.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
