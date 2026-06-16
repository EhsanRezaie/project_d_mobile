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
6. [Completed Features (Session 16 - Night Build)](#6-completed-features-session-16---night-build)
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
| **Session 16 (Night Build)** | ✅ COMPLETED |
| Flutter project setup | ✅ |
| Dependencies installed | ✅ |
| Folder structure created | ✅ |
| Environment variables (.env) | ✅ |
| API Service (Dio) | ✅ |
| Auth Service (login, register) | ✅ |
| Storage Service (secure token storage) | ✅ |
| Auth Provider (state management) | ✅ |
| Onboarding Provider (complete) | ✅ |
| Language Provider | ✅ |
| Splash Screen | ✅ |
| Welcome Screen (enhanced) | ✅ |
| Email & Password validation | ✅ |
| Password visibility toggle | ✅ |
| Language selection (English/Persian) | ✅ |
| Google Sign-In button with custom icon | ✅ |
| Input filtering (English only) | ✅ |
| Real-time validation with localized errors | ✅ |
| Password min length: 8 characters | ✅ |

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
├── main_screen.dart
├── config/
│   ├── app_colors.dart          # Color palette
│   ├── app_constants.dart       # API URLs, keys
│   ├── app_theme.dart           # Theme configuration
│   └── app_routes.dart          # Named routes
├── models/
│   └── user.dart                # User model
├── services/
│   ├── api_service.dart         # Dio HTTP client
│   ├── auth_service.dart        # Login, register calls
│   └── storage_service.dart     # Token storage
├── providers/
│   ├── auth_provider.dart       # Auth state management
│   ├── language_provider.dart   # Language selection
│   └── onboarding_provider.dart # Onboarding data + API submit
├── screens/
│   ├── splash_screen.dart       # Splash screen
│   ├── welcome_screen.dart      # Welcome screen (enhanced)
│   ├── login_screen.dart        # Login screen
│   ├── main_screen.dart         # Main screen (bottom nav)
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

---

## 6. Completed Features (Session 16 - Night Build)

### Welcome Screen Features

| Element | Description |
|---------|-------------|
| Background | Color(0xFFFBF9F9) - light gray |
| App Name | "AURA" (font size 40, weight 700) |
| Title | Localized via AppLocalizations.welcome_title |
| Subtitle | Localized via AppLocalizations.welcome_subtitle |
| Community Text | Localized via AppLocalizations.join_community_text |
| Email Field | With input filtering (English only), real-time validation |
| Password Field | With eye toggle, input filtering, real-time validation, min 8 chars |
| Sign Up Button | Primary navy button |
| OR Divider | Centered "OR" text |
| Google Button | Custom asset icon + localized text |
| Sign In Link | "Already have an account? Sign in" |
| Terms & Policy | Small text at bottom |
| Language Button | Top-right globe icon, opens dialog |

### Input Validation Rules

| Field | Validation |
|-------|------------|
| Email | Required, valid email format (RegExp) |
| Password | Required, minimum 8 characters |

### Input Filtering

| Field | Allowed Characters |
|-------|-------------------|
| Email | a-zA-Z0-9@._%+- |
| Password | a-zA-Z0-9!@#$%^&*()_+{}|:<>?~ |

### Localization Strings

All error messages are localized via AppLocalizations:

| Key | English | Persian |
|-----|---------|---------|
| email_required | Email is required | ایمیل الزامی است |
| email_invalid | Please enter a valid email | لطفاً یک ایمیل معتبر وارد کنید |
| password_required | Password is required | رمز عبور الزامی است |
| password_min_length | Password must be at least 8 characters | رمز عبور باید حداقل ۸ کاراکتر باشد |

### Language Selection Dialog

- Opens as a centered Dialog (not bottom sheet)
- Options: English 🇺🇸, Persian 🇮🇷
- Selected option highlighted with checkmark
- Cancel button to close

### Google Sign-In Button

- Custom asset: `assets/images/google_logo.png`
- Size: 24x24
- Background: Color.fromARGB(255, 224, 229, 231)
- Text: Localized via `continue_with_google`

---

## 7. TODO - Next Session

### Session 17: Authentication & Navigation Flow

| Task | Priority | Description |
|------|----------|-------------|
| Connect Login Button | 🔴 High | Navigate to Login Screen |
| Connect Sign Up Button | 🔴 High | Navigate to EmailPasswordScreen |
| Connect Sign In Link | 🔴 High | Navigate to Login Screen |
| Connect Google Button | 🟡 Medium | Implement GoogleAuthProvider |
| Connect Continue Button | 🔴 High | Validate and proceed to next screen |
| Create Login Screen | 🔴 High | Email + Password with validation |
| Create MainScreen Navigation | 🔴 High | Bottom nav with 4 tabs (placeholder) |

### Session 18: Onboarding Flow

| Task | Priority | Description |
|------|----------|-------------|
| EmailPasswordScreen | 🔴 High | Step 0: Email & Password |
| NameAgeScreen | 🔴 High | Step 1: Name, Age, Gender |
| HeightWeightScreen | 🟡 Medium | Step 2: Height, Weight |
| PhotoScreen | 🟡 Medium | Step 3: Photos (skip option) |
| LocationScreen | 🟡 Medium | Step 4: Location & Submit |
| OnboardingProvider | 🔴 High | State management for all steps |
| Registration API | 🔴 High | Connect to backend |

### Session 19: Main App Features

| Task | Priority | Description |
|------|----------|-------------|
| Discover Screen | 🔴 High | Swipeable profile cards |
| Search Screen | 🟡 Medium | Search with filters |
| Profile Screen | 🟡 Medium | View and edit profile |
| Chats Screen | 🟡 Medium | Messages list |
| Chat Detail | 🟡 Medium | Real-time messaging |
| Likes Tab | 🟢 Low | Likes sent/received |

---

## 8. UI Mockups (Badoo-inspired)

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

### Login Screen (Planned)
```
┌─────────────────────────────┐
│  ←  Welcome Back            │
│                             │
│  ┌──────────────────────┐   │
│  │ Enter your email      │   │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │ Enter your password  │ 👁️ │
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

---

## Next Session

**Session 17: Authentication & Navigation Flow**

Ready to start Session 17 when you are. 🚀
```