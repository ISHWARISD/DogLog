class DogProfile {
  final String name;
  final String breed;
  final String age;
  final String weight;
  final int operationsDone;
  final List<Map<String, String>> vaccinationRecords;
  final List<String> foodAllergies;
  final String photoUrl;

  DogProfile({
    required this.name,
    required this.breed,
    required this.age,
    required this.weight,
    required this.operationsDone,
    required this.vaccinationRecords,
    required this.foodAllergies,
    required this.photoUrl,
  });
}