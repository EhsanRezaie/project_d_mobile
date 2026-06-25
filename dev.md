Here's the updated `dev.md` with the new TODO items for the Profile Edit features:

---

## Updated `dev.md`

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
| **Session 21** | 🔄 IN PROGRESS (Profile Edit & Account Settings) |
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
| Backend Location APIs integrated | ✅ |
| LocationService with GPS and manual location selection | ✅ |
| Searchable dropdowns for country/state/city selection | ✅ |
| Full onboarding flow (5 steps) | ✅ |
| Register complete API integration | ✅ |
| User registration with all profile data | ✅ |
| Photo Upload Screen | ✅ |
| Drag & Drop photo reordering | ✅ |
| PhotoService with upload, delete, set main | ✅ |
| Main Screen photo check (pending + approved) | ✅ |
| Complete onboarding flow (6 screens total) | ✅ |
| Profile Avatar Crop | ✅ |
| Photo verification status display | 🔜 TODO |
| Profile Edit Screens | 🔜 TODO |
| Account Settings Menu (6 items) | 🔜 TODO |

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
│   └── photo.dart
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── storage_service.dart
│   ├── google_auth_service.dart
│   ├── location_service.dart
│   ├── onboarding_service.dart
│   └── photo_service.dart
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
│   ├── onboarding/
│   │   ├── basic_info_screen.dart
│   │   ├── profile_details_screen.dart
│   │   ├── interests_screen.dart
│   │   ├── prompts_screen.dart
│   │   └── photo_upload_screen.dart
│   └── profile/
│       ├── profile_screen.dart
│       ├── avatar_crop_screen.dart
│       ├── edit_basic_info_screen.dart      # NEW
│       ├── edit_profile_details_screen.dart # NEW
│       ├── edit_interests_screen.dart       # NEW
│       └── edit_prompts_screen.dart         # NEW
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

---

## 6. Completed Features

### Auth Flow (3-Step Registration)

| Step | Endpoint | Description |
| --- | --- | --- |
| 1 | `POST /auth/register/init` | Check email, send 6-digit code |
| 2 | `POST /auth/register/verify` | Verify code + create user (email + password) |
| 3 | `POST /auth/register/complete` | Complete profile (all Badoo fields) |

### Onboarding Steps

- **Instagram Story-Style Progress:** 5-step progress bar
- **BasicInfoScreen:** Name, DOB, Gender, Location with searchable dropdowns
- **ProfileDetailsScreen:** Height, Weight, Body Type, Relationship Status, etc.
- **InterestsScreen:** Category-based interest selection (min 8)
- **PromptsScreen:** Category-based prompt selection (max 3)
- **PhotoUploadScreen:** 3-9 photos with drag & drop reordering

### Location System

- **Backend Location APIs integrated:**
  - `GET /locations/countries`
  - `GET /locations/states?country=IR`
  - `GET /locations/cities?country=IR&state_name=Tehran`
  - `GET /locations/reverse-geocode`
  - `GET /locations/city-centroid`
- **GPS Location Support:** Auto-fill from device location
- **Manual Location Selection:** Searchable dropdowns with autocomplete

### Photo Upload System

- **PhotoService:** Upload, get, delete, set main, validate, convert to JPEG
- **Drag & Drop:** Long press and drag to reorder photos
- **Photo Limits:** Minimum 3 photos, maximum 9 photos
- **Main Photo:** Tap any photo to set as main, star badge indicator
- **Remove Button:** Shows on ALL photos including main
- **Avatar Crop:** User can drag to adjust profile picture crop

### Main Screen Flow

- **Profile Complete Check:** Redirects to onboarding if profile not complete
- **Photo Check:** Redirects to PhotoUploadScreen if less than 3 photos
- **Photo Status:** Counts both `pending` and `approved` photos
- **Bottom Navigation:** Discover, Search, Chats, Profile

---

## 7. TODO - Next Session

### Session 21: Profile Edit & Account Settings

| Task | Priority | Description |
| --- | --- | --- |
| Update Account Section (6 items) | 🔴 High | Replace 3 menu items with 6: Verify Picture, Basic Info, Profile Details, Interests, Prompts, Edit Photos |
| Remove Logout Button | 🔴 High | Remove logout button from profile page (keep only in settings) |
| Edit Basic Info Screen | 🔴 High | Reuse BasicInfoScreen UI with back button, pre-filled data, save → PUT /users/me |
| Edit Profile Details Screen | 🔴 High | Reuse ProfileDetailsScreen UI with back button, pre-filled data, save → PUT /users/me |
| Edit Interests Screen | 🔴 High | Reuse InterestsScreen UI with back button, pre-filled data, save → PUT /users/me |
| Edit Prompts Screen | 🔴 High | Reuse PromptsScreen UI with back button, pre-filled data, save → PUT /users/me |
| Verify Picture Status | 🔴 High | Show verification status using `face_verified` from PhotoResponse |
| Edit Photos Screen | 🟡 Medium | Manage photos (upload, delete, reorder, set main) - details later |
| Add Translations for Edit Screens | 🟡 Medium | Translate all edit screen UI text |
| Add Loading States | 🟢 Low | Show loading indicators during save operations |
| Add Success/Error Messages | 🟢 Low | Show snackbars after save/cancel actions |

