```markdown
# mobile_dev.md — Iranian Dating App Flutter (Badoo-style)

> **Purpose:** Single source of truth for the entire mobile project.  
> Updated at the end of every session. Pass this file to Claude at the start of every new session.  
> Claude must read this file fully before taking any action.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Current Status](#2-current-status)
3. [Tech Stack](#3-tech-stack)
4. [Project Structure](#4-project-structure)
5. [Environment & Configuration](#5-environment--configuration)
6. [Completed Features](#6-completed-features)
7. [TODO - Next Session](#7-todo---next-session)
8. [UI Mockups](#8-ui-mockups-badoo-inspired)

---

## 1. Project Overview

A **Flutter mobile app** for the Iranian dating app, inspired by Badoo design.

| Attribute | Detail |
|-----------|--------|
| Language | Dart |
| Target platform | Android first, iOS later |
| Design style | Minimal, clean, Badoo-inspired |
| Animations | Smooth, 60fps |
| Monetization | Premium subscriptions + rewarded ads |

---

## 2. Current Status

| Item | Status |
|------|--------|
| **Session 16-17** | ✅ COMPLETED |
| Flutter project setup | ✅ |
| Dependencies installed | ✅ |
| Folder structure created | ✅ |
| Environment variables (.env) | ✅ |
| API Service (Dio) with interceptors | ✅ |
| Auth Service (login, register, healthCheck) | ✅ |
| Storage Service (secure token storage) | ✅ |
| Auth Provider (state management) | ✅ |
| Onboarding Provider | ✅ |
| Language Provider | ✅ |
| App Theme (Light/Dark mode ready) | ✅ |
| Splash Screen (with progress bar & random target) | ✅ |
| Welcome Screen (enhanced) | ✅ |
| Login Screen (with validation) | ✅ |
| Email & Password validation | ✅ |
| Password visibility toggle | ✅ |
| Language selection (English/Persian) | ✅ |
| Google Sign-In button with custom icon | ✅ |
| Input filtering (English only) | ✅ |
| Real-time validation with localized errors | ✅ |
| Password min length: 8 characters | ✅ |
| Health Check on Splash | ✅ |
| Retry button on connection error | ✅ |
| Token refresh interceptor | ✅ |

---

## 3. Tech Stack

| Category | Package | Version | Purpose |
|----------|---------|---------|---------|
| **Core** | flutter | 3.x | UI framework |
| **Networking** | dio | ^5.3.0 | HTTP requests |
| **WebSocket** | web_socket_channel | ^2.4.0 | Real-time chat |
| **State Management** | provider | ^6.0.5 | Simple and effective |
| **Storage** | shared_preferences | ^2.2.0 | User preferences |
| **Secure Storage** | flutter_secure_storage | ^9.0.0 | Token storage |
| **Image** | image_picker | ^1.0.4 | Select photos |
| **Image Cache** | cached_network_image | ^3.3.0 | Profile images |
| **Design** | google_fonts | ^6.1.0 | Custom fonts |
| **Animations** | flutter_staggered_animations | ^1.1.0 | Smooth animations |
| **Env** | flutter_dotenv | ^5.1.0 | Environment variables |

---

## 4. Project Structure

```
lib/
├── main.dart
├── config/
│   ├── app_constants.dart       # API URLs, keys
│   └── app_theme.dart           # Theme configuration (Light/Dark)
├── models/
│   └── user.dart                # User model
├── services/
│   ├── api_service.dart         # Dio HTTP client + interceptors
│   ├── auth_service.dart        # Login, register, healthCheck
│   └── storage_service.dart     # Token storage
├── providers/
│   ├── auth_provider.dart       # Auth state management
│   ├── language_provider.dart   # Language selection
│   └── onboarding_provider.dart # Onboarding data + API submit
├── screens/
│   ├── splash_screen.dart       # Splash with progress & health check
│   ├── welcome_screen.dart      # Welcome screen (enhanced)
│   ├── login_screen.dart        # Login screen
│   ├── main_screen.dart         # Main screen (bottom nav) - PLACEHOLDER
│   └── onboarding/
│       ├── email_password_screen.dart   # Step 0: Email & Password
│       ├── name_age_screen.dart         # Step 1: Name, Age, Gender
│       ├── height_weight_screen.dart    # Step 2: Height, Weight
│       ├── photo_screen.dart            # Step 3: Photos (skip)
│       └── location_screen.dart         # Step 4: Location & Submit
├── widgets/
│   ├── loading_widget.dart      # Loading indicator
│   └── progress_bar.dart        # Onboarding progress bar
├── l10n/
│   ├── app_en.arb               # English translations
│   └── app_fa.arb               # Persian translations
├── generated/
│   ├── app_localizations.dart   # Generated localization
│   ├── app_localizations_en.dart
│   └── app_localizations_fa.dart
└── utils/
    └── validators.dart          # Form validators
