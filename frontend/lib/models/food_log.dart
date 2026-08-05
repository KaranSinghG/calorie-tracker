class FoodLog {
  final int id;
  final int userId;
  final int foodId;
  final String foodName;
  final String mealType;
  final double quantityInGrams;
  final double calories;
  final double carbohydrate;
  final double protein;
  final double fat;
  final DateTime createdAt;

  FoodLog({
    required this.id,
    required this.userId,
    required this.foodId,
    required this.foodName,
    required this.mealType,
    required this.quantityInGrams,
    required this.calories,
    required this.carbohydrate,
    required this.protein,
    required this.fat,
    required this.createdAt,
  });

  factory FoodLog.fromJson(Map<String, dynamic> json) {
    return FoodLog(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      foodId: (json['foodId'] as num).toInt(),
      foodName: json['foodName'] as String,
      mealType: json['mealType'] as String,
      quantityInGrams: (json['quantityInGrams'] as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
      carbohydrate: (json['carbohydrate'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}