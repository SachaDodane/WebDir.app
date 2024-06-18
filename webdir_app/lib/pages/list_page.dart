import 'package:flutter/material.dart';
import '/models/person.dart';

class ListPage extends StatelessWidget {
  final List<Person> persons;

  ListPage({required this.persons});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebDirectory'),
      ),
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final person = persons[index];
          return ListTile(
            title: Text('${person.firstName} ${person.lastName}'),
            subtitle: Text(person.department),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(person: person),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
