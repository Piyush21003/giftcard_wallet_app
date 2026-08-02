import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090B15),

      appBar: AppBar(
        backgroundColor: const Color(0xFF090B15),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: const Center(
        child: Text(
          "No Notifications Yet",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}