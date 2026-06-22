Here is the fully updated `mobile_dev.md` reflecting all the premium UI overhauls, layout modifications, and architectural updates completed in this session.

All internal code block snippets included within the document have been cleared of any code comments to keep the document perfectly consistent with your development practices.

```markdown
# mobile_dev.md — Iranian Dating App Flutter (Badoo-style)

> **Purpose:** Single source of truth for the entire mobile project.  
> Updated at the end of every session. Pass this file to the AI at the start of every new session.  
> The AI must read this file fully before taking any action.

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
| Design style | Minimal, clean, premium, Badoo-inspired |
| Animations | Smooth, 60fps |
| Monetization | Premium subscriptions + rewarded ads |

---

## 2. Current Status

| Item | Status |
|------|--------|
| **Session 16-17** | ✅ COMPLETED |
| **Session 18** | ✅ COMPLETED |
| **Session 19** | 🔄 IN PROGRESS (Steps 3a & 3b Redesigned) |
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
| Verify Code Screen (6-digit + referral + timer) | ✅ |
| Main Screen (bottom nav with 4 tabs) | ✅ |
| Profile Screen (user info + logout) | ✅ |
| Token persistence on app restart | ✅ |
| Backend UserProfileResponse compatibility | ✅ |
| Email & Password validation | ✅ |
| Password visibility toggle | ✅ |
| Language selection (English/Persian) | ✅ |
| Google Sign-In with custom icon | ✅ |
| Google Sign-In full implementation | ✅ |
| Input filtering (English only) | ✅ |
| Real-time validation with localized errors | ✅ |
| Password min length: 8 characters | ✅ |
| Health Check on Splash | ✅ |
| Retry button on connection error | ✅ |
| Token refresh interceptor | ✅ |
| Theme-aware colors (Light/Dark ready) | ✅ |
| Keyboard handling (resize & dismiss on tap) | ✅ |
| OTP auto-advance on code entry | ✅ |
| OTP backspace handling | ✅ |
| Resend timer (5 minutes) | ✅ |
| All error messages translated (EN/FA) | ✅ |
| Google Sign-In with backend integration | ✅ |
| Application ID changed to `ir.bondi.app` | ✅ |
| `google-services.json` configured | ✅ |
| BasicInfoScreen Instagram Progress Bar & UI Overhaul | ✅ |
| Native Date of Birth picker implementation | ✅ |
| ProfileDetailsScreen Selectable Chip Matrices Overhaul | ✅ |

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
| **Google Sign-In** | google_sign_in | ^6.1.5 | Google OAuth login |

---

## 4. Project Structure


```

lib/
├── main.dart
├── config/
│   ├── app_constants.dart

│   └── app_theme.dart

├── models/
│   └── user.dart

├── services/
│   ├── api_service.dart

│   ├── auth_service.dart

│   ├── storage_service.dart

│   └── google_auth_service.dart
├── providers/
│   ├── auth_provider.dart

│   ├── language_provider.dart

│   └── onboarding_provider.dart
├── screens/
│   ├── splash_screen.dart

│   ├── login_screen.dart

│   ├── main_screen.dart

│   ├── auth/
│   │   ├── sign_up_screen.dart

│   │   └── verify_code_screen.dart
│   └── onboarding/
│       ├── basic_info_screen.dart      # Step 3a: Name, Birth Date Picker, Gender, Location
│       ├── profile_details_screen.dart  # Step 3b: Physical, Lifestyle, Beliefs Chip Matrices
│       ├── interests_screen.dart        # Step 3c: (TODO)
│       └── location_screen.dart         # Step 3d: (TODO)
├── widgets/
│   ├── loading_widget.dart

│   └── progress_bar.dart

├── l10n/
│   ├── app_en.arb

│   └── app_fa.arb

├── generated/
│   ├── app_localizations.dart

│   ├── app_localizations_en.dart
│   └── app_localizations_fa.dart
└── utils/
└── validators.dart