### Account Section Menu Items:

```
┌────────────────────────────────────────────┐
│  ACCOUNT                                    │
│  ┌────────────────────────────────────────┐ │
│  │  ✅ Verify Picture              →    │ │
│  │  (Verified / Clickable if not)        │ │
│  ├────────────────────────────────────────┤ │
│  │  ✏️ Basic Info                  →    │ │
│  ├────────────────────────────────────────┤ │
│  │  📝 Profile Details             →    │ │
│  ├────────────────────────────────────────┤ │
│  │  🎯 Interests                   →    │ │
│  ├────────────────────────────────────────┤ │
│  │  💬 Prompts                     →    │ │
│  ├────────────────────────────────────────┤ │
│  │  📸 Edit Photos                 →    │ │
│  └────────────────────────────────────────┘ │
└────────────────────────────────────────────┘
```

### Edit Screen Design:

```
┌────────────────────────────────────────────┐
│  ← Back                                    │
│                                             │
│  [Same content as onboarding screen]        │
│  (pre-filled with user data)               │
│                                             │
│  ┌────────────────────────────────────────┐ │
│  │              Save                     │ │
│  └────────────────────────────────────────┘ │
└────────────────────────────────────────────┘
```

---

## 8. UI Mockups

### Account Section:

```
┌────────────────────────────────────────────┐
│  Profile                                    │
│  ┌──────────┐                              │
│  │  Avatar  │  Alex, 28                    │
│  │  (edit)  │  New York, NY                │
│  └──────────┘                              │
│                                             │
│  ❤️  Likes   💑  Matches   💬  Messages   │
│  145          12           89              │
│                                             │
│  ┌────────────────────────────────────────┐ │
│  │  ⭐ BONDI PREMIUM               →    │ │
│  │  Unlock Exclusive Connections         │ │
│  │  Get Premium                          │ │
│  └────────────────────────────────────────┘ │
│                                             │
│  ACCOUNT                                    │
│  ┌────────────────────────────────────────┐ │
│  │  ✅ Verify Picture              →    │ │
│  ├────────────────────────────────────────┤ │
│  │  ✏️ Basic Info                  →    │ │
│  ├────────────────────────────────────────┤ │
│  │  📝 Profile Details             →    │ │
│  ├────────────────────────────────────────┤ │
│  │  🎯 Interests                   →    │ │
│  ├────────────────────────────────────────┤ │
│  │  💬 Prompts                     →    │ │
│  ├────────────────────────────────────────┤ │
│  │  📸 Edit Photos                 →    │ │
│  └────────────────────────────────────────┘ │
└────────────────────────────────────────────┘
```

---

## 9. Key Implementation Notes

### Registration Flow (5 Steps)

1. **SignUpScreen** → `POST /auth/register/init` → VerifyCodeScreen
2. **VerifyCodeScreen** → `POST /auth/register/verify` → BasicInfoScreen
3. **BasicInfoScreen** → ProfileDetailsScreen → InterestsScreen → PromptsScreen
4. **PromptsScreen** → `POST /auth/register/complete` → PhotoUploadScreen
5. **PhotoUploadScreen** → Upload photos → MainScreen

### Edit Profile Flow

1. User taps menu item in Account section
2. Opens edit screen with pre-filled data from `AuthProvider.user`
3. User modifies fields
4. Taps "Save" → `PUT /users/me` with updated data
5. Show success/error message
6. Return to Profile screen

### Photo Verification

- Check `mainPhoto?.faceVerified` to show verification status
- If `true`: Show ✅ Verified badge
- If `false`: Show clickable "Verify" item

### Translation Architecture

- All UI text uses `AppLocalizations.of(context)!`
- Language selection persists via `StorageService.saveLanguage()`
- API calls for prompts and interests pass `language` parameter

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
| `/users/me` | PUT | 🔜 TODO (Profile Edit) |
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
| **Current Status** | Added Session 21 in progress, new TODO items |
| **TODO** | Added Profile Edit & Account Settings tasks (6 menu items) |
| **UI Mockups** | Added Account Section and Edit Screen mockups |
| **Project Structure** | Added new edit screens in `profile/` folder |
| **Key Implementation Notes** | Added Edit Profile Flow and Photo Verification sections |
| **Backend Compatibility** | Added `PUT /users/me` as 🔜 TODO |

🚀