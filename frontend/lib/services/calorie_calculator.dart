import '../models/user_profile.dart';

/// Client-side calorie target calculation using the Mifflin-St Jeor equation.
class CalorieCalculator {
  /// Calculates BMR (Basal Metabolic Rate) using Mifflin-St Jeor.
  static double _bmr(UserProfile user) {
    final base = 10 * user.weight + 6.25 * user.height - 5 * user.age;
    switch (user.gender) {
      case 'MALE':
        return base + 5;
      case 'FEMALE':
        return base - 161;
      default:
        return base + (5 - 161) / 2;
    }
  }

  /// Activity level multipliers.
  static double _activityMultiplier(String activityLevel) {
    switch (activityLevel) {
      case 'SEDENTARY':
        return 1.2;
      case 'LIGHTLY_ACTIVE':
        return 1.375;
      case 'MODERATELY_ACTIVE':
        return 1.55;
      case 'VERY_ACTIVE':
        return 1.725;
      case 'EXTRA_ACTIVE':
        return 1.9;
      default:
        return 1.2;
    }
  }

  /// Goal-based daily calorie adjustment (kcal).
  static double _goalAdjustment(String goalType) {
    switch (goalType) {
      case 'CUTTING':
        return -500;
      case 'BULKING':
        return 500;
      default:
        return 0;
    }
  }

  /// Computes the recommended daily calorie target.
  static int dailyCalorieTarget(UserProfile user) {
    final tdee = _bmr(user) * _activityMultiplier(user.activityLevel);
    final target = tdee + _goalAdjustment(user.goalType);
    return target.round();
  }

  /// Computes body mass index.
  static double bmi(UserProfile user) {
    final heightInMeters = user.height / 100;
    return user.weight / (heightInMeters * heightInMeters);
  }
}