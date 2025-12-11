# Evnora - Flutter Mobile App

A native Flutter application for Evnora, a workforce development and job portal platform. This app enables job seekers to find employment opportunities, enroll in training programs, and get certified.

## 📱 Features

### For Job Seekers
- **Job Search & Discovery**
  - Browse jobs by company, country, and category
  - Filter by Blue Collar, White Collar, and HSE jobs
  - Save and apply to jobs with one click
  - Receive job notifications based on preferences

- **Training Programs**
  - Explore Blue Collar, White Collar, Digital + Soft Skills, and HSE programs
  - Enroll and pay for courses
  - Track program progress
  - Earn certifications

- **Profile Management**
  - Build ATS-friendly resume
  - Upload existing resume
  - Add skills and work experience
  - Manage certifications

- **Certificate Verification**
  - View earned certificates
  - Share certificates with employers
  - Verify certificate authenticity

### Platform Features
- **Push Notifications** - Firebase Cloud Messaging
- **Location Services** - Find nearby jobs and training centers
- **Offline Mode** - Cache jobs and programs for offline viewing
- **Payment Integration** - Razorpay for course payments
- **Authentication** - Email/Password + LinkedIn OAuth

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # Main app widget
├── config/
│   ├── constants.dart           # App constants & API endpoints
│   ├── routes.dart              # Navigation routes (GoRouter)
│   └── themes.dart              # App theme configuration
├── core/
│   ├── models/
│   │   ├── user.dart            # User model
│   │   ├── job.dart             # Job & Company models
│   │   ├── program.dart         # Program & Enrollment models
│   │   └── certificate.dart     # Certificate model
│   ├── services/
│   │   ├── api_service.dart     # HTTP client (Dio)
│   │   ├── storage_service.dart # Local storage (Hive)
│   │   ├── notification_service.dart # Push notifications
│   │   ├── location_service.dart    # Geolocation
│   │   └── payment_service.dart     # Razorpay integration
│   ├── providers/
│   │   └── auth_provider.dart   # Authentication state
│   └── utils/                   # Helper utilities
├── features/
│   ├── auth/
│   │   └── screens/
│   │       ├── login_screen.dart
│   │       ├── signup_screen.dart
│   │       ├── forgot_password_screen.dart
│   │       └── onboarding_screen.dart
│   ├── home/
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   └── main_navigation_screen.dart
│   │   └── widgets/
│   ├── jobs/
│   │   ├── screens/
│   │   │   ├── jobs_screen.dart
│   │   │   ├── job_details_screen.dart
│   │   │   ├── jobs_by_company_screen.dart
│   │   │   └── jobs_by_country_screen.dart
│   │   └── providers/
│   │       └── jobs_provider.dart
│   ├── programs/
│   │   ├── screens/
│   │   │   ├── programs_screen.dart
│   │   │   └── program_details_screen.dart
│   │   └── providers/
│   │       └── programs_provider.dart
│   ├── profile/
│   │   └── screens/
│   │       ├── profile_screen.dart
│   │       ├── edit_profile_screen.dart
│   │       └── resume_builder_screen.dart
│   └── certificates/
│       └── screens/
│           └── certificates_screen.dart
└── shared/
    └── widgets/
        ├── custom_button.dart
        ├── custom_text_field.dart
        └── splash_screen.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android Studio / Xcode
- Firebase account
- Razorpay account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/evnora/evnora-app.git
   cd evnora-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

4. **Firebase Setup**
   - Create a Firebase project
   - Download `google-services.json` (Android) → `android/app/`
   - Download `GoogleService-Info.plist` (iOS) → `ios/Runner/`
   - Enable Cloud Messaging

5. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Android Setup
Add to `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### iOS Setup
Add to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to upload your profile photo</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to upload your resume and profile photo</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby jobs</string>
```

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `go_router` | Navigation |
| `dio` | HTTP client |
| `hive_flutter` | Local storage |
| `firebase_messaging` | Push notifications |
| `razorpay_flutter` | Payment gateway |
| `geolocator` | Location services |
| `image_picker` | Camera/Gallery access |
| `cached_network_image` | Image caching |

## 🎨 Design System

### Colors
- **Primary**: `#1E3A5F` (Dark Blue)
- **Secondary**: `#FF6B35` (Orange)
- **Accent**: `#00D4AA` (Teal)
- **Success**: `#10B981`
- **Warning**: `#F59E0B`
- **Error**: `#EF4444`

### Typography
- Font Family: **Poppins**
- Heading sizes: 32px, 28px, 24px, 22px, 20px, 18px
- Body sizes: 16px, 14px, 12px

## 📱 App Screens

| Screen | Route | Description |
|--------|-------|-------------|
| Splash | `/` | App launch screen |
| Login | `/login` | User authentication |
| Signup | `/signup` | New user registration |
| Home | `/main` | Main dashboard |
| Jobs | `/jobs` | Job listings |
| Job Details | `/jobs/:id` | Individual job view |
| Programs | `/programs` | Training courses |
| Profile | `/profile` | User profile |
| Certificates | `/certificates` | User certifications |

## 🔐 Authentication Flow

```
Splash Screen
    ↓
Check Token
    ↓
┌─────────────────┐
│   Has Token?    │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
   Yes        No
    │         │
    ↓         ↓
Main App    Login
```

## 💳 Payment Flow

1. User selects program → Create Order API
2. Receive Razorpay Order ID
3. Open Razorpay Checkout
4. User completes payment
5. Verify payment signature
6. Update enrollment status

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

## 📦 Building for Release

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🚀 Deployment

### Google Play Store
1. Build signed AAB
2. Upload to Play Console
3. Complete store listing
4. Submit for review

### Apple App Store
1. Build for release
2. Archive in Xcode
3. Upload to App Store Connect
4. Complete metadata
5. Submit for review

## 📝 API Documentation

The app connects to Evnora's REST API. Key endpoints:

- `POST /auth/login` - User login
- `POST /auth/signup` - User registration
- `GET /jobs` - List jobs
- `GET /programs` - List programs
- `POST /payments` - Create payment order
- `GET /certificates` - User certificates

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open Pull Request

## 📄 License

This project is proprietary software owned by Evnora Pvt. Ltd.

## 📞 Support

- Email: support@evnora.com
- Phone: +91 913631 8400
- Website: https://www.evnora.com

---

Built with ❤️ by Evnora Team
