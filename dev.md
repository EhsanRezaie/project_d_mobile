Here's the updated `dev.md` with the new TODO item for translations:

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
| **Session 19** | 🔄 IN PROGRESS (Onboarding Flow Completed) |
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
| InterestsScreen with category grouping and expandable sections | ✅ |
| PromptsScreen with category grouping and answer fields | ✅ |
| Backend Location APIs integrated (countries, states, cities, reverse-geocode, centroid) | ✅ |
| LocationService with GPS and manual location selection | ✅ |
| Searchable dropdowns for country/state/city selection | ✅ |
| Full onboarding flow (4 steps: Basic Info → Profile Details → Interests → Prompts) | ✅ |
| Register complete API integration (`POST /auth/register/complete`) | ✅ |
| User registration with all profile data | ✅ |

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
│   ├── user.dart
│   ├── interest.dart
│   ├── prompt.dart
│   └── location_models.dart
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── storage_service.dart
│   ├── google_auth_service.dart
│   ├── location_service.dart
│   └── onboarding_service.dart
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
│       ├── basic_info_screen.dart      # Step 1: Name, Birth Date, Gender, Location
│       ├── profile_details_screen.dart # Step 2: Physical, Lifestyle, Beliefs
│       ├── interests_screen.dart       # Step 3: Interests with categories
│       └── prompts_screen.dart         # Step 4: Prompts with answers
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
API_BASE_URL=http://10.0.2.2:8000/api/v1
WS_BASE_URL=ws://10.0.2.2:8000/api/v1
WEB_CLIENT_ID=your_web_client_id.apps.googleusercontent.com
```

### App Constants

```dart
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
| --- | --- | --- |
| 1 | `POST /auth/register/init` | Check email, send 6-digit code |
| 2 | `POST /auth/register/verify` | Verify code + create user (email + password) |
| 3 | `POST /auth/register/complete` | Complete profile (all Badoo fields) |

### Onboarding Steps UI & Layout Overhaul

- **Instagram Story-Style Progress:** Integrated a centered, multi-segment story bar at the top of the app bar divided into 5 proportional layout blocks to clearly track progress.
- **Scroll-Responsive Floating Button Layout:** Converted fixed bottom action buttons into interactive floating layout configurations built inside `CustomScrollView` and `SliverFillRemaining` to avoid viewport constraint issues with device keyboards.
- **BasicInfoScreen (Step 1):** Redesigned with a minimal design style, removed back button, enlarged headline titles, and converted the traditional numeric age input field into a native interactive date picker. Added searchable dropdowns for country/state/city with GPS location support.
- **ProfileDetailsScreen (Step 2):** Removed redundant bio input layer. Refactored input models into descriptive emoji-labeled chip choice matrices (`📏 Height`, `🏋️ Weight`, `💪 Body Type`, etc.). Height slider configured between 140–220 cm, and weight configured between 40–140 kg. Expanded values to resemble premium dating platforms (Open relationships, specific religious/philosophical views, and local/international ethnic background configurations). Repositioned `Workplace` field as the final input component.
- **InterestsScreen (Step 3):** Category-based interest selection with expandable sections, searchable, minimum 8 interests required, progress indicator showing selection status.
- **PromptsScreen (Step 4):** Category-based prompt selection with expandable sections, up to 3 prompts can be selected, answer fields for each selected prompt, skip/continue functionality.

### Location System

- **Backend Location APIs integrated:**
  - `GET /locations/countries` - Get all countries
  - `GET /locations/states?country=IR` - Get states/provinces for a country
  - `GET /locations/cities?country=IR&state_name=Tehran` - Get cities filtered by state
  - `GET /locations/reverse-geocode?lat=35.68&lng=51.38` - GPS to location text
  - `GET /locations/city-centroid?country=IR&city=Tehran` - Get lat/lng for a city
- **GPS Location Support:** Get current location via device GPS, reverse-geocode to country/state/city
- **Manual Location Selection:** Searchable dropdowns for country, state, and city with autocomplete
- **Location Validation:** Ensures all required location fields are filled before proceeding

---

## 7. TODO - Next Session

### Session 20: Translations & UI Polish

| Task | Priority | Description |
| --- | --- | --- |
| Add Translations for Onboarding Pages | 🔴 High | Add English and Persian translations for all onboarding screens (BasicInfo, ProfileDetails, Interests, Prompts) |
| Add Translations for Location APIs | 🔴 High | Translate location labels, error messages, and field names |
| Add Translations for Interests and Prompts | 🔴 High | Translate category names, interest names, prompt questions from backend |
| Fix Any Remaining UI Issues | 🟡 Medium | Address any overflow or layout issues |
| Photo Upload Screen | 🟡 Medium | After registration, implement photo upload flow |
| Profile Editing | 🟢 Low | Allow users to edit their profile after registration |

---

## 8. UI Mockups (Badoo-inspired)

