import 'package:flutter/material.dart';

import 'services/auth_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.email});

  final String email;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isHovering = false;

  Future<void> _signOut(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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
                    backgroundColor: _isHovering ? Colors.red : Colors.white,
                    foregroundColor: _isHovering ? Colors.white : Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      body: Center(
        child: Text(widget.email),
      ),
    );
  }
}