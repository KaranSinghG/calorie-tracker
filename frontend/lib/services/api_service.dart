import '../models/daily_summary.dart';
import '../models/food.dart';
import '../models/food_log.dart';
import '../models/user_profile.dart';
import 'api_client.dart';

class ApiService {
  final ApiClient _apiClient = ApiClient();

  // ── User ────────────────────────────────────────────────────────────────────
  Future<UserProfile> getUserByEmail(String email) async {
    final json = await _apiClient.get('/users/search', query: {'email': email});
    return UserProfile.fromJson(json as Map<String, dynamic>);
  }

  Future<UserProfile> updateUserProfile({
    required int id,
    required String username,
    required String email,
    required int age,
    required String gender,
    required double weight,
    required double height,
    required String activityLevel,
    required String goalType,
  }) async {
    final json = await _apiClient.put('/users/$id', body: {
      'username': username,
      'email': email,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'activityLevel': activityLevel,
      'goalType': goalType,
    });
    return UserProfile.fromJson(json as Map<String, dynamic>);
  }

  // ── Foods ──────────────────────────────────────────────────────────────────
  Future<List<Food>> getAllFoods() async {
    final json = await _apiClient.get('/foods/all') as List<dynamic>;
    return json
        .map((item) => Food.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Food> createFood({
    required String name,
    required double calories,
    required double carbohydrate,
    required double protein,
    required double fat,
    required double perItemWeight,
  }) async {
    final json = await _apiClient.post('/foods/create', body: {
      'name': name,
      'calories': calories,
      'carbohydrate': carbohydrate,
      'protein': protein,
      'fat': fat,
      'perItemWeight': perItemWeight,
    });
    return Food.fromJson(json as Map<String, dynamic>);
  }

  // ── Food Logs ──────────────────────────────────────────────────────────────
  Future<DailySummary> getDailySummary(DateTime date) async {
    final dateStr =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final json =
        await _apiClient.get('/food-logs/summary', query: {'date': dateStr});
    return DailySummary.fromJson(json as Map<String, dynamic>);
  }

  Future<List<FoodLog>> getFoodLogsByDate(DateTime date) async {
    final dateStr =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final json = await _apiClient.get('/food-logs', query: {'date': dateStr});
    return (json as List<dynamic>)
        .map((item) => FoodLog.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<FoodLog> logFood({
    required int userId,
    required int foodId,
    required double amount,
    required String unit,
    required String mealType,
  }) async {
    final json = await _apiClient.post('/food-logs/log', body: {
      'userId': userId,
      'foodId': foodId,
      'amount': amount,
      'unit': unit,
      'mealType': mealType,
    });
    return FoodLog.fromJson(json as Map<String, dynamic>);
  }

  Future<void> deleteFoodLog(int foodLogId) async {
    await _apiClient.delete('/food-logs/$foodLogId');
  }
}