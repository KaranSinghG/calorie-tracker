import 'package:flutter/material.dart';

import 'models/food.dart';
import 'services/api_service.dart';

/// Result of the food picker dialog, ready to be logged via the API.
class FoodLogInput {
  const FoodLogInput({
    required this.food,
    required this.quantity,
    required this.quantityType,
    required this.mealType,
  });

  final Food food;
  final double quantity;
  final String quantityType; // 'GRAMS' or 'QUANTITY'
  final String mealType;
}

/// A friendly, searchable food picker for logging meals.
///
/// Step 1 shows a searchable, alphabetically sorted list of foods.
/// Tapping one advances to step 2 (quantity + meal type) within the
/// same dialog. Returns [FoodLogInput] on success, or `null` on cancel.
class FoodPickerDialog extends StatefulWidget {
  const FoodPickerDialog({super.key, required this.foods});

  final List<Food> foods;

  @override
  State<FoodPickerDialog> createState() => _FoodPickerDialogState();
}class _FoodPickerDialogState extends State<FoodPickerDialog> {
  static const List<String> _mealTypes = ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK'];
  static const Map<String, String> _mealLabels = {
    'BREAKFAST': 'Breakfast',
    'LUNCH': 'Lunch',
    'DINNER': 'Dinner',
    'SNACK': 'Snack',
  };
  static const List<int> _quickQuantities = [50, 100, 150, 200, 300];

  final _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController =
      TextEditingController(text: '100');

  late List<Food> _foods = [...widget.foods]..sort((a, b) {
      final byName = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      return byName != 0 ? byName : a.id.compareTo(b.id);
    });

  String _query = '';
  String _mealType = 'BREAKFAST';
  String _quantityType = 'GRAMS'; // 'GRAMS' or 'QUANTITY'
  Food? _selectedFood;
  String? _quantityError;

  List<Food> get _filteredFoods {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _foods;
    return _foods
        .where((food) => food.name.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _addCustomFood() async {
    final createdFood = await showDialog<Food>(
      context: context,
      builder: (_) => const _CreateCustomFoodDialog(),
    );

    if (createdFood == null) return;

    setState(() {
      _foods = [..._foods, createdFood]
        ..sort((a, b) {
          final byName = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          return byName != 0 ? byName : a.id.compareTo(b.id);
        });
      _selectedFood = createdFood;
      _quantityController.text = '100';
      _query = '';
      _searchController.clear();
      _quantityError = null;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _selectFood(Food food) {
    setState(() {
      _selectedFood = food;
      _quantityError = null;
      _quantityController.text = '100';
    });
  }

  void _submit() {
    final quantity = double.tryParse(_quantityController.text.trim());
    if (quantity == null || quantity <= 0) {
      final unit = _quantityType == 'GRAMS' ? 'grams' : 'items';
      setState(() => _quantityError = 'Enter a valid quantity in $unit');
      return;
    }
    Navigator.of(context).pop(FoodLogInput(
      food: _selectedFood!,
      quantity: quantity,
      quantityType: _quantityType,
      mealType: _mealType,
    ));
  }  @override
  Widget build(BuildContext context) {
    final selected = _selectedFood;
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            selected == null ? Icons.restaurant_menu : Icons.scale,
            size: 22,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Text(selected == null ? 'Choose a food' : 'Set quantity & meal'),
        ],
      ),
      content: selected == null ? _buildFoodStep() : _buildAmountStep(selected),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: selected == null ? null : _submit,
          icon: const Icon(Icons.add),
          label: const Text('Log Food'),
        ),
      ],
    );
  }  // ---- Step 1: searchable food list ----
  Widget _buildFoodStep() {
    final filtered = _filteredFoods;
    final theme = Theme.of(context);

    return SizedBox(
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Search food (e.g. dal, roti, paneer)',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    isDense: true,
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: _addCustomFood,
                child: const Text('Add custom'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.no_food, size: 40, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'No foods match “$_query”',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final food = filtered[index];
                      return _buildFoodListTile(food);
                    },
                  ),
          ),
        ],
      ),
    );
  }  Widget _buildFoodListTile(Food food) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Text(
          food.name.isEmpty ? '?' : food.name[0].toUpperCase(),
          style: TextStyle(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        food.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${food.calories.toStringAsFixed(0)} kcal · '
        '${food.protein.toStringAsFixed(1)}g P · '
        '${food.carbohydrate.toStringAsFixed(1)}g C · '
        '${food.fat.toStringAsFixed(1)}g F per 100g',
      ),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () => _selectFood(food),
    );
  }

  // ---- Step 2: quantity + meal type ----
  Widget _buildAmountStep(Food food) {
    final theme = Theme.of(context);
    final isGrams = _quantityType == 'GRAMS';
    final quickValues = isGrams ? _quickQuantities : [1, 2, 3, 4, 5];

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  food.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _selectedFood = null),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Change'),
              ),
            ],
          ),
          Text(
            isGrams
                ? '${food.calories.toStringAsFixed(0)} kcal per 100g'
                : '${(food.calories * food.perItemWeight / 100).toStringAsFixed(0)} kcal per item',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Measure by',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (food.supportItemQuantity) ...[
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Grams'),
                    selected: _quantityType == 'GRAMS',
                    onSelected: (_) => setState(() {
                      _quantityType = 'GRAMS';
                      _quantityController.text = '100';
                      _quantityError = null;
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: Text('Items (${food.perItemWeight.toStringAsFixed(0)}g each)'),
                    selected: _quantityType == 'QUANTITY',
                    onSelected: (_) => setState(() {
                      _quantityType = 'QUANTITY';
                      _quantityController.text = '1';
                      _quantityError = null;
                    }),
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Measured in: Grams only',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Quantity',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: quickValues.map((value) {
              final label = isGrams ? '${value} g' : '$value';
              return ChoiceChip(
                label: Text(label),
                selected: _quantityController.text == '$value',
                onSelected: (_) => setState(() {
                  _quantityController.text = '$value';
                  _quantityError = null;
                }),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            onChanged: (_) => setState(() => _quantityError = null),
            decoration: InputDecoration(
              labelText: isGrams ? 'Quantity (grams)' : 'Quantity (items)',
              hintText: isGrams ? 'e.g. 100' : 'e.g. 2',
              border: const OutlineInputBorder(),
              prefixIcon: Icon(isGrams ? Icons.scale : Icons.shopping_bag),
              errorText: _quantityError,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Meal type',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _mealTypes.map((type) {
              return ChoiceChip(
                label: Text(_mealLabels[type]!),
                selected: _mealType == type,
                onSelected: (_) => setState(() => _mealType = type),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _CreateCustomFoodDialog extends StatefulWidget {
  const _CreateCustomFoodDialog();

  @override
  State<_CreateCustomFoodDialog> createState() => _CreateCustomFoodDialogState();
}

class _CreateCustomFoodDialogState extends State<_CreateCustomFoodDialog> {
  final _apiService = ApiService();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _carbsController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _weightController = TextEditingController(text: '100');
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final calories = double.tryParse(_caloriesController.text.trim());
    final carbs = double.tryParse(_carbsController.text.trim());
    final protein = double.tryParse(_proteinController.text.trim());
    final fat = double.tryParse(_fatController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());

    if (name.isEmpty ||
        calories == null ||
        carbs == null ||
        protein == null ||
        fat == null ||
        weight == null ||
        weight <= 0) {
      setState(() => _error = 'Please complete all fields with valid values.');
      return;
    }

    try {
      final food = await _apiService.createFood(
        name: name,
        calories: calories,
        carbohydrate: carbs,
        protein: protein,
        fat: fat,
        perItemWeight: weight,
      );
      if (!context.mounted) return;
      Navigator.of(context).pop(food);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add custom food'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Food name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _caloriesController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Calories',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Per item (g)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _carbsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Carbs (g)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _proteinController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Protein (g)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _fatController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Fat (g)',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.save),
          label: const Text('Save food'),
        ),
      ],
    );
  }
}
