class DailySummary {
  final double totalProtein;
  final double totalCarbohydrate;
  final double totalFat;
  final double totalCalories;
  final DateTime date;

  DailySummary({
    required this.totalProtein,
    required this.totalCarbohydrate,
    required this.totalFat,
    required this.totalCalories,
    required this.date,
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      totalProtein: (json['totalProtein'] as num).toDouble(),
      totalCarbohydrate: (json['totalCarbohydrate'] as num).toDouble(),
      totalFat: (json['totalFat'] as num).toDouble(),
      totalCalories: (json['totalCalories'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}