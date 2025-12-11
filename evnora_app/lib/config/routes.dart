import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/home/screens/main_navigation_screen.dart';
import '../features/jobs/screens/jobs_screen.dart';
import '../features/jobs/screens/job_details_screen.dart';
import '../features/jobs/screens/jobs_by_company_screen.dart';
import '../features/jobs/screens/jobs_by_country_screen.dart';
import '../features/programs/screens/programs_screen.dart';
import '../features/programs/screens/program_details_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/resume_builder_screen.dart';
import '../features/certificates/screens/certificates_screen.dart';
import '../core/providers/auth_provider.dart';
import '../shared/widgets/splash_screen.dart';

// Route names
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String main = '/main';
  static const String home = '/home';
  static const String jobs = '/jobs';
  static const String jobDetails = '/jobs/:jobId';
  static const String jobsByCompany = '/jobs/company';
  static const String jobsByCountry = '/jobs/country';
  static const String programs = '/programs';
  static const String programDetails = '/programs/:programId';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String resumeBuilder = '/profile/resume-builder';
  static const String certificates = '/certificates';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isOnboardingComplete = authState.isOnboardingComplete;
      final currentPath = state.matchedLocation;
      
      // Auth routes that don't require authentication
      final authRoutes = [
        AppRoutes.splash,
        AppRoutes.onboarding,
        AppRoutes.login,
        AppRoutes.signup,
        AppRoutes.forgotPassword,
      ];
      
      final isAuthRoute = authRoutes.contains(currentPath);
      
      // If at splash, let it handle navigation
      if (currentPath == AppRoutes.splash) {
        return null;
      }
      
      // If not authenticated and trying to access protected route
      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }
      
      // If authenticated but onboarding not complete
      if (isAuthenticated && !isOnboardingComplete && currentPath != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }
      
      // If authenticated and trying to access auth route
      if (isAuthenticated && isOnboardingComplete && isAuthRoute) {
        return AppRoutes.main;
      }
      
      return null;
    },
    
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      
      // Main Navigation Shell
      ShellRoute(
        builder: (context, state, child) => MainNavigationScreen(child: child),
        routes: [
          // Home
          GoRoute(
            path: AppRoutes.main,
            name: 'main',
            builder: (context, state) => const HomeScreen(),
          ),
          
          // Jobs
          GoRoute(
            path: AppRoutes.jobs,
            name: 'jobs',
            builder: (context, state) => const JobsScreen(),
            routes: [
              GoRoute(
                path: 'company',
                name: 'jobsByCompany',
                builder: (context, state) => const JobsByCompanyScreen(),
              ),
              GoRoute(
                path: 'country',
                name: 'jobsByCountry',
                builder: (context, state) => const JobsByCountryScreen(),
              ),
            ],
          ),
          
          // Programs
          GoRoute(
            path: AppRoutes.programs,
            name: 'programs',
            builder: (context, state) => const ProgramsScreen(),
          ),
          
          // Profile
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'editProfile',
                builder: (context, state) => const EditProfileScreen(),
              ),
              GoRoute(
                path: 'resume-builder',
                name: 'resumeBuilder',
                builder: (context, state) => const ResumeBuilderScreen(),
              ),
            ],
          ),
          
          // Certificates
          GoRoute(
            path: AppRoutes.certificates,
            name: 'certificates',
            builder: (context, state) => const CertificatesScreen(),
          ),
        ],
      ),
      
      // Job Details (outside shell for full screen)
      GoRoute(
        path: '/jobs/:jobId',
        name: 'jobDetails',
        builder: (context, state) {
          final jobId = state.pathParameters['jobId']!;
          return JobDetailsScreen(jobId: jobId);
        },
      ),
      
      // Program Details
      GoRoute(
        path: '/programs/:programId',
        name: 'programDetails',
        builder: (context, state) {
          final programId = state.pathParameters['programId']!;
          return ProgramDetailsScreen(programId: programId);
        },
      ),
    ],
    
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.matchedLocation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.main),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
