import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  static const String screenRoute = 'help_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue dans l\'aide de notre application !',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.lightBlueAccent,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Utilisation de l\'application :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '1. Créer un cercle familial : Pour créer un nouveau cercle familial, '
              'sélectionnez l\'icône "Create A Circle" dans la barre de navigation '
              'et suivez les instructions à l\'écran.',
            ),
            Text(
              '2. Rejoindre un cercle familial : Si vous avez reçu un code d\'invitation, '
              'sélectionnez l\'icône "Create A Circle" dans la barre de navigation '
              'et saisissez le code pour rejoindre un cercle existant.',
            ),
            SizedBox(height: 20.0),
            Text(
              'FAQ (Foire Aux Questions) :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Q : Comment puis-je changer mon nom d\'utilisateur ?\n'
              'R : Pour changer votre nom d\'utilisateur, accédez à votre profil '
              'et sélectionnez l\'option pour modifier les informations personnelles.',
            ),
            Text(
              'Q : Comment puis-je quitter un cercle familial ?\n'
              'R : Pour quitter un cercle familial, accédez à la liste de vos cercles '
              'et sélectionnez l\'option pour quitter le cercle souhaité.',
            ),
            // Ajoutez d'autres questions et réponses selon les besoins
          ],
        ),
      ),
    );
  }
}
