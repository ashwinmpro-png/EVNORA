import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/themes.dart';
import '../providers/programs_provider.dart';
import '../../../shared/widgets/custom_button.dart';

class ProgramDetailsScreen extends ConsumerWidget {
  final String programId;
  const ProgramDetailsScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programAsync = ref.watch(programDetailsProvider(programId));
    
    return programAsync.when(
      data: (program) {
        if (program == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Program not found')),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(program.title)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (program.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(program.imageUrl!, height: 200, width: double.infinity, fit: BoxFit.cover),
                  ),
                const SizedBox(height: 20),
                Text(program.title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(label: Text(program.categoryLabel)),
                    const SizedBox(width: 8),
                    Chip(label: Text(program.formattedDuration)),
                    const SizedBox(width: 8),
                    Chip(label: Text(program.deliveryMode)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(program.formattedPrice, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary)),
                const SizedBox(height: 24),
                Text('Description', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(program.description),
                const SizedBox(height: 100),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
            ),
            child: SafeArea(
              child: CustomButton(
                text: program.isFree ? 'Enroll Now - Free' : 'Enroll Now',
                onPressed: () {},
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $e'))),
    );
  }
}
