import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // API Configuration
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'https://api.evnora.com/v1';
  static String get websiteUrl => 'https://www.evnora.com';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  static const String profileEndpoint = '/user/profile';
  static const String updateProfileEndpoint = '/user/profile/update';
  static const String uploadResumeEndpoint = '/user/resume/upload';
  static const String jobsEndpoint = '/jobs';
  static const String programsEndpoint = '/programs';
  static const String certificatesEndpoint = '/certificates';
  static const String companiesEndpoint = '/companies';
  static const String countriesEndpoint = '/countries';
  static const String applyJobEndpoint = '/jobs/apply';
  static const String enrollProgramEndpoint = '/programs/enroll';
  static const String paymentEndpoint = '/payments';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String savedJobsKey = 'saved_jobs';
  static const String recentSearchesKey = 'recent_searches';
  static const String notificationsEnabledKey = 'notifications_enabled';
  static const String locationEnabledKey = 'location_enabled';
  
  // Hive Box Names
  static const String userBox = 'user_box';
  static const String jobsBox = 'jobs_box';
  static const String programsBox = 'programs_box';
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';
  
  // Razorpay Configuration
  static String get razorpayKey => dotenv.env['RAZORPAY_KEY'] ?? '';
  
  // LinkedIn OAuth
  static String get linkedInClientId => dotenv.env['LINKEDIN_CLIENT_ID'] ?? '';
  static String get linkedInClientSecret => dotenv.env['LINKEDIN_CLIENT_SECRET'] ?? '';
  static String get linkedInRedirectUrl => dotenv.env['LINKEDIN_REDIRECT_URL'] ?? '';
  
  // Firebase Configuration
  static const String notificationChannelId = 'evnora_notifications';
  static const String notificationChannelName = 'Evnora Notifications';
  static const String notificationChannelDesc = 'Notifications from Evnora app';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Cache Durations
  static const Duration jobsCacheDuration = Duration(minutes: 15);
  static const Duration programsCacheDuration = Duration(hours: 1);
  static const Duration profileCacheDuration = Duration(minutes: 30);
  
  // File Upload
  static const int maxResumeSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedResumeFormats = ['pdf', 'doc', 'docx'];
  static const int maxProfileImageSize = 2 * 1024 * 1024; // 2MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png'];
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int phoneNumberLength = 10;
  
  // Job Types
  static const String blueCollar = 'blue_collar';
  static const String whiteCollar = 'white_collar';
  static const String hse = 'hse';
  static const String digital = 'digital_soft_skills';
  
  // Employment Types
  static const String fullTime = 'full_time';
  static const String partTime = 'part_time';
  static const String contract = 'contract';
  static const String internship = 'internship';
  
  // App Info
  static const String appName = 'Evnora';
  static const String appVersion = '1.0.0';
  static const String companyName = 'Evnora Pvt. Ltd.';
  static const String companyAddress = '1501, Ambience Court, Vashi, Navi Mumbai – 400703, Maharashtra, India';
  static const String supportEmail = 'support@evnora.com';
  static const String supportPhone = '+91 913631 8400';
  
  // Social Links
  static const String linkedInUrl = 'https://www.linkedin.com/company/evnora';
  static const String twitterUrl = 'https://twitter.com/evnora';
  static const String facebookUrl = 'https://www.facebook.com/evnora';
  static const String instagramUrl = 'https://www.instagram.com/evnora';
  
  // Legal
  static const String privacyPolicyUrl = 'https://www.evnora.com/privacy-policy';
  static const String termsOfServiceUrl = 'https://www.evnora.com/terms-of-service';
  static const String refundPolicyUrl = 'https://www.evnora.com/refund-policy';
}

class AppStrings {
  // General
  static const String appTitle = 'Evnora';
  static const String tagline = 'Empowering People, Enabling Progress';
  
  // Auth
  static const String login = 'Login';
  static const String signup = 'Sign Up';
  static const String logout = 'Logout';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String mobileNumber = 'Mobile Number';
  static const String designation = 'Designation';
  static const String rememberMe = 'Remember me';
  static const String orContinueWith = 'Or continue with';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signInWithLinkedIn = 'Sign in with LinkedIn';
  static const String signUpWithLinkedIn = 'Sign up with LinkedIn';
  
  // Navigation
  static const String home = 'Home';
  static const String jobs = 'Jobs';
  static const String programs = 'Programs';
  static const String profile = 'Profile';
  static const String certificates = 'Certificates';
  
  // Jobs
  static const String allJobs = 'All Jobs';
  static const String blueCollarJobs = 'Blue Collar Jobs';
  static const String whiteCollarJobs = 'White Collar Jobs';
  static const String jobsByCompany = 'Jobs by Company';
  static const String jobsByCountry = 'Jobs by Country';
  static const String applyNow = 'Apply Now';
  static const String saveJob = 'Save Job';
  static const String savedJobs = 'Saved Jobs';
  static const String appliedJobs = 'Applied Jobs';
  static const String jobDetails = 'Job Details';
  static const String requirements = 'Requirements';
  static const String responsibilities = 'Responsibilities';
  static const String skills = 'Skills';
  static const String experience = 'Experience';
  static const String salary = 'Salary';
  static const String location = 'Location';
  static const String jobType = 'Job Type';
  
  // Programs
  static const String allPrograms = 'All Programs';
  static const String blueCollarPrograms = 'Blue Collar Programs';
  static const String whiteCollarPrograms = 'White Collar Programs';
  static const String digitalSoftSkills = 'Digital + Soft Skills';
  static const String hsePrograms = 'HSE Programs';
  static const String enrollNow = 'Enroll Now';
  static const String programDetails = 'Program Details';
  static const String duration = 'Duration';
  static const String curriculum = 'Curriculum';
  static const String certification = 'Certification';
  static const String enrolledPrograms = 'Enrolled Programs';
  static const String completedPrograms = 'Completed Programs';
  
  // Profile
  static const String editProfile = 'Edit Profile';
  static const String myResume = 'My Resume';
  static const String uploadResume = 'Upload Resume';
  static const String buildResume = 'Build Resume';
  static const String mySkills = 'My Skills';
  static const String myCertificates = 'My Certificates';
  static const String workExperience = 'Work Experience';
  static const String education = 'Education';
  static const String settings = 'Settings';
  static const String notifications = 'Notifications';
  static const String privacy = 'Privacy';
  static const String help = 'Help & Support';
  static const String about = 'About';
  
  // Actions
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String clear = 'Clear';
  static const String apply = 'Apply';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String submit = 'Submit';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String skip = 'Skip';
  static const String done = 'Done';
  static const String retry = 'Retry';
  static const String viewAll = 'View All';
  static const String seeMore = 'See More';
  static const String readMore = 'Read More';
  
  // Messages
  static const String loading = 'Loading...';
  static const String noDataFound = 'No data found';
  static const String noJobsFound = 'No jobs found';
  static const String noProgramsFound = 'No programs found';
  static const String noCertificatesFound = 'No certificates found';
  static const String errorOccurred = 'An error occurred';
  static const String checkConnection = 'Please check your internet connection';
  static const String tryAgain = 'Please try again';
  static const String sessionExpired = 'Session expired. Please login again.';
  static const String successfullyApplied = 'Successfully applied!';
  static const String successfullyEnrolled = 'Successfully enrolled!';
  static const String profileUpdated = 'Profile updated successfully';
  static const String resumeUploaded = 'Resume uploaded successfully';
}
