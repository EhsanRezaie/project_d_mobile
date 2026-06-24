Here's the updated `dev.md`:

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
| **Session 20** | ✅ COMPLETED (Photo Upload & Main Screen Flow) |
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
| **Photo Upload Screen** | ✅ |
| **Drag & Drop photo reordering** | ✅ |
| **PhotoService with upload, delete, set main** | ✅ |
| **Main Screen photo check (pending + approved)** | ✅ |
| **Complete onboarding flow (6 screens total)** | ✅ |

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
| **Reorderables** | reorderables | ^0.6.0 | Drag & drop reordering |

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
│   ├── location_models.dart
│   └── photo.dart              # Photo upload models
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── storage_service.dart
│   ├── google_auth_service.dart
│   ├── location_service.dart
│   ├── onboarding_service.dart
│   └── photo_service.dart      # Photo upload service
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
│       ├── prompts_screen.dart         # Step 4: Prompts with answers
│       └── photo_upload_screen.dart    # Step 5: Upload photos (3-9)
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
- **PhotoUploadScreen (Step 5):** Upload 3-9 photos with drag & drop reordering. Main photo selection with star badge. Remove button on all photos. Gallery and Camera options.

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

### Photo Upload System

- **PhotoService:** Upload, get, delete, set main, validate, convert to JPEG
- **PhotoUploadScreen:** Grid layout with bigger main photo (2x area)
- **Drag & Drop:** Long press and drag to reorder photos
- **Photo Limits:** Minimum 3 photos, maximum 9 photos
- **Main Photo:** Tap any photo to set as main, star badge indicator
- **Remove Button:** Shows on ALL photos including main
- **Validation:** File size (5MB), format (JPG, PNG, WEBP, HEIC)
- **Auto-conversion:** Converts images to JPEG for better compatibility

### Main Screen Flow

- **Profile Complete Check:** Redirects to BasicInfoScreen if profile not complete
- **Photo Check:** Redirects to PhotoUploadScreen if user has less than 3 photos (pending + approved)
- **Photo Status:** Counts both `pending` and `approved` photos during onboarding
- **Bottom Navigation:** Discover, Search, Chats, Profile tabs

---

## 7. TODO - Next Session

### Session 21: Translations & UI Polish

| Task | Priority | Description |
| --- | --- | --- |
| Add Translations for Onboarding Pages | 🔴 High | Add English and Persian translations for all onboarding screens (BasicInfo, ProfileDetails, Interests, Prompts, PhotoUpload) |
| Add Translations for PhotoUploadScreen | 🔴 High | Translate all text in PhotoUploadScreen (header, tips, buttons, validation messages) |
| Add Translations for Location APIs | 🔴 High | Translate location labels, error messages, and field names |
| Add Translations for Interests and Prompts | 🔴 High | Translate category names, interest names, prompt questions from backend |
| Add Translations for Main Screen | 🟡 Medium | Translate bottom navigation labels and profile screen |
| Add Translations for Validation Errors | 🟡 Medium | Translate all form validation error messages |
| Fix Any Remaining UI Issues | 🟢 Low | Address any overflow or layout issues |
| Profile Editing | 🟢 Low | Allow users to edit their profile after registration |

### Translation Files Structure

```
lib/l10n/
├── app_en.arb
│   ├── "basicInfoTitle": "Basic Info"
│   ├── "basicInfoSubtitle": "Tell us about yourself"
│   ├── "profileDetailsTitle": "Profile Details"
│   ├── "interestsTitle": "What are your interests?"
│   ├── "promptsTitle": "Answer up to 3 questions"
│   ├── "photoUploadTitle": "Add at least 3 photos"
│   ├── "back": "Back"
│   ├── "continue": "Continue"
│   ├── "complete": "Complete"
│   ├── "skip": "Skip"
│   ├── "done": "Done"
│   └── ... (all UI strings)
└── app_fa.arb
    ├── "basicInfoTitle": "اطلاعات اولیه"
    ├── "basicInfoSubtitle": "درباره خودت بگو"
    └── ... (Persian translations)
```

---

## 8. UI Mockups (Badoo-inspired)

### Onboarding Step 5: Photo Upload

```
┌─────────────────────────────┐
│    █████████████████████    │
│           Photos            │
│                             │
│   Add at least 3 photos...  │
│                             │
│  ┌──────────────┐ ┌──────┐ │
│  │              │ │  +   │ │
│  │   MAIN       │ │      │ │
│  │   (Bigger)   │ └──────┘ │
│  │              │ ┌──────┐ │
│  │              │ │  +   │ │
│  └──────────────┘ └──────┘ │
│                             │
│  ┌──────┐ ┌──────┐ ┌──────┐│
│  │  +   │ │  +   │ │  +   ││
│  └──────┘ └──────┘ └──────┘│
│                             │
│  Tips: Clear, high-quality  │
│  photos work best.          │
│  ┌────────────────────┐    │
│  │   Complete / Add X  │    │
│  └────────────────────┘    │
└─────────────────────────────┘
```

---

## 9. Key Implementation Notes

### Registration Flow (5 Steps)

1. **SignUpScreen** → `POST /auth/register/init` → VerifyCodeScreen
2. **VerifyCodeScreen** → `POST /auth/register/verify` → BasicInfoScreen
3. **BasicInfoScreen** → ProfileDetailsScreen → InterestsScreen → PromptsScreen
4. **PromptsScreen** → `POST /auth/register/complete` → PhotoUploadScreen
5. **PhotoUploadScreen** → Upload photos → MainScreen

### Photo Upload Flow

1. User selects photos (Gallery or Camera)
2. Photos display in grid with bigger main photo
3. Drag & drop to reorder
4. Tap to set as main
5. Click "Complete" → Upload all photos
6. Set main photo via API
7. Navigate to MainScreen

### Main Screen Flow

1. Check if profile is complete → if not, go to BasicInfoScreen
2. Check if user has 3+ photos (pending + approved) → if not, go to PhotoUploadScreen
3. Show MainScreen with tabs

### Location Flow

1. **GPS Granted:** Get lat/lng → Reverse geocode → Auto-fill country/state/city
2. **GPS Denied:** User selects country → States load → User selects state → Cities load → User selects city → Get centroid lat/lng

### Translation Architecture

- All UI text should use `AppLocalizations.of(context)!`
- Language selection persists via `StorageService.saveLanguage()`
- API calls for prompts and interests should pass `language` parameter
- Backend returns localized content based on the language parameter

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
| `/users/me/photos` | POST | ✅ Working |
| `/users/me/photos` | GET | ✅ Working |
| `/users/me/photos/{photo_id}` | DELETE | ✅ Working |
| `/users/me/photos/{photo_id}/main` | PUT | ✅ Working |
```

---

## Summary of Updates:

| Section | Changes |
|---------|---------|
| **Current Status** | Added Photo Upload Screen, Drag & Drop, PhotoService, Main Screen photo check, Complete onboarding flow |
| **Tech Stack** | Added `reorderables` package |
| **Project Structure** | Added `photo.dart` and `photo_service.dart` |
| **Completed Features** | Added Photo Upload System and Main Screen Flow sections |
| **TODO** | Added translations for all onboarding pages, PhotoUploadScreen, Main Screen, validation errors |
| **Translation Files Structure** | Added example of ARB file structure |
| **UI Mockups** | Added Photo Upload screen mockup |
| **Registration Flow** | Updated to 5 steps including PhotoUploadScreen |
| **Photo Upload Flow** | New section documenting the flow |
| **Main Screen Flow** | New section documenting the flow |
| **Backend Compatibility** | Added photo endpoints |

🚀