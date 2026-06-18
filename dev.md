## `mobile_dev.md` - Iranian Dating App Flutter (Updated)

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
9. [Key Implementation Notes](#9-key-implementation-notes)
10. [Backend Compatibility](#10-backend-compatibility)

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
| **Session 18** | ✅ IN PROGRESS |
| Flutter project setup | ✅ |
| Dependencies installed | ✅ |
| Folder structure created | ✅ |
| Environment variables (.env) | ✅ |
| API Service (Dio) with interceptors | ✅ |
| Auth Service (3-step registration) | ✅ |
| Storage Service (secure token storage) | ✅ |
| Auth Provider (state management) | ✅ |
| Onboarding Provider | ✅ |
| Language Provider | ✅ |
| App Theme (Light/Dark mode ready) | ✅ |
| Splash Screen (with progress bar & random target) | ✅ |
| Login Screen (combined with Welcome) | ✅ |
| Sign Up Screen (with validation) | ✅ |
| Verify Code Screen (6-digit + referral) | ✅ |
| Main Screen (bottom nav with 4 tabs) | ✅ |
| Profile Screen (user info + logout) | ✅ |
| Token persistence on app restart | ✅ |
| Backend UserProfileResponse compatibility | ✅ |
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
| Theme-aware colors (Light/Dark ready) | ✅ |
| Keyboard handling (resize & dismiss on tap) | ✅ |

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
│   └── user.dart                # User model (full Badoo fields)
├── services/
│   ├── api_service.dart         # Dio HTTP client + interceptors
│   ├── auth_service.dart        # 3-step registration (init, verify, complete)
│   └── storage_service.dart     # Token storage + secure storage
├── providers/
│   ├── auth_provider.dart       # Auth state management (3-step)
│   ├── language_provider.dart   # Language selection
│   └── onboarding_provider.dart # Onboarding data + API submit
├── screens/
│   ├── splash_screen.dart       # Splash with progress & health check
│   ├── login_screen.dart        # Login + Welcome combined
│   ├── main_screen.dart         # Main screen (bottom nav with 4 tabs)
│   ├── auth/
│   │   ├── sign_up_screen.dart  # Step 1: Email + Password
│   │   └── verify_code_screen.dart # Step 2: 6-digit code + referral
│   └── onboarding/
│       ├── personal_info_screen.dart  # Step 3a: Name, Birth Date, Gender
│       ├── lifestyle_screen.dart      # Step 3b: Height, Weight, Lifestyle (TODO)
│       ├── interests_screen.dart      # Step 3c: Interests & Prompts (TODO)
│       └── location_screen.dart       # Step 3d: Location & Submit (TODO)
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

### Auth Flow (3-Step Registration)

| Step | Endpoint | Description |
|------|----------|-------------|
| 1 | `POST /auth/register/init` | Check email, send 6-digit code |
| 2 | `POST /auth/register/verify` | Verify code + create user (email + password) |
| 3 | `POST /auth/register/complete` | Complete profile (all Badoo fields) |

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
| Auto-Navigation | Goes to MainScreen if authenticated, else LoginScreen |
| Theme Aware | Uses AppTheme colors (Light/Dark ready) |

### Login Screen (Welcome + Login combined)

| Feature | Description |
|---------|-------------|
| App Logo & Title | "AURA" with subtitle |
| Community Text | Join community message |
| Email Field | With real-time validation |
| Password Field | With visibility toggle & real-time validation |
| Sign In Button | Calls login API |
| OR Divider | Centered "OR" text |
| Google Button | Custom asset icon + localized text |
| Sign Up Link | Navigates to SignUpScreen |
| Language Selector | Top-right globe icon with dialog |
| Terms & Policy | Small text at bottom |
| Keyboard Handling | Resize on open, dismiss on tap outside |
| Theme Aware | Light/Dark mode ready |

### Sign Up Screen

| Feature | Description |
|---------|-------------|
| Form Validation | Email format + password length (min 8) |
| Password Visibility | Toggle show/hide for both password fields |
| Confirm Password | Validates match with password |
| Loading State | Disabled button with spinner |
| Error Handling | SnackBar with error message |
| Navigation | Back to Login, forward to VerifyCodeScreen |
| Theme Aware | Uses AppTheme colors (Light/Dark ready) |
| Keyboard Handling | Resize on open, dismiss on tap outside |

### Verify Code Screen

| Feature | Description |
|---------|-------------|
| 6-digit Code Input | Auto-focus next field on entry |
| Resend Code | Button to request new code |
| Referral Code | Optional field for referral code |
| Loading State | Disabled button with spinner |
| Error Handling | SnackBar with error message |
| Navigation | Back to SignUp, forward to MainScreen |
| Theme Aware | Uses AppTheme colors (Light/Dark ready) |

### Main Screen

| Feature | Description |
|---------|-------------|
| Bottom Navigation | 4 tabs (Discover, Search, Chats, Profile) |
| Discover Tab | Placeholder for swipe cards |
| Search Tab | Placeholder for search |
| Chats Tab | Placeholder for messages |
| Profile Tab | Shows user info + logout button |
| Onboarding Check | Redirects to PersonalInfoScreen if profile incomplete |

### Token Management

| Feature | Description |
|---------|-------------|
| Storage | `flutter_secure_storage` for tokens |
| Auto-Refresh | Interceptor handles 401 with refresh token |
| Persistence | Tokens survive app restart |
| Logout | Clears tokens and navigates to Login |

---

## 7. TODO - Next Session

### Session 19: Complete Onboarding Flow

| Task | Priority | Description |
|------|----------|-------------|
| LifestyleScreen | 🔴 High | Step 3b: Height, Weight, Lifestyle |
| InterestsScreen | 🔴 High | Step 3c: Interests & Prompts |
| LocationScreen | 🔴 High | Step 3d: Location & Submit |
| Register Complete API | 🔴 High | Connect to backend POST /auth/register/complete |
| Onboarding Navigation | 🔴 High | Connect all screens with navigation |

### Session 20: Main App Features

| Task | Priority | Description |
|------|----------|-------------|
| Discover Screen | 🔴 High | Swipeable profile cards |
| Search Screen | 🟡 Medium | Search with filters |
| Profile Screen | 🟡 Medium | View and edit profile |
| Chats Screen | 🟡 Medium | Messages list |
| Chat Detail | 🟡 Medium | Real-time messaging |
| Likes Tab | 🟢 Low | Likes sent/received |

### Session 21: Polish & Production

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
│  │      Sign In         │   │
│  └──────────────────────┘   │
│                             │
│        ──── OR ────         │
│                             │
│  ┌──────────────────────┐   │
│  │ G   Continue with    │   │
│  │      Google          │   │
│  └──────────────────────┘   │
│                             │
│  Don't have an account?     │
│         Sign Up             │
│                             │
│  By continuing, you agree   │
│  to our Terms of Service    │
│  and Privacy Policy.        │
└─────────────────────────────┘
```

### Sign Up Screen (Current)
```
┌─────────────────────────────┐
│  ←  Create Account          │
│                             │
│        Create Account       │
│   Join us and find your match│
│                             │
│  ┌──────────────────────┐   │
│  │ 📧 Enter your email   │   │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │ 🔒 Enter your password│ 👁️ │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │ 🔒 Confirm your pass │ 👁️ │
│  └──────────────────────┘   │
│                             │
│  ┌──────────────────────┐   │
│  │      Sign Up         │   │
│  └──────────────────────┘   │
│                             │
│  Already have an account?   │
│         Sign In             │
└─────────────────────────────┘
```

### Verify Code Screen (Current)
```
┌─────────────────────────────┐
│  ←  Verify Your Email       │
│                             │
│        Verify Your Email    │
│   Enter the 6-digit code    │
│   sent to test@example.com  │
│                             │
│     [1] [2] [3] [4] [5] [6] │
│                             │
│        Resend Code          │
│                             │
│   Enter your referral code  │
│   ┌──────────────────────┐  │
│   │  Referral code       │  │
│   └──────────────────────┘  │
│                             │
│  ┌──────────────────────┐   │
│  │   Verify & Continue  │   │
│  └──────────────────────┘   │
│                             │
│  💡 Get 3 days of premium   │
│     free with a referral    │
│     code                    │
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

## 9. Key Implementation Notes

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

### Keyboard Handling
- All screens use `resizeToAvoidBottomInset: true`
- `GestureDetector` with `behavior: HitTestBehavior.opaque` and `onTap: FocusScope.of(context).unfocus()` to dismiss keyboard
- `SingleChildScrollView` for scroll when keyboard is open

### Theme System
- Colors from `AppTheme` (Light/Dark ready)
- Use `context.isDarkMode` to detect theme
- Text styles from `AppTheme` (headlineLarge, headlineMedium, bodyLarge, etc.)
- Button styles from `AppTheme` (primaryButton, outlineButton)

### Registration Flow (3-Step)
1. **SignUpScreen** → `POST /auth/register/init` → VerifyCodeScreen
2. **VerifyCodeScreen** → `POST /auth/register/verify` → MainScreen
3. **Onboarding screens** → `POST /auth/register/complete` → MainScreen (with profile)

### Navigation Guards
- If user has tokens → auto-login on app restart
- If token expired → refresh token interceptor
- If refresh token expired → redirect to LoginScreen
- If profile incomplete → redirect to PersonalInfoScreen

---

## 10. Backend Compatibility

### User Model Changes (Backend Session 16-17)

| Old Field | New Field | Location |
|-----------|-----------|----------|
| `name` | `name` | `UserProfile` |
| `age` | `birth_date` + `age` property | `UserProfile` |
| `gender` | `gender` | `UserProfile` |
| `height` | `height` | `UserProfile` |
| `weight` | `weight` | `UserProfile` |
| `bio` | `bio` | `UserProfile` |
| `lat/lng` | `lat/lng` | `UserProfile` |
| `country/province/city` | `country/province/city` | `UserProfile` |
| `premium_until` | `premium_until` | `UserProfile` |
| `is_premium` | `is_premium` (property) | `UserProfile` |
| `is_profile_complete` | `is_profile_complete` (property) | `UserProfile` |
| `hide_last_seen` | `hide_last_seen` | `UserSettings` |
| `hide_online_status` | `hide_online_status` | `UserSettings` |

### API Endpoints Used

| Endpoint | Method | Status |
|----------|--------|--------|
| `/auth/register/init` | POST | ✅ Working |
| `/auth/register/verify` | POST | ✅ Working |
| `/auth/register/complete` | POST | 🔜 TODO |
| `/auth/login` | POST | ✅ Working |
| `/auth/refresh` | POST | ✅ Working |
| `/auth/logout` | POST | ✅ Working |
| `/auth/health` | GET | ✅ Working |
| `/users/me` | GET | ✅ Working |
| `/users/me` | PUT | 🔜 TODO |

---

**Next: Session 19 - Complete Onboarding Flow (Lifestyle, Interests, Location)**

Ready to start Session 19 when you are. 🚀
```