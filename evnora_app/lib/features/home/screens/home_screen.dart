import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../config/routes.dart';
import '../../../config/themes.dart';
import '../../../config/constants.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/job.dart';
import '../../../core/models/program.dart';
import '../../jobs/providers/jobs_provider.dart';
import '../../programs/providers/programs_provider.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/category_card.dart';
import '../widgets/job_card.dart';
import '../widgets/program_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final featuredJobs = ref.watch(featuredJobsProvider);
    final featuredPrograms = ref.watch(featuredProgramsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(featuredJobsProvider);
            ref.invalidate(featuredProgramsProvider);
          },
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverToBoxAdapter(
                child: _buildHeader(user?.fullName ?? 'Guest'),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: HomeSearchBar(
                    onTap: () {
                      // TODO: Navigate to search screen
                    },
                  ),
                ),
              ),

              // Categories
              SliverToBoxAdapter(
                child: _buildCategories(),
              ),

              // Featured Jobs Section
              SliverToBoxAdapter(
                child: _buildSectionHeader(
                  'Featured Jobs',
                  onViewAll: () => context.go(AppRoutes.jobs),
                ),
              ),

              // Jobs List
              featuredJobs.when(
                data: (jobs) => SliverToBoxAdapter(
                  child: _buildJobsList(jobs),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: _JobsLoadingShimmer(),
                ),
                error: (error, _) => SliverToBoxAdapter(
                  child: _buildErrorWidget(error.toString()),
                ),
              ),

              // Programs Section
              SliverToBoxAdapter(
                child: _buildSectionHeader(
                  'Popular Programs',
                  onViewAll: () => context.go(AppRoutes.programs),
                ),
              ),

              // Programs List
              featuredPrograms.when(
                data: (programs) => SliverToBoxAdapter(
                  child: _buildProgramsList(programs),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: _ProgramsLoadingShimmer(),
                ),
                error: (error, _) => SliverToBoxAdapter(
                  child: _buildErrorWidget(error.toString()),
                ),
              ),

              // Why Evnora Section
              SliverToBoxAdapter(
                child: _buildWhyEvnora(),
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${userName.split(' ').first}! 👋',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Find your dream job today',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey500,
                    ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => context.go(AppRoutes.profile),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Explore Categories',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CategoryCard(
                  icon: Icons.construction,
                  title: 'Blue Collar',
                  subtitle: '200+ Jobs',
                  color: AppColors.blueCollar,
                  onTap: () {
                    context.go('${AppRoutes.jobs}?type=blue_collar');
                  },
                ),
                const SizedBox(width: 12),
                CategoryCard(
                  icon: Icons.business_center,
                  title: 'White Collar',
                  subtitle: '150+ Jobs',
                  color: AppColors.whiteCollar,
                  onTap: () {
                    context.go('${AppRoutes.jobs}?type=white_collar');
                  },
                ),
                const SizedBox(width: 12),
                CategoryCard(
                  icon: Icons.health_and_safety,
                  title: 'HSE',
                  subtitle: '50+ Jobs',
                  color: AppColors.hse,
                  onTap: () {
                    context.go('${AppRoutes.jobs}?type=hse');
                  },
                ),
                const SizedBox(width: 12),
                CategoryCard(
                  icon: Icons.computer,
                  title: 'Digital',
                  subtitle: '100+ Programs',
                  color: AppColors.digital,
                  onTap: () {
                    context.go('${AppRoutes.programs}?category=digital');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: Row(
                children: [
                  Text(
                    AppStrings.viewAll,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildJobsList(List<Job> jobs) {
    if (jobs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text('No featured jobs available'),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: index < jobs.length - 1 ? 12 : 0),
            child: JobCard(
              job: jobs[index],
              onTap: () => context.push('/jobs/${jobs[index].id}'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgramsList(List<Program> programs) {
    if (programs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text('No featured programs available'),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: programs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: index < programs.length - 1 ? 12 : 0),
            child: ProgramCard(
              program: programs[index],
              onTap: () => context.push('/programs/${programs[index].id}'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWhyEvnora() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why Choose Evnora?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildBenefitRow(Icons.verified, 'ISO Certified Programs'),
          _buildBenefitRow(Icons.school, '100% Job Assistance'),
          _buildBenefitRow(Icons.money_off, 'Zero Registration Fee'),
          _buildBenefitRow(Icons.support_agent, 'Top Industry Trainers'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go(AppRoutes.programs),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Explore Programs',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 8),
            Text(
              'Failed to load data',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// Loading Shimmers
class _JobsLoadingShimmer extends StatelessWidget {
  const _JobsLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }
}

class _ProgramsLoadingShimmer extends StatelessWidget {
  const _ProgramsLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }
}
