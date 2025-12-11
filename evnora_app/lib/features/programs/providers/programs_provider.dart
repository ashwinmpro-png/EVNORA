import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/constants.dart';
import '../../../core/models/program.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';

// Featured programs provider
final featuredProgramsProvider = FutureProvider<List<Program>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final response = await apiService.get(
      AppConstants.programsEndpoint,
      queryParameters: {
        'featured': true,
        'limit': 10,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['programs'];
      final programs = data.map((p) => Program.fromJson(p)).toList();
      
      // Cache the programs
      await StorageService.cachePrograms(programs, key: 'featured_programs');
      
      return programs;
    }
    
    // Return cached data if available
    return StorageService.getCachedPrograms(key: 'featured_programs') ?? [];
  } catch (e) {
    // Return cached data on error
    final cached = StorageService.getCachedPrograms(key: 'featured_programs');
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    rethrow;
  }
});

// All programs provider with filter
final programsProvider = FutureProvider.family<List<Program>, ProgramFilter?>((ref, filter) async {
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final queryParams = filter?.toQueryParameters() ?? {};
    queryParams['limit'] = AppConstants.defaultPageSize;

    final response = await apiService.get(
      AppConstants.programsEndpoint,
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['programs'];
      return data.map((p) => Program.fromJson(p)).toList();
    }
    
    return [];
  } catch (e) {
    rethrow;
  }
});

// Programs by category
final programsByCategoryProvider = FutureProvider.family<List<Program>, String>((ref, category) async {
  final filter = ProgramFilter(category: category);
  return ref.watch(programsProvider(filter).future);
});

// Single program provider
final programDetailsProvider = FutureProvider.family<Program?, String>((ref, programId) async {
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final response = await apiService.get('${AppConstants.programsEndpoint}/$programId');

    if (response.statusCode == 200) {
      return Program.fromJson(response.data['program']);
    }
    
    return null;
  } catch (e) {
    rethrow;
  }
});

// Enrolled programs provider
final enrolledProgramsProvider = FutureProvider<List<ProgramEnrollment>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final response = await apiService.get('${AppConstants.programsEndpoint}/enrolled');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['enrollments'];
      return data.map((e) => ProgramEnrollment.fromJson(e)).toList();
    }
    
    return [];
  } catch (e) {
    rethrow;
  }
});

// Program filter state
final programFilterProvider = StateProvider<ProgramFilter>((ref) {
  return const ProgramFilter();
});

// Program categories
final programCategoriesProvider = Provider<List<ProgramCategory>>((ref) {
  return [
    ProgramCategory(
      id: 'blue_collar',
      name: 'Blue Collar Programs',
      description: 'Technical skills for industrial jobs',
      icon: 'construction',
      color: 0xFF2563EB,
    ),
    ProgramCategory(
      id: 'white_collar',
      name: 'White Collar Programs',
      description: 'Professional and management skills',
      icon: 'business_center',
      color: 0xFF7C3AED,
    ),
    ProgramCategory(
      id: 'digital_soft_skills',
      name: 'Digital + Soft Skills',
      description: 'Digital literacy and interpersonal skills',
      icon: 'computer',
      color: 0xFF059669,
    ),
    ProgramCategory(
      id: 'hse',
      name: 'HSE Programs',
      description: 'Health, Safety, and Environment',
      icon: 'health_and_safety',
      color: 0xFFDC2626,
    ),
  ];
});

// Enroll in program
final enrollProgramProvider = FutureProvider.family<Map<String, dynamic>?, Map<String, dynamic>>((ref, data) async {
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final response = await apiService.post(
      AppConstants.enrollProgramEndpoint,
      data: data,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    }
    
    return null;
  } catch (e) {
    rethrow;
  }
});

// Search programs
final searchProgramsProvider = FutureProvider.family<List<Program>, String>((ref, query) async {
  if (query.isEmpty) return [];
  
  final apiService = ref.watch(apiServiceProvider);
  
  try {
    final response = await apiService.get(
      AppConstants.programsEndpoint,
      queryParameters: {'q': query, 'limit': 20},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['programs'];
      return data.map((p) => Program.fromJson(p)).toList();
    }
    
    return [];
  } catch (e) {
    rethrow;
  }
});

// Program category model
class ProgramCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int color;

  ProgramCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}
