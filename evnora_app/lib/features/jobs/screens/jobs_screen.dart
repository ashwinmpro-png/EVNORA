import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/themes.dart';
import '../../../config/constants.dart';
import '../../../core/models/job.dart';
import '../providers/jobs_provider.dart';
import '../../home/widgets/job_card.dart';
import '../../../shared/widgets/custom_text_field.dart';

class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String? _selectedJobType;

  final List<_TabItem> _tabs = [
    _TabItem(label: 'All Jobs', type: null),
    _TabItem(label: 'Blue Collar', type: 'blue_collar'),
    _TabItem(label: 'White Collar', type: 'white_collar'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      _selectedJobType = _tabs[_tabController.index].type;
    });
    _updateFilter();
  }

  void _updateFilter() {
    final currentFilter = ref.read(jobFilterProvider);
    ref.read(jobFilterProvider.notifier).state = currentFilter.copyWith(
      jobType: _selectedJobType,
      searchQuery: _searchController.text.isNotEmpty ? _searchController.text : null,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(jobFilterProvider);
    final jobsAsync = ref.watch(jobsProvider(filter));
    final savedJobs = ref.watch(savedJobsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {
              // Navigate to saved jobs
              _showSavedJobs();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search jobs...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _updateFilter();
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.tune),
                            onPressed: _showFilterSheet,
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _updateFilter(),
                ),
              ),

              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.grey500,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
              ),
            ],
          ),
        ),
      ),
      body: jobsAsync.when(
        data: (jobs) {
          if (jobs.isEmpty) {
            return _buildEmptyState();
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(jobsProvider(filter));
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                final isSaved = savedJobs.any((j) => j.id == job.id);
                return JobListCard(
                  job: job,
                  isSaved: isSaved,
                  onTap: () => context.push('/jobs/${job.id}'),
                  onSave: () {
                    if (isSaved) {
                      ref.read(savedJobsProvider.notifier).removeJob(job.id);
                    } else {
                      ref.read(savedJobsProvider.notifier).saveJob(job);
                    }
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Failed to load jobs',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(jobsProvider(filter)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.work_off_outlined,
            size: 80,
            color: AppColors.grey300,
          ),
          const SizedBox(height: 16),
          Text(
            'No jobs found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(jobFilterProvider.notifier).state = const JobFilter();
              _searchController.clear();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _FilterBottomSheet(),
    );
  }

  void _showSavedJobs() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final savedJobs = ref.watch(savedJobsProvider);
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) {
              return Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Saved Jobs (${savedJobs.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: savedJobs.isEmpty
                        ? const Center(
                            child: Text('No saved jobs'),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: savedJobs.length,
                            itemBuilder: (context, index) {
                              final job = savedJobs[index];
                              return JobListCard(
                                job: job,
                                isSaved: true,
                                onTap: () {
                                  Navigator.pop(context);
                                  context.push('/jobs/${job.id}');
                                },
                                onSave: () {
                                  ref
                                      .read(savedJobsProvider.notifier)
                                      .removeJob(job.id);
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _TabItem {
  final String label;
  final String? type;

  _TabItem({required this.label, this.type});
}

class _FilterBottomSheet extends ConsumerStatefulWidget {
  const _FilterBottomSheet();

  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  String? _selectedCountry;
  String? _selectedEmploymentType;
  RangeValues _experienceRange = const RangeValues(0, 20);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Jobs',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCountry = null;
                        _selectedEmploymentType = null;
                        _experienceRange = const RangeValues(0, 20);
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Country
              Text(
                'Location',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'India',
                  'UAE',
                  'Saudi Arabia',
                  'Qatar',
                  'Oman',
                  'Kuwait',
                ].map((country) {
                  final isSelected = _selectedCountry == country;
                  return FilterChip(
                    label: Text(country),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCountry = selected ? country : null;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Employment type
              Text(
                'Employment Type',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Full Time',
                  'Part Time',
                  'Contract',
                ].map((type) {
                  final isSelected = _selectedEmploymentType == type.toLowerCase().replaceAll(' ', '_');
                  return FilterChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedEmploymentType = selected
                            ? type.toLowerCase().replaceAll(' ', '_')
                            : null;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Experience
              Text(
                'Experience: ${_experienceRange.start.round()} - ${_experienceRange.end.round()} years',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              RangeSlider(
                values: _experienceRange,
                min: 0,
                max: 20,
                divisions: 20,
                labels: RangeLabels(
                  '${_experienceRange.start.round()} yrs',
                  '${_experienceRange.end.round()} yrs',
                ),
                onChanged: (values) {
                  setState(() {
                    _experienceRange = values;
                  });
                },
              ),

              const SizedBox(height: 32),

              // Apply button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final currentFilter = ref.read(jobFilterProvider);
                    ref.read(jobFilterProvider.notifier).state = currentFilter.copyWith(
                      country: _selectedCountry,
                      employmentType: _selectedEmploymentType,
                      experienceMin: _experienceRange.start.round().toString(),
                      experienceMax: _experienceRange.end.round().toString(),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
