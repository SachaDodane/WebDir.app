class Person {
  final String firstName;
  final String lastName;
  final String department;
  final String email;
  final String phoneNumber;
  final String? imageUrl; // Ajouter ce champ

  Person({
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.email,
    required this.phoneNumber,
    this.imageUrl,
  });
}
