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

  // ── Foods ──────────────────────────────────────────────────────────────────
  Future<List<Food>> getAllFoods() async {
    final json = await _apiClient.get('/foods/all') as List<dynamic>;
    return json
        .map((item) => Food.fromJson(item as Map<String, dynamic>))
        .toList();
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
    required double quantityInGrams,
    required String mealType,
  }) async {
    final json = await _apiClient.post('/food-logs/log', body: {
      'userId': userId,
      'foodId': foodId,
      'quantityInGrams': quantityInGrams,
      'mealType': mealType,
    });
    return FoodLog.fromJson(json as Map<String, dynamic>);
  }

  Future<void> deleteFoodLog(int foodLogId) async {
    await _apiClient.delete('/food-logs/$foodLogId');
  }
}