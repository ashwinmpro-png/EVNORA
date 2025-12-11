import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/constants.dart';
import '../../../core/models/job.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';

// Featured jobs provider
final featuredJobsProvider = FutureProvider<List<Job>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final response = await apiService.get(
      AppConstants.jobsEndpoint,
      queryParameters: {
        'featured': true,
        'limit': 10,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['jobs'];
      final jobs = data.map((j) => Job.fromJson(j)).toList();
      
      // Cache the jobs
      await StorageService.cacheJobs(jobs, key: 'featured_jobs');
      
      return jobs;
    }
    
    // Return cached data if available
    return StorageService.getCachedJobs(key: 'featured_jobs') ?? [];
  } catch (e) {
    // Return cached data on error
    final cached = StorageService.getCachedJobs(key: 'featured_jobs');
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    rethrow;
  }
});

// All jobs provider with filter
final jobsProvider = FutureProvider.family<List<Job>, JobFilter?>((ref, filter) async {
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final queryParams = filter?.toQueryParameters() ?? {};
    queryParams['limit'] = AppConstants.defaultPageSize;

    final response = await apiService.get(
      AppConstants.jobsEndpoint,
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['jobs'];
      return data.map((j) => Job.fromJson(j)).toList();
    }
    
    return [];
  } catch (e) {
    rethrow;
  }
});

// Single job provider
final jobDetailsProvider = FutureProvider.family<Job?, String>((ref, jobId) async {
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final response = await apiService.get('${AppConstants.jobsEndpoint}/$jobId');

    if (response.statusCode == 200) {
      return Job.fromJson(response.data['job']);
    }
    
    return null;
  } catch (e) {
    rethrow;
  }
});

// Saved jobs provider
final savedJobsProvider = StateNotifierProvider<SavedJobsNotifier, List<Job>>((ref) {
  return SavedJobsNotifier();
});

class SavedJobsNotifier extends StateNotifier<List<Job>> {
  SavedJobsNotifier() : super(StorageService.getSavedJobs());

  void saveJob(Job job) {
    StorageService.saveJob(job);
    state = [...state, job];
  }

  void removeJob(String jobId) {
    StorageService.removeSavedJob(jobId);
    state = state.where((j) => j.id != jobId).toList();
  }

  bool isJobSaved(String jobId) {
    return state.any((j) => j.id == jobId);
  }
}

// Applied jobs provider
final appliedJobsProvider = FutureProvider<List<JobApplication>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final response = await apiService.get('${AppConstants.jobsEndpoint}/applied');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['applications'];
      return data.map((a) => JobApplication.fromJson(a)).toList();
    }
    
    return [];
  } catch (e) {
    rethrow;
  }
});

// Job filter state
final jobFilterProvider = StateProvider<JobFilter>((ref) {
  return const JobFilter();
});

// Countries list provider
final countriesProvider = FutureProvider<List<String>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final response = await apiService.get(AppConstants.countriesEndpoint);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['countries'];
      return data.cast<String>();
    }
    
    return [];
  } catch (e) {
    return ['India', 'UAE', 'Saudi Arabia', 'Qatar', 'Oman', 'Kuwait', 'Singapore'];
  }
});

// Companies list provider
final companiesProvider = FutureProvider<List<Company>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final response = await apiService.get(AppConstants.companiesEndpoint);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['companies'];
      return data.map((c) => Company.fromJson(c)).toList();
    }
    
    return [];
  } catch (e) {
    rethrow;
  }
});

// Apply to job
final applyJobProvider = FutureProvider.family<bool, Map<String, dynamic>>((ref, data) async {
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final response = await apiService.post(
      AppConstants.applyJobEndpoint,
      data: data,
    );

    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) {
    rethrow;
  }
});

// Search jobs
final searchJobsProvider = FutureProvider.family<List<Job>, String>((ref, query) async {
  if (query.isEmpty) return [];
  
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final response = await apiService.get(
      AppConstants.jobsEndpoint,
      queryParameters: {'q': query, 'limit': 20},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['jobs'];
      return data.map((j) => Job.fromJson(j)).toList();
    }
    
    return [];
  } catch (e) {
    rethrow;
  }
});
