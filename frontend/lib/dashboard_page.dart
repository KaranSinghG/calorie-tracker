import 'package:flutter/material.dart';

import 'edit_profile_page.dart';
import 'food_picker_dialog.dart';
import 'models/daily_summary.dart';
import 'models/food.dart';
import 'models/food_log.dart';
import 'models/user_profile.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/calorie_calculator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.email});

  final String email;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _apiService = ApiService();
  final _authService = AuthService();
  bool _isHovering = false;
  bool _isLoading = true;
  String? _errorMessage;

  UserProfile? _user;
  DailySummary? _summary;
  List<FoodLog> _foodLogs = [];
  List<Food> _allFoods = [];

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _apiService.getUserByEmail(widget.email);
      final summary = await _apiService.getDailySummary(_selectedDate);
      final foodLogs = await _apiService.getFoodLogsByDate(_selectedDate);
      final allFoods = await _apiService.getAllFoods();

      if (!mounted) return;
      setState(() {
        _user = user;
        _summary = summary;
        _foodLogs = foodLogs;
        _allFoods = allFoods;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await _authService.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  Future<void> _changeDate(DateTime date) async {
    setState(() {
      _selectedDate = date;
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final summary = await _apiService.getDailySummary(date);
      final foodLogs = await _apiService.getFoodLogsByDate(date);
      if (!mounted) return;
      setState(() {
        _summary = summary;
        _foodLogs = foodLogs;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddFoodDialog() async {
    if (_user == null || _allFoods.isEmpty) return;

    final input = await showDialog<FoodLogInput>(
      context: context,
      builder: (_) => FoodPickerDialog(foods: _allFoods),
    );
    if (input == null || !mounted) return;

    try {
      await _apiService.logFood(
        userId: _user!.id,
        foodId: input.food.id,
        amount: input.quantity,
        unit: input.quantityType,
        mealType: input.mealType,
      );
      await _loadDashboardData();
      if (mounted && _errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Food logged successfully')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    }
  }

  Future<void> _deleteFoodLog(FoodLog log) async {
    try {
      await _apiService.deleteFoodLog(log.id);
      await _loadDashboardData();
      if (mounted && _errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Food log deleted')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    }
  }

  Future<void> _editProfile() async {
    if (_user == null) return;

    final updated = await Navigator.of(context).push<UserProfile>(
      MaterialPageRoute(builder: (_) => EditProfilePage(user: _user!)),
    );

    if (updated != null && mounted) {
      setState(() {
        _user = updated;
      });
      await _loadDashboardData();
      if (mounted && _errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovering = true),
                onExit: (_) => setState(() => _isHovering = false),
                child: FilledButton.icon(
                  onPressed: () => _signOut(context),
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        _isHovering ? Colors.red : Colors.white,
                    foregroundColor: _isHovering
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Sign out'),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState()
              : _buildDashboard(),
      floatingActionButton: _user != null
          ? FloatingActionButton.extended(
              onPressed: _showAddFoodDialog,
              icon: const Icon(Icons.add),
              label: const Text('Log Food'),
            )
          : null,
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load dashboard',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _loadDashboardData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    final user = _user!;
    final summary = _summary!;
    final calorieTarget = CalorieCalculator.dailyCalorieTarget(user);
    final remainingCalories = calorieTarget - summary.totalCalories;
    final bmi = CalorieCalculator.bmi(user);

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          final content = SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: isWide
                    ? _buildWideLayout(user, summary, calorieTarget,
                        remainingCalories, bmi)
                    : _buildNarrowLayout(user, summary, calorieTarget,
                        remainingCalories, bmi),
              ),
            ),
          );
          return content;
        },
      ),
    );
  }

  // ── Wide (Web/Desktop) Layout ──────────────────────────────────────────────
  Widget _buildWideLayout(UserProfile user, DailySummary summary,
      int calorieTarget, double remainingCalories, double bmi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateNavigator(),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column: Calorie summary + macros
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  _buildCalorieSummaryCard(
                      summary, calorieTarget, remainingCalories),
                  const SizedBox(height: 16),
                  _buildMacroBreakdownCard(user, summary),
                  const SizedBox(height: 16),
                  _buildMealBreakdownCard(),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Right column: Profile + food log
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildProfileCard(user, bmi),
                  const SizedBox(height: 16),
                  _buildFoodLogCard(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Narrow (Mobile) Layout ─────────────────────────────────────────────────
  Widget _buildNarrowLayout(UserProfile user, DailySummary summary,
      int calorieTarget, double remainingCalories, double bmi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateNavigator(),
        const SizedBox(height: 16),
        _buildCalorieSummaryCard(summary, calorieTarget, remainingCalories),
        const SizedBox(height: 16),
        _buildMacroBreakdownCard(user, summary),
        const SizedBox(height: 16),
        _buildMealBreakdownCard(),
        const SizedBox(height: 16),
        _buildProfileCard(user, bmi),
        const SizedBox(height: 16),
        _buildFoodLogCard(),
      ],
    );
  }

  // ── Date Navigator ─────────────────────────────────────────────────────────
  Widget _buildDateNavigator() {
    final isToday = _isSameDay(_selectedDate, DateTime.now());
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                _changeDate(_selectedDate.subtract(const Duration(days: 1)));
              },
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Previous day',
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _changeDate(picked);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    isToday
                        ? 'Today · ${_formatDate(_selectedDate)}'
                        : _formatDate(_selectedDate),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: isToday
                  ? null
                  : () {
                      _changeDate(_selectedDate.add(const Duration(days: 1)));
                    },
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Next day',
            ),
          ],
        ),
      ),
    );
  }

  // ── 1. Daily Calorie Summary Card ──────────────────────────────────────────
  Widget _buildCalorieSummaryCard(DailySummary summary, int calorieTarget,
      double remainingCalories) {
    final progress = calorieTarget > 0
        ? (summary.totalCalories / calorieTarget).clamp(0.0, 1.0)
        : 0.0;
    final isOver = summary.totalCalories > calorieTarget;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_fire_department,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Daily Calories',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Progress ring
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isOver
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              summary.totalCalories.toStringAsFixed(0),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isOver
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary,
                                  ),
                            ),
                            Text(
                              'kcal',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryRow(
                        icon: Icons.flag_outlined,
                        label: 'Target',
                        value: '$calorieTarget kcal',
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        icon: Icons.restaurant,
                        label: 'Consumed',
                        value: '${summary.totalCalories.toStringAsFixed(0)} kcal',
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        icon: isOver
                            ? Icons.warning_amber_rounded
                            : Icons.trending_down,
                        label: isOver ? 'Over by' : 'Remaining',
                        value:
                            '${remainingCalories.abs().toStringAsFixed(0)} kcal',
                        valueColor: isOver
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
        ),
      ],
    );
  }

  // ── 2. Macronutrient Breakdown Card ────────────────────────────────────────
  Widget _buildMacroBreakdownCard(UserProfile user, DailySummary summary) {
    final totalMacros =
        summary.totalProtein + summary.totalCarbohydrate + summary.totalFat;
    final targets = CalorieCalculator.macroTargets(user);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart_outline,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Macronutrients',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMacroBar(
              label: 'Protein',
              value: summary.totalProtein,
              total: totalMacros,
              target: targets.protein,
              color: Colors.blue,
              icon: Icons.fitness_center,
            ),
            const SizedBox(height: 12),
            _buildMacroBar(
              label: 'Carbs',
              value: summary.totalCarbohydrate,
              total: totalMacros,
              target: targets.carbs,
              color: Colors.orange,
              icon: Icons.grain,
            ),
            const SizedBox(height: 12),
            _buildMacroBar(
              label: 'Fat',
              value: summary.totalFat,
              total: totalMacros,
              target: targets.fat,
              color: Colors.purple,
              icon: Icons.water_drop,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBar({
    required String label,
    required double value,
    required double total,
    required Color color,
    required IconData icon,
    double? target,
  }) {
    // Determine target state: under, met (within tolerance), or over.
    // We treat "met" as within 0.5g of the target so users don't see a
    // jarring "over" warning when they're essentially right on target.
    final targetValue = target;
    final hasTarget = targetValue != null;
    final isOver = hasTarget && value > targetValue + 0.5;
    final isMet = hasTarget && !isOver && value >= targetValue - 0.5;
    final hasMeaningfulGap = hasTarget && !isMet && !isOver;
    final remaining = hasTarget
        ? (targetValue - value).clamp(0.0, double.infinity)
        : 0.0;
    final overBy = hasTarget
        ? (value - targetValue).clamp(0.0, double.infinity)
        : 0.0;

    // Status color drives both the progress bar and the value/target label.
    final statusColor = isOver
        ? Theme.of(context).colorScheme.error
        : isMet
            ? Colors.green
            : Theme.of(context).colorScheme.outline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Spacer(),
            if (hasTarget)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '${value.toStringAsFixed(0)}g / ${targetValue.toStringAsFixed(0)}g',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: (isMet || isOver)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                ),
              )
            else
              Text(
                '${value.toStringAsFixed(1)}g',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            // Pin visual progress at 100% when over — the color is what
            // communicates the overshoot, not the bar fill ratio.
            value: hasTarget && targetValue > 0
                ? (value / targetValue).clamp(0.0, 1.0)
                : 0.0,
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(
              isOver
                  ? Theme.of(context).colorScheme.error
                  : isMet
                      ? Colors.green
                      : color,
            ),
          ),
        ),
        if (hasMeaningfulGap)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Need ${remaining.toStringAsFixed(1)}g more',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 11,
                  ),
            ),
          )
        else if (isOver)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 13,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 4),
                Text(
                  'Over by ${overBy.toStringAsFixed(1)}g',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          )
        else if (isMet)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 13,
                  color: Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  'Target met',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ── 3. Meal Type Breakdown Card ────────────────────────────────────────────
  Widget _buildMealBreakdownCard() {
    final mealTypes = ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK'];
    final mealLabels = {
      'BREAKFAST': 'Breakfast',
      'LUNCH': 'Lunch',
      'DINNER': 'Dinner',
      'SNACK': 'Snack',
    };
    final mealIcons = {
      'BREAKFAST': Icons.free_breakfast,
      'LUNCH': Icons.lunch_dining,
      'DINNER': Icons.dinner_dining,
      'SNACK': Icons.cookie,
    };
    final mealColors = {
      'BREAKFAST': Colors.orange,
      'LUNCH': Colors.green,
      'DINNER': Colors.indigo,
      'SNACK': Colors.pink,
    };

    final mealCalories = <String, double>{};
    for (final type in mealTypes) {
      mealCalories[type] = _foodLogs
          .where((log) => log.mealType == type)
          .fold(0.0, (sum, log) => sum + log.calories);
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Meals',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: mealTypes.map((type) {
                final calories = mealCalories[type] ?? 0;
                return Expanded(
                  child: _buildMealTypeItem(
                    label: mealLabels[type]!,
                    icon: mealIcons[type]!,
                    color: mealColors[type]!,
                    calories: calories,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTypeItem({
    required String label,
    required IconData icon,
    required Color color,
    required double calories,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '${calories.toStringAsFixed(0)} kcal',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }

  // ── 4. User Profile Card ───────────────────────────────────────────────────
  Widget _buildProfileCard(UserProfile user, double bmi) {
    final goalLabels = {
      'CUTTING': 'Cutting',
      'MAINTAINING': 'Maintaining',
      'BULKING': 'Bulking',
    };
    final activityLabels = {
      'SEDENTARY': 'Sedentary',
      'LIGHTLY_ACTIVE': 'Lightly active',
      'MODERATELY_ACTIVE': 'Moderately active',
      'VERY_ACTIVE': 'Very active',
      'EXTRA_ACTIVE': 'Extra active',
    };

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    goalLabels[user.goalType] ?? user.goalType,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: _editProfile,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: 'Edit profile',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildProfileStat(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Weight',
                  value: '${user.weight.toStringAsFixed(1)} kg',
                ),
                _buildProfileStat(
                  icon: Icons.height,
                  label: 'Height',
                  value: '${user.height.toStringAsFixed(1)} cm',
                ),
                _buildProfileStat(
                  icon: Icons.cake_outlined,
                  label: 'Age',
                  value: '${user.age} yrs',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildProfileStat(
                  icon: Icons.speed,
                  label: 'BMI',
                  value: bmi.toStringAsFixed(1),
                ),
                _buildProfileStat(
                  icon: Icons.directions_run,
                  label: 'Activity',
                  value: activityLabels[user.activityLevel] ?? user.activityLevel,
                ),
                _buildProfileStat(
                  icon: Icons.flag_outlined,
                  label: 'Goal',
                  value: goalLabels[user.goalType] ?? user.goalType,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── 5. Today's Food Log Card ───────────────────────────────────────────────
  Widget _buildFoodLogCard() {
    final mealOrder = ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK'];
    final mealLabels = {
      'BREAKFAST': 'Breakfast',
      'LUNCH': 'Lunch',
      'DINNER': 'Dinner',
      'SNACK': 'Snack',
    };
    final mealIcons = {
      'BREAKFAST': Icons.free_breakfast,
      'LUNCH': Icons.lunch_dining,
      'DINNER': Icons.dinner_dining,
      'SNACK': Icons.cookie,
    };

    final groupedLogs = <String, List<FoodLog>>{};
    for (final type in mealOrder) {
      groupedLogs[type] =
          _foodLogs.where((log) => log.mealType == type).toList();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Food Log',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Text(
                  '${_foodLogs.length} items',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_foodLogs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 48,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No food logged for this day',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap "Log Food" to add your first meal',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              )
            else
              ...mealOrder.map((type) {
                final logs = groupedLogs[type] ?? [];
                if (logs.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(mealIcons[type],
                            size: 18,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          mealLabels[type]!,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          '${logs.fold<double>(0, (sum, log) => sum + log.calories).toStringAsFixed(0)} kcal',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...logs.map((log) => _buildFoodLogItem(log)),
                    const SizedBox(height: 16),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodLogItem(FoodLog log) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            log.foodName.isNotEmpty ? log.foodName[0].toUpperCase() : '?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          log.foodName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${log.quantityInGrams.toStringAsFixed(0)}g · P ${log.protein.toStringAsFixed(1)}g · C ${log.carbohydrate.toStringAsFixed(1)}g · F ${log.fat.toStringAsFixed(1)}g',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${log.calories.toStringAsFixed(0)} kcal',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              color: Theme.of(context).colorScheme.error,
              onPressed: () => _confirmDeleteFoodLog(log),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteFoodLog(FoodLog log) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete food log'),
        content: Text('Are you sure you want to delete "${log.foodName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteFoodLog(log);
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}