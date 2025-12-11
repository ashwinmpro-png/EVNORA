// jobs_by_company_screen.dart
import 'package:flutter/material.dart';
import '../../../config/themes.dart';

class JobsByCompanyScreen extends StatelessWidget {
  const JobsByCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jobs by Company')),
      body: const Center(child: Text('Jobs by Company Screen')),
    );
  }
}
