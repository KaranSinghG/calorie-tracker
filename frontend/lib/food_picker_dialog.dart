import 'package:flutter/material.dart';

import 'models/food.dart';

/// Result of the food picker dialog, ready to be logged via the API.
class FoodLogInput {
  const FoodLogInput({
    required this.food,
    required this.quantityInGrams,
    required this.mealType,
  });

  final Food food;
  final double quantityInGrams;
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

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController =
      TextEditingController(text: '100');

  late final List<Food> _sortedFoods = [...widget.foods]..sort((a, b) {
      final byName = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      return byName != 0 ? byName : a.id.compareTo(b.id);
    });

  String _query = '';
  String _mealType = 'BREAKFAST';
  Food? _selectedFood;
  String? _quantityError;

  List<Food> get _filteredFoods {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _sortedFoods;
    return _sortedFoods
        .where((food) => food.name.toLowerCase().contains(q))
        .toList();
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
      setState(() => _quantityError = 'Enter a valid quantity in grams');
      return;
    }
    Navigator.of(context).pop(FoodLogInput(
      food: _selectedFood!,
      quantityInGrams: quantity,
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
          TextField(
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
  }  // ---- Step 2: quantity + meal type ----
  Widget _buildAmountStep(Food food) {
    final theme = Theme.of(context);
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
            '${food.calories.toStringAsFixed(0)} kcal per 100g',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
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
            children: _quickQuantities.map((grams) {
              return ChoiceChip(
                label: Text('$grams g'),
                selected: _quantityController.text == '$grams',
                onSelected: (_) => setState(() {
                  _quantityController.text = '$grams';
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
              labelText: 'Quantity (grams)',
              hintText: 'e.g. 100',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.scale),
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