### Onboarding Step 1: Basic Info

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
│  │ 🔍 Country (search)  │   │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │ 🔍 State/Province    │   │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │ 🔍 City (search)     │   │
│  └──────────────────────┘   │
│                             │
│   ┌────────────────────┐    │
│   │     Continue       │    │
│   └────────────────────┘    │
└─────────────────────────────┘
```

### Onboarding Step 2: Profile Details

```
┌─────────────────────────────┐
│    ████████████░░░░░░░░░    │
│        Profile Details      │
│                             │
│   Tell us more about...     │
│                             │
│  📏 Height: 175 cm         │
│  🏋️ Weight: 70 kg          │
│                             │
│  💪 Body Type               │
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

### Onboarding Step 3: Interests

```
┌─────────────────────────────┐
│    ██████████████░░░░░░░    │
│          Interests          │
│                             │
│   What are your interests?  │
│   Select 8 more to continue │
│   ████████░░░░░░░░░░░░░░░  │
│   Selected: 3 / 8           │
│                             │
│  🎯 Sports & Fitness  [2] ▼ │
│    [⚽] Football             │
│    [🏀] Basketball           │
│    [🏊] Swimming             │
│                             │
│  🎨 Arts & Culture   [0] ▶ │
│                             │
│ ┌──────────┐  ┌───────────┐ │
│ │  ← Back  │  │ Continue →│ │
│ └──────────┘  └───────────┘ │
└─────────────────────────────┘
```

### Onboarding Step 4: Prompts

```
┌─────────────────────────────┐
│    █████████████████░░░░    │
│          Your Prompts       │
│                             │
│   Answer up to 3 questions  │
│   Choose prompts and write  │
│   Selected: 2 / 3           │
│                             │
│  💭 Travel & Adventure [1] ▼│
│    What's your dream trip?  │
│    ┌──────────────────┐     │
│    │ Write your answer │     │
│    └──────────────────┘     │
│                             │
│  💕 Personal Growth  [0] ▶ │
│                             │
│ ┌──────────┐  ┌───────────┐ │
│ │  ← Back  │  │  Continue │ │
│ └──────────┘  └───────────┘ │
└─────────────────────────────┘
```

---

## 9. Key Implementation Notes

### Registration Flow (4 Steps)

1. **SignUpScreen** → `POST /auth/register/init` → VerifyCodeScreen
2. **VerifyCodeScreen** → `POST /auth/register/verify` → BasicInfoScreen
3. **BasicInfoScreen** → ProfileDetailsScreen → InterestsScreen → PromptsScreen
4. **PromptsScreen** → `POST /auth/register/complete` → MainScreen

### Location Flow

1. **GPS Granted:** Get lat/lng → Reverse geocode → Auto-fill country/state/city
2. **GPS Denied:** User selects country → States load → User selects state → Cities load → User selects city → Get centroid lat/lng

### Translation Architecture

- All UI text should use `AppLocalizations.of(context)!`
- Language selection persists via `StorageService.saveLanguage()`
- API calls for prompts and interests should pass `language` parameter
- Backend returns localized content based on the language parameter

### Custom Chip Matrices Layout

To preserve space while creating an ultra-premium UI layout context, options are organized dynamically via standard wrapped builders using an explicit structural model mapped directly to backend string definitions.

---

## 10. Backend Compatibility

### API Endpoints Used

| Endpoint | Method | Status |
| --- | --- | --- |
| `/auth/register/init` | POST | ✅ Working |
| `/auth/register/verify` | POST | ✅ Working |
| `/auth/register/complete` | POST | ✅ Working |
| `/auth/login` | POST | ✅ Working |
| `/auth/google` | POST | ✅ Working |
| `/auth/refresh` | POST | ✅ Working |
| `/auth/logout` | POST | ✅ Working |
| `/auth/health` | GET | ✅ Working |
| `/users/me` | GET | ✅ Working |
| `/users/me` | PUT | 🔜 TODO |
| `/locations/countries` | GET | ✅ Working |
| `/locations/states` | GET | ✅ Working |
| `/locations/cities` | GET | ✅ Working |
| `/locations/reverse-geocode` | GET | ✅ Working |
| `/locations/city-centroid` | GET | ✅ Working |
| `/interests` | GET | ✅ Working |
| `/prompts` | GET | ✅ Working |
| `/locations/me/location-gps` | PATCH | ✅ Working |
| `/locations/me/location-manual` | PATCH | ✅ Working |
```

---

## Summary of Updates:

1. **Updated Current Status** - Added all completed onboarding features
2. **Updated Project Structure** - Added new files (interest, prompt, location_models, onboarding_service)
3. **Added TODO - Translations for Onboarding Pages** as 🔴 High priority
4. **Added Translation Architecture section** - explains how translations should work
5. **Updated UI Mockups** - Added Interests and Prompts screens
6. **Updated Registration Flow** - Changed from 3 steps to 4 steps
7. **Added Location Flow section** - Explains GPS and manual location selection
8. **Updated Backend Compatibility** - Added all location and interest/prompt endpoints

🚀