```

---

## 5. Environment & Configuration

### `.env` file (root directory)

```env
API_BASE_URL=http://10.0.2.2:8000/api/v1
WS_BASE_URL=ws://10.0.2.2:8000/api/v1
```

> **Note:** `10.0.2.2` is for Android emulator. For physical device, use your computer's IP.

### `.env.example` (commit to git)

```env
API_BASE_URL=http://localhost:8000/api/v1
WS_BASE_URL=ws://localhost:8000/api/v1
```

### `pubspec.yaml` assets

```yaml
flutter:
  assets:
    - .env
    - assets/images/google_logo.png
```

### App Constants

```dart
// lib/config/app_constants.dart
class AppConstants {
  static const String apiBaseUrl = 'http://10.0.2.2:8000/api/v1';
  static const int connectTimeout = 10;
  static const int receiveTimeout = 10;
}
```

---

## 6. Completed Features

### App Theme System

| Feature | Description |
|---------|-------------|
| Light Theme | Clean, minimal with navy primary |
| Dark Theme | Ready for dark mode support |
| Color System | Centralized in AppTheme class |
| Text Styles | Consistent typography with Inter font |
| Button Styles | Primary, outline, small variants |
| Input Decoration | Consistent form field styling |
| Extension | `context.primaryColor`, `context.isDarkMode` |

### Splash Screen

| Feature | Description |
|---------|-------------|
| Progress Bar | Animated from 0 to 100% |
| Random Target | Each run targets 50-99% before health check |
| Health Check | GET /health to verify server connection |
| Error State | Shows wifi icon + retry button on failure |
| Auto-Navigation | Goes to MainScreen if authenticated, else WelcomeScreen |
| Theme Aware | Uses AppTheme colors (Light/Dark ready) |

### Auth Flow

| Feature | Description |
|---------|-------------|
| Login | Email + password validation |
| Register | Complete profile with email, password, name, age, gender |
| Token Storage | Secure storage with flutter_secure_storage |
| Token Refresh | Automatic on 401 response via interceptor |
| Health Check | Separate Dio instance without /api/v1 prefix |
| Error Handling | Localized error messages |

### API Service Features

| Feature | Description |
|---------|-------------|
| Base URL | From AppConstants.apiBaseUrl |
| Interceptors | Auto token injection + refresh on 401 |
| Health Check | Separate baseUrl without /api/v1 prefix |
| Logging | Request/Response logging in debug mode |

### Login Screen

| Feature | Description |
|---------|-------------|
| Form Validation | Email format + password length (min 8) |
| Password Visibility | Toggle show/hide |
| Loading State | Disabled button with spinner |
| Error Handling | SnackBar with error message |
| Navigation | Back to Welcome, forward to MainScreen |
| Theme Aware | Uses AppTheme colors |

---

## 7. TODO - Next Session

### Session 18: Onboarding Flow

| Task | Priority | Description |
|------|----------|-------------|
| EmailPasswordScreen | 🔴 High | Step 0: Email & Password (connect to API) |
| NameAgeScreen | 🔴 High | Step 1: Name, Age, Gender |
| HeightWeightScreen | 🟡 Medium | Step 2: Height, Weight |
| PhotoScreen | 🟡 Medium | Step 3: Photos (skip option) |
| LocationScreen | 🟡 Medium | Step 4: Location & Submit |
| OnboardingProvider | 🔴 High | State management for all steps |
| Registration API | 🔴 High | Connect to backend POST /auth/register |

### Session 19: Main App Features

| Task | Priority | Description |
|------|----------|-------------|
| Discover Screen | 🔴 High | Swipeable profile cards |
| Search Screen | 🟡 Medium | Search with filters |
| Profile Screen | 🟡 Medium | View and edit profile |
| Chats Screen | 🟡 Medium | Messages list |
| Chat Detail | 🟡 Medium | Real-time messaging |
| Likes Tab | 🟢 Low | Likes sent/received |

### Session 20: Polish & Production

| Task | Priority | Description |
|------|----------|-------------|
| Deep Link | 🟡 Medium | App navigation from notifications |
| Push Notifications | 🟡 Medium | FCM integration |
| Crash Reporting | 🟢 Low | Sentry or Firebase Crashlytics |
| Analytics | 🟢 Low | User behavior tracking |

---

## 8. UI Mockups (Badoo-inspired)

### Splash Screen (Current)
```
┌─────────────────────────────┐
│                             │
│         ❤️ (Logo)           │
│                             │
│          AURA               │
│     Find Your Match         │
│                             │
│    ████████████░░░░░░ 65%   │
│                             │
│   Connecting to server...   │
│                             │
└─────────────────────────────┘
```

### Login Screen (Current)
```
┌─────────────────────────────┐
│  ←  Welcome Back            │
│                             │
│        Welcome Back         │
│     Sign in to continue     │
│                             │
│  ┌──────────────────────┐   │
│  │ 📧 Enter your email   │   │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │ 🔒 Enter your password│ 👁️ │
│  └──────────────────────┘   │
│                             │
│  ┌──────────────────────┐   │
│  │       Login          │   │
│  └──────────────────────┘   │
│                             │
│  Don't have an account?     │
│     Create Account          │
└─────────────────────────────┘
```

### Welcome Screen (Current)
```
┌─────────────────────────────┐
│                          🌐  │
│                             │
│           AURA              │
│      Find Your Match        │
│   Connect with people...    │
│                             │
│   Join a community of...    │
│                             │
│  ┌──────────────────────┐   │
│  │ Enter your email      │   │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │ Enter your password  │ 👁️ │
│  └──────────────────────┘   │
│                             │
│  ┌──────────────────────┐   │
│  │      Sign Up         │   │
│  └──────────────────────┘   │
│                             │
│        ──── OR ────         │
│                             │
│  ┌──────────────────────┐   │
│  │ G   Continue with    │   │
│  │      Google          │   │
│  └──────────────────────┘   │
│                             │
│  Already have an account?   │
│         Sign in             │
│                             │
│  By continuing, you agree   │
│  to our Terms of Service    │
│  and Privacy Policy.        │
└─────────────────────────────┘
```

### Discover Screen (Planned)
```
┌─────────────────────────────┐
│  🔍  👤  💬  👥              │
├─────────────────────────────┤
│                             │
│     ┌─────────────────┐     │
│     │                 │     │
│     │   User Photo    │     │
│     │                 │     │
│     │   Name, Age     │     │
│     │   Bio text      │     │
│     └─────────────────┘     │
│                             │
│        ❌       ⭐       ❤️   │
│                             │
└─────────────────────────────┘
```

---

## Key Implementation Notes

### Health Check Path
- Backend: `GET /health` (without /api/v1 prefix)
- Frontend: `ApiService.healthCheck()` uses separate Dio with baseUrl without /api/v1

### Token Refresh Flow
1. Request returns 401
2. Interceptor catches error
3. Calls `/auth/refresh` with refresh_token
4. On success: updates tokens, retries original request
5. On failure: clears all tokens

### Splash Progress Logic
1. Generate random target between 50-99%
2. Animate progress to target
3. Call health check
4. If healthy, animate to 100%
5. Navigate based on auth status

---

**Next: Session 18 - Onboarding Flow**

Ready to start Session 18 when you are. 🚀
```