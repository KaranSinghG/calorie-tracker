class UserProfile {
  final int id;
  final String username;
  final String email;
  final int age;
  final String gender;
  final double weight;
  final double height;
  final String activityLevel;
  final String goalType;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.goalType,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      activityLevel: json['activityLevel'] as String,
      goalType: json['goalType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}