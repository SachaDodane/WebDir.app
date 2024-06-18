import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/person.dart';

class DetailPage extends StatelessWidget {
  final Person person;

  DetailPage({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '${person.firstName} ${person.lastName}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // Mise en gras du texte
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white, // Changer la couleur de la flèche de retour en white
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.grey[850],
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (person.imageUrl != null)
                    Center(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(person.imageUrl!),
                        radius: 50,
                      ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    '${person.firstName} ${person.lastName}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Department: ${person.department}', style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () => _launchURL('mailto:${person.email}'),
                    child: Text(
                      person.email,
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () => _launchURL('tel:${person.phoneNumber}'),
                    child: Text(
                      person.phoneNumber,
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
