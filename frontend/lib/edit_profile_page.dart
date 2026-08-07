import 'package:flutter/material.dart';

import 'models/user_profile.dart';
import 'services/api_service.dart';

/// Allows a signed-in user to edit their profile data such as goal type,
/// activity level, gender, weight, height, age, and username.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});

  final UserProfile user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  late final TextEditingController _usernameController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;

  late String _selectedGender;
  late String _selectedActivityLevel;
  late String _selectedGoalType;

  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _usernameController = TextEditingController(text: user.username);
    _ageController = TextEditingController(text: user.age.toString());
    _weightController = TextEditingController(text: user.weight.toString());
    _heightController = TextEditingController(text: user.height.toString());
    _selectedGender = user.gender;
    _selectedActivityLevel = user.activityLevel;
    _selectedGoalType = user.goalType;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final age = int.tryParse(_ageController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());
    final height = double.tryParse(_heightController.text.trim());

    if (age == null || weight == null || height == null) {
      setState(() {
        _errorMessage = 'Please enter valid numbers for age, weight, and height.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final updated = await _apiService.updateUserProfile(
        id: widget.user.id,
        username: _usernameController.text.trim(),
        age: age,
        gender: _selectedGender,
        weight: weight,
        height: height,
        activityLevel: _selectedActivityLevel,
        goalType: _selectedGoalType,
      );

      if (!mounted) return;
      Navigator.of(context).pop(updated);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Your Profile',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Update your details below. Your calorie targets update automatically.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _usernameController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.cake_outlined),
                          ),
                          validator: (value) {
                            final parsed = int.tryParse(value?.trim() ?? '');
                            if (parsed == null || parsed < 1) {
                              return 'Please enter a valid age';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedGender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.wc),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'MALE', child: Text('Male')),
                            DropdownMenuItem(
                                value: 'FEMALE', child: Text('Female')),
                            DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value ?? 'MALE';
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _weightController,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.monitor_weight_outlined),
                          ),
                          validator: (value) {
                            final parsed = double.tryParse(value?.trim() ?? '');
                            if (parsed == null || parsed < 1) {
                              return 'Please enter a valid weight';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _heightController,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Height (cm)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.height),
                          ),
                          validator: (value) {
                            final parsed = double.tryParse(value?.trim() ?? '');
                            if (parsed == null || parsed < 1) {
                              return 'Please enter a valid height';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedActivityLevel,
                          decoration: const InputDecoration(
                            labelText: 'Activity level',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.directions_run),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'SEDENTARY', child: Text('Sedentary')),
                            DropdownMenuItem(
                                value: 'LIGHTLY_ACTIVE',
                                child: Text('Lightly active')),
                            DropdownMenuItem(
                                value: 'MODERATELY_ACTIVE',
                                child: Text('Moderately active')),
                            DropdownMenuItem(
                                value: 'VERY_ACTIVE', child: Text('Very active')),
                            DropdownMenuItem(
                                value: 'EXTRA_ACTIVE',
                                child: Text('Extra active')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedActivityLevel = value ?? 'MODERATELY_ACTIVE';
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedGoalType,
                          decoration: const InputDecoration(
                            labelText: 'Goal type',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.flag_outlined),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'CUTTING', child: Text('Cutting')),
                            DropdownMenuItem(
                                value: 'MAINTAINING',
                                child: Text('Maintaining')),
                            DropdownMenuItem(
                                value: 'BULKING', child: Text('Bulking')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedGoalType = value ?? 'MAINTAINING';
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        FilledButton.icon(
                          onPressed: _isSaving ? null : _save,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(_isSaving ? 'Saving...' : 'Save changes'),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _isSaving
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
