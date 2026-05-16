import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'admin_appbar.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  const AdminLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(),
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[100],
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
