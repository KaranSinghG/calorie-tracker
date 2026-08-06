import '../models/user_profile.dart';

/// Represents the daily macro targets in grams.
class MacroTargets {
  final double carbs;
  final double protein;
  final double fat;

  const MacroTargets({
    required this.carbs,
    required this.protein,
    required this.fat,
  });
}

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

  /// Returns the protein target in grams per kg of body weight for the given
  /// goal type, based on Indian Council of Medical Research (ICMR) and
  /// international sports nutrition guidelines.
  ///
  /// - Maintenance: 1.2 g/kg (adequate for general health & light activity)
  /// - Bulk:        1.6 g/kg (muscle building)
  /// - Cut:         1.8 g/kg (preserve muscle during calorie deficit)
  static double _proteinPerKg(String goalType) {
    switch (goalType) {
      case 'BULKING':
        return 1.6;
      case 'CUTTING':
        return 1.8;
      case 'MAINTAINING':
      default:
        return 1.2;
    }
  }

  /// Returns the percentage of remaining calories (after protein) allocated
  /// to carbohydrates. Indian diets are typically higher in carbs (rice,
  /// wheat, dal), so carbs get the larger share.
  static double _carbsShareOfRemaining(String goalType) {
    switch (goalType) {
      case 'BULKING':
        return 0.7; // 70% carbs, 30% fat
      case 'CUTTING':
        return 0.5; // 50% carbs, 50% fat
      case 'MAINTAINING':
      default:
        return 0.6; // 60% carbs, 40% fat
    }
  }

  /// Computes the daily macro targets in grams for the given user.
  ///
  /// Protein is set based on body weight (g/kg), which is the scientifically
  /// recommended approach. Carbs and fat then fill the remaining calories.
  static MacroTargets macroTargets(UserProfile user) {
    final calories = dailyCalorieTarget(user).toDouble();

    // Protein: based on body weight (g/kg).
    final protein = user.weight * _proteinPerKg(user.goalType);
    final proteinCalories = protein * 4;

    // Remaining calories split between carbs and fat.
    final remainingCalories = calories - proteinCalories;
    final carbsShare = _carbsShareOfRemaining(user.goalType);
    final carbs = (remainingCalories * carbsShare) / 4;
    final fat = (remainingCalories * (1 - carbsShare)) / 9;

    return MacroTargets(carbs: carbs, protein: protein, fat: fat);
  }
}
