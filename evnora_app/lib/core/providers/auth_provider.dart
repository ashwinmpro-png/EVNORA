import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../../config/constants.dart';

// Auth state
class AuthState {
  final User? user;
  final bool isAuthenticated;
  final bool isLoading;
  final bool isOnboardingComplete;
  final String? error;

  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.isOnboardingComplete = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    bool? isLoading,
    bool? isOnboardingComplete,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      error: error,
    );
  }
}

// Auth state notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;

  AuthStateNotifier(this._apiService) : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final token = await StorageService.getAccessToken();
      final user = StorageService.getUser();
      final onboardingComplete = StorageService.isOnboardingComplete();

      if (token != null && user != null) {
        state = AuthState(
          user: user,
          isAuthenticated: true,
          isOnboardingComplete: onboardingComplete,
        );
      } else {
        state = AuthState(
          isOnboardingComplete: onboardingComplete,
        );
      }
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  // Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.post(
        AppConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['access_token'];
        final refreshToken = data['refresh_token'];
        final userData = data['user'];

        await StorageService.saveTokens(accessToken, refreshToken);
        
        final user = User.fromJson(userData);
        await StorageService.saveUser(user);

        state = AuthState(
          user: user,
          isAuthenticated: true,
          isOnboardingComplete: user.isProfileComplete,
        );

        return true;
      }
      
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed. Please try again.',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Signup
  Future<bool> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String userType,
    String? candidateType,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.post(
        AppConstants.signupEndpoint,
        data: {
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'password': password,
          'user_type': userType,
          if (candidateType != null) 'candidate_type': candidateType,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        final accessToken = data['access_token'];
        final refreshToken = data['refresh_token'];
        final userData = data['user'];

        await StorageService.saveTokens(accessToken, refreshToken);
        
        final user = User.fromJson(userData);
        await StorageService.saveUser(user);

        state = AuthState(
          user: user,
          isAuthenticated: true,
          isOnboardingComplete: false,
        );

        return true;
      }
      
      state = state.copyWith(
        isLoading: false,
        error: response.data?['message'] ?? 'Signup failed. Please try again.',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Forgot password
  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.post(
        AppConstants.forgotPasswordEndpoint,
        data: {'email': email},
      );

      state = state.copyWith(isLoading: false);
      return response.statusCode == 200;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword({
    required String token,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.post(
        AppConstants.resetPasswordEndpoint,
        data: {
          'token': token,
          'password': password,
        },
      );

      state = state.copyWith(isLoading: false);
      return response.statusCode == 200;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.put(
        AppConstants.updateProfileEndpoint,
        data: data,
      );

      if (response.statusCode == 200) {
        final userData = response.data['user'];
        final user = User.fromJson(userData);
        await StorageService.saveUser(user);

        state = state.copyWith(
          user: user,
          isLoading: false,
          isOnboardingComplete: user.isProfileComplete,
        );

        if (user.isProfileComplete) {
          await StorageService.setOnboardingComplete(true);
        }

        return true;
      }
      
      state = state.copyWith(
        isLoading: false,
        error: 'Update failed. Please try again.',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Upload resume
  Future<String?> uploadResume({
    required String filePath,
    required String fileName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.uploadFile(
        AppConstants.uploadResumeEndpoint,
        filePath: filePath,
        fileName: fileName,
        fieldName: 'resume',
      );

      if (response.statusCode == 200) {
        final resumeUrl = response.data['resume_url'];
        
        // Update user with new resume URL
        final updatedUser = state.user?.copyWith(resumeUrl: resumeUrl);
        if (updatedUser != null) {
          await StorageService.saveUser(updatedUser);
          state = state.copyWith(
            user: updatedUser,
            isLoading: false,
          );
        }

        return resumeUrl;
      }
      
      state = state.copyWith(
        isLoading: false,
        error: 'Upload failed. Please try again.',
      );
      return null;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  // Complete onboarding
  Future<void> completeOnboarding() async {
    await StorageService.setOnboardingComplete(true);
    state = state.copyWith(isOnboardingComplete: true);
  }

  // Refresh user data
  Future<void> refreshUser() async {
    if (!state.isAuthenticated) return;

    try {
      final response = await _apiService.get(AppConstants.profileEndpoint);

      if (response.statusCode == 200) {
        final userData = response.data['user'];
        final user = User.fromJson(userData);
        await StorageService.saveUser(user);

        state = state.copyWith(user: user);
      }
    } catch (e) {
      print('Error refreshing user: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _apiService.post(AppConstants.logoutEndpoint);
    } catch (e) {
      // Ignore logout API errors
    }

    await StorageService.clearTokens();
    await StorageService.clearUser();
    await StorageService.clearCache();

    state = const AuthState(
      isOnboardingComplete: true, // Keep onboarding state
    );
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthStateNotifier(apiService);
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).error;
});
