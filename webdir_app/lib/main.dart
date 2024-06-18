import 'package:flutter/material.dart';
import 'pages/list_page.dart';
import 'models/person.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAE WebDirectory App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListPage(persons: _generateDummyData()),
    );
  }

  List<Person> _generateDummyData() {
    return [
      Person(
        firstName: 'John',
        lastName: 'Doe',
        department: 'IT',
        email: 'john.doe@example.com',
        phoneNumber: '+33 1 23 45 67 89',
        imageUrl: 'https://media.istockphoto.com/id/1171169099/fr/photo/homme-avec-les-bras-crois%C3%A9s-disolement-sur-le-fond-gris.jpg?s=612x612&w=0&k=20&c=csQeB3utGtrGeb3WmdSxRYXaJvUy_xqlhbOIZxclcGA=', // URL d'image
      ),
      Person(
        firstName: 'Jane',
        lastName: 'Smith',
        department: 'HR',
        email: 'jane.smith@example.com',
        phoneNumber: '+33 6 12 34 56 78',
        imageUrl: 'https://media.istockphoto.com/id/1420486889/fr/photo/portrait-candide-dun-jeune-natif-du-num%C3%A9rique-du-moyen-orient.jpg?s=612x612&w=0&k=20&c=ylvxHktzxgg4UdLg1ZFKptX9FH_4YF-1D2sEo2trtE0=', // URL d'image
      ),
      Person(
        firstName: 'Robert',
        lastName: 'Johnson',
        department: 'Finance',
        email: 'robert.johnson@example.com',
        phoneNumber: '+33 1 98 76 54 32',
        imageUrl: 'https://www.capretraite.fr/wp-content/uploads/2023/08/voici-comment-lutter-contre-lisolement-social-dune-personne-agee.jpeg', // URL d'image
      ),
      Person(
        firstName: 'Alice',
        lastName: 'Williams',
        department: 'Marketing',
        email: 'alice.williams@example.com',
        phoneNumber: '+33 6 23 45 67 89',
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpYeCkojPU01xYnqd1HclJyHvdihQY523vzQ&s', // URL d'image
      ),
      Person(
        firstName: 'Michael',
        lastName: 'Brown',
        department: 'Sales',
        email: 'michael.brown@example.com',
        phoneNumber: '+33 1 23 98 76 54',
        imageUrl: 'https://media.istockphoto.com/id/1389348844/fr/photo/plan-de-studio-dune-belle-jeune-femme-souriante-debout-sur-un-fond-gris.jpg?s=612x612&w=0&k=20&c=VGipX3a8xrbYuXTNm_61pFuzpGdAO9lwt2xnVUd7Khs=', // URL d'image
      ),
    ]..sort((a, b) => a.firstName.compareTo(b.firstName));
  }
}
