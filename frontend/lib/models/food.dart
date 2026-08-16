class Food {
  final int id;
  final String name;
  final double calories;
  final double carbohydrate;
  final double protein;
  final double fat;
  final double perItemWeight;
  final bool supportItemQuantity;

  Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.carbohydrate,
    required this.protein,
    required this.fat,
    this.perItemWeight = 100.0,
    this.supportItemQuantity = false,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      calories: (json['calories'] as num).toDouble(),
      carbohydrate: (json['carbohydrate'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      perItemWeight: (json['perItemWeight'] as num?)?.toDouble() ?? 100.0,
      supportItemQuantity: (json['supportItemQuantity'] as bool?) ?? false,
    );
  }
}