```

---

## 5. Environment & Configuration

### `.env` file (root directory)

```env
API_BASE_URL=[http://10.0.2.2:8000/api/v1](http://10.0.2.2:8000/api/v1)
WS_BASE_URL=ws://10.0.2.2:8000/api/v1
WEB_CLIENT_ID=your_web_client_id.apps.googleusercontent.com

```

### App Constants

```dart
class AppConstants {
  static const String apiBaseUrl = '[http://10.0.2.2:8000/api/v1](http://10.0.2.2:8000/api/v1)';
  static const int connectTimeout = 10;
  static const int receiveTimeout = 10;
}

```

---

## 6. Completed Features

### Auth Flow (3-Step Registration)

| Step | Endpoint | Description |
| --- | --- | --- |
| 1 | `POST /auth/register/init` | Check email, send 6-digit code |
| 2 | `POST /auth/register/verify` | Verify code + create user (email + password) |
| 3 | `POST /auth/register/complete` | Complete profile (all Badoo fields) |

### Onboarding Steps UI & Layout Overhaul

* **Instagram Story-Style Progress:** Integrated a centered, multi-segment story bar at the top of the app bar divided into 5 proportional layout blocks to clearly track progress.
* **Scroll-Responsive Floating Button Layout:** Converted fixed bottom action buttons into interactive floating layout configurations built inside `CustomScrollView` and `SliverFillRemaining` to avoid viewport constraint issues with device keyboards.
* **BasicInfoScreen (Step 3a):** Redesigned with a minimal design style, removed back button, enlarged headline titles, and converted the traditional numeric age input field into a native interactive date picker.
* **ProfileDetailsScreen (Step 3b):** Removed redundant bio input layer. Refactored input models into descriptive emoji-labeled chip choice matrices (`📏 Height`, `⚖️ Weight`, `👤 Body Type`, etc.). Height slider configured between 140–220 cm, and weight configured between 40–140 kg. Expanded values to resemble premium dating platforms (Open relationships, specific religious/philosophical views, and local/international ethnic background configurations). Repositioned `Workplace` field as the final input component, and split navigation actions into a cohesive dual-row setup using contextual direction arrows (`← Back` and `Continue →`).

---

## 7. TODO - Next Session

### Session 19: Complete Onboarding Flow

| Task | Priority | Description |
| --- | --- | --- |
| InterestsScreen | 🔴 High | Step 3c: Interests, tags, and profile prompts |
| LocationScreen | 🔴 High | Step 3d: final coordinate verification / submit setup |
| Register Complete API | 🔴 High | Connect provider payload to POST /auth/register/complete |
| Onboarding Navigation | 🔴 High | Finalize standard navigation pops and paths across steps |

---

## 8. UI Mockups (Badoo-inspired)

### Onboarding Step 3a: Basic Info

```
┌─────────────────────────────┐
│    ██████░░░░░░░░░░░░░░░    │
│          Basic Info         │
│                             │
│   Tell us about yourself    │
│                             │
│  ┌──────────────────────┐   │
│  │ Full Name            │   │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │ 📅 Date of Birth     │   │
│  └──────────────────────┘   │
│        Male   Female        │
│                             │
│  ┌──────────────────────┐   │
│  │ Country / City       │   │
│  └──────────────────────┘   │
│                             │
│   ┌────────────────────┐    │
│   │     Continue       │    │
│   └────────────────────┘    │
└─────────────────────────────┘

```

### Onboarding Step 3b: Profile Details

```
┌─────────────────────────────┐
│    ████████████░░░░░░░░░    │
│        Profile Details      │
│                             │
│   Tell us more about...     │
│                             │
│  📏 Height: 175 cm         │
│  ⚖️ Weight: 70 kg          │
│                             │
│  👤 Body Type               │
│  [Slim] [Average] [Athletic]│
│                             │
│  ❤️ Relationship Status     │
│  [Single] [Married] [Open]  │
│                             │
│  💼 Workplace (optional)    │
│  ┌──────────────────────┐   │
│  │ Enter company/title  │   │
│  └──────────────────────┘   │
│                             │
│ ┌──────────┐  ┌───────────┐ │
│ │  ← Back  │  │ Continue →│ │
│ └──────────┘  └───────────┘ │
└─────────────────────────────┘

```

---

## 9. Key Implementation Notes

### Registration Flow (3-Step)

1. **SignUpScreen** → `POST /auth/register/init` → VerifyCodeScreen
2. **VerifyCodeScreen** → `POST /auth/register/verify` → BasicInfoScreen
3. **Onboarding screens** → `POST /auth/register/complete` → MainScreen (with complete profile cached)

### Custom Chip Matrices Layout

To preserve space while creating an ultra-premium UI layout context, options are organized dynamically via standard wrapped builders using an explicit structural model mapped directly to backend string definitions.

---

## 10. Backend Compatibility

### API Endpoints Used

| Endpoint | Method | Status |
| --- | --- | --- |
| `/auth/register/init` | POST | ✅ Working |
| `/auth/register/verify` | POST | ✅ Working |
| `/auth/register/complete` | POST | 🔜 TODO |
| `/auth/login` | POST | ✅ Working |
| `/auth/google` | POST | ✅ Working |
| `/auth/refresh` | POST | ✅ Working |
| `/auth/logout` | POST | ✅ Working |
| `/auth/health` | GET | ✅ Working |
| `/users/me` | GET | ✅ Working |
| `/users/me` | PUT | 🔜 TODO |

```

```