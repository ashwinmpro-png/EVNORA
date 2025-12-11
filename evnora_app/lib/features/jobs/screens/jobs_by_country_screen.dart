import 'package:flutter/material.dart';

class JobsByCountryScreen extends StatelessWidget {
  const JobsByCountryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jobs by Country')),
      body: const Center(child: Text('Jobs by Country Screen')),
    );
  }
}
