import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/themes.dart';
import '../../../core/models/program.dart';
import '../providers/programs_provider.dart';
import '../../home/widgets/program_card.dart';

class ProgramsScreen extends ConsumerStatefulWidget {
  const ProgramsScreen({super.key});

  @override
  ConsumerState<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends ConsumerState<ProgramsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  final List<_ProgramTab> _tabs = [
    _ProgramTab(label: 'All', category: null),
    _ProgramTab(label: 'Blue Collar', category: 'blue_collar'),
    _ProgramTab(label: 'White Collar', category: 'white_collar'),
    _ProgramTab(label: 'Digital', category: 'digital_soft_skills'),
    _ProgramTab(label: 'HSE', category: 'hse'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final category = _tabs[_tabController.index].category;
    ref.read(programFilterProvider.notifier).state = ProgramFilter(category: category);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(programFilterProvider);
    final programsAsync = ref.watch(programsProvider(filter));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Programs'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search programs...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                  ),
                  onSubmitted: (value) {
                    ref.read(programFilterProvider.notifier).state = filter.copyWith(
                      searchQuery: value.isNotEmpty ? value : null,
                    );
                  },
                ),
              ),
              // Tabs
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.grey500,
                indicatorColor: AppColors.primary,
                tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
              ),
            ],
          ),
        ),
      ),
      body: programsAsync.when(
        data: (programs) {
          if (programs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school_outlined, size: 80, color: AppColors.grey300),
                  const SizedBox(height: 16),
                  Text('No programs found', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(programsProvider(filter)),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: programs.length,
              itemBuilder: (context, index) {
                return ProgramListCard(
                  program: programs[index],
                  onTap: () => context.push('/programs/${programs[index].id}'),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              const Text('Failed to load programs'),
              ElevatedButton(
                onPressed: () => ref.invalidate(programsProvider(filter)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramTab {
  final String label;
  final String? category;
  _ProgramTab({required this.label, this.category});
}
