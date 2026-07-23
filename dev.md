## Updated `README.md` - Added Translation Tasks

```markdown
# Iranian Dating App - Flutter Mobile Client

Flutter mobile client for Iranian dating app (Badoo-style).

## Features

- ✅ User Authentication (Register, Login)
- ✅ Secure token storage with flutter_secure_storage
- ✅ Environment configuration via .env
- ✅ Clean architecture with Provider state management
- ✅ Profile Edit & Account Settings (Session 21)
- ✅ Google Sign-In Integration
- ✅ Photo Upload with Drag & Drop
- ✅ Location Services with GPS and Manual Selection
- ✅ Settings Screen (Dark Mode, Privacy, Notifications, Language)
- ✅ Dark Mode - Full theme support
- 🔄 Localization & Translation (In Progress)
- ⬜ Discover card swiping (Coming in Session 23)
- ⬜ Search with filters (Coming in Session 23)
- ⬜ Real-time chat with WebSocket (Coming in Session 24)
- ⬜ Likes & matches system (Coming in Session 24)

## Tech Stack

| Category | Package |
|----------|---------|
| Framework | Flutter 3.x |
| State Management | Provider |
| HTTP Client | Dio |
| HTTP Caching | dio_cache_interceptor + Hive |
| WebSocket | web_socket_channel |
| Secure Storage | flutter_secure_storage |
| Local Storage | shared_preferences |
| Image Picker | image_picker |
| Image Caching | cached_network_image + shimmer |
| Environment | flutter_dotenv |
| Google Sign-In | google_sign_in |
| Geolocator | geolocator |

## Requirements

- Flutter SDK 3.0+
- Dart 3.0+
- Backend server running on port 8000

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/iranian-dating-app.git
cd iranian-dating-app/mobile
```

### 2. Get dependencies

```bash
flutter pub get
```

### 3. Configure environment

Create `.env` file in the project root:

```env
API_BASE_URL=http://10.0.2.2:8000/api/v1
WS_BASE_URL=ws://10.0.2.2:8000/api/v1
WEB_CLIENT_ID=your_web_client_id.apps.googleusercontent.com
```

> **Note:** Use `10.0.2.2` for Android emulator. For physical device, use your computer's IP address.

### 4. Run the app

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── config/                   # Configuration files
│   ├── app_constants.dart    # API URLs, keys
│   └── app_theme.dart        # Theme configuration (Light/Dark)
├── models/                   # Data models
│   ├── user.dart             # User model
│   ├── interest.dart         # Interest model
│   ├── prompt.dart           # Prompt model
│   ├── photo.dart            # Photo model
│   └── location_models.dart  # Location models
├── services/                 # API services
│   ├── api_service.dart      # Dio HTTP client with interceptors + Hive cache
│   ├── auth_service.dart     # Auth API calls
│   ├── storage_service.dart  # Secure token storage
│   ├── google_auth_service.dart # Google Sign-In
│   ├── location_service.dart # GPS & Location APIs
│   ├── onboarding_service.dart # Onboarding API calls
│   └── photo_service.dart    # Photo upload & management
├── providers/                # State management
│   ├── auth_provider.dart    # Auth state
│   ├── language_provider.dart # Language selection
│   ├── onboarding_provider.dart # Onboarding state
│   ├── profile_provider.dart # Profile state
│   └── settings_provider.dart # Settings state (dark mode, privacy, notifications)
├── screens/                  # UI screens
│   ├── splash_screen.dart    # Splash screen with progress
│   ├── login_screen.dart     # Login screen
│   ├── main_screen.dart      # Main screen with bottom nav
│   ├── auth/                 # Auth screens
│   │   ├── sign_up_screen.dart
│   │   └── verify_code_screen.dart
│   ├── onboarding/           # Onboarding flow (6 steps)
│   │   ├── basic_info_screen.dart
│   │   ├── profile_details_screen.dart
│   │   ├── interests_screen.dart
│   │   ├── prompts_screen.dart
│   │   └── photo_upload_screen.dart
│   └── profile/              # Profile screens
│       ├── profile_screen.dart
│       ├── avatar_crop_screen.dart
│       ├── edit_basic_info_screen.dart
│       ├── edit_profile_details_screen.dart
│       ├── edit_interests_screen.dart
│       ├── edit_prompts_screen.dart
│       └── settings_screen.dart    # Settings (dark mode, privacy, notifications, language)
├── widgets/                  # Reusable widgets
│   ├── loading_widget.dart
│   ├── progress_bar.dart
│   └── shimmer_avatar.dart   # Shimmer loading placeholder
├── l10n/                     # Localization
│   ├── app_en.arb            # English translations
│   └── app_fa.arb            # Persian translations
├── generated/                # Generated localization files
└── utils/                    # Utilities
    └── validators.dart       # Form validators
```

## Localization & Translation

The app supports English and Persian (Farsi) languages.

### Translation Files

| File | Language | Status |
|------|----------|--------|
| `app_en.arb` | English | ✅ Complete |
| `app_fa.arb` | Persian | 🔄 In Progress |

### How to Add Translations

1. Add new keys to both `app_en.arb` and `app_fa.arb`
2. Run `flutter gen-l10n` to generate localization files
3. Use `AppLocalizations.of(context)!` in widgets

### Current Translation Coverage

| Feature | English | Persian |
|---------|---------|---------|
| Auth Screens | ✅ | 🔄 |
| Onboarding | ✅ | 🔄 |
| Profile Edit | ✅ | 🔄 |
| Edit Screens | 🔄 | 🔄 |
| Error Messages | ✅ | 🔄 |
| Settings | ✅ | ✅ |

## API Integration

The app connects to a FastAPI backend with the following endpoints:

| Endpoint | Method | Description | Status |
|----------|--------|-------------|--------|
| `/auth/register/init` | POST | Request verification code | ✅ |
| `/auth/register/verify` | POST | Verify code & create user | ✅ |
| `/auth/register/complete` | POST | Complete profile | ✅ |
| `/auth/login` | POST | User login | ✅ |
| `/auth/google` | POST | Google Sign-In | ✅ |
| `/auth/refresh` | POST | Refresh access token | ✅ |
| `/auth/logout` | POST | User logout | ✅ |
| `/auth/health` | GET | Health check | ✅ |
| `/users/me` | GET | Get current user | ✅ |
| `/users/me` | PUT | Update profile | ✅ |
| `/users/me/interests` | PUT | Update interests | ✅ |
| `/users/me/prompts` | PUT | Update prompts | ✅ |
| `/users/me/photos` | GET/POST | Photo management | ✅ |
| `/users/me/photos/{id}` | DELETE | Delete photo | ✅ |
| `/users/me/photos/{id}/main` | PUT | Set main photo | ✅ |
| `/users/me/settings` | PUT | Update settings (dark mode, privacy, notifications) | ✅ |
| `/users/me/location` | POST | Update GPS location | ✅ |
| `/users/me/location-text` | PATCH | Update text location | ✅ |
| `/locations/countries` | GET | Get countries | ✅ |
| `/locations/states` | GET | Get states/provinces | ✅ |
| `/locations/cities` | GET | Get cities | ✅ |
| `/locations/reverse-geocode` | GET | Reverse geocode | ✅ |
| `/locations/city-centroid` | GET | Get city centroid | ✅ |
| `/interests` | GET | Get interests | ✅ |
| `/prompts` | GET | Get prompts | ✅ |
| `/discover` | GET | Get card stack | ⬜ |
| `/swipes` | POST | Send like/pass | ⬜ |
| `/matches` | GET | Get matches | ⬜ |
| `/messages` | GET/POST | Chat system | ⬜ |

## Todo List

### High Priority (Session 22)

- [ ] **Complete Persian translations** for all screens
  - [ ] `app_fa.arb` - Auth screens
  - [ ] `app_fa.arb` - Onboarding screens
  - [ ] `app_fa.arb` - Profile screens
  - [ ] `app_fa.arb` - Edit screens
  - [ ] `app_fa.arb` - Photo editing screens
  - [ ] `app_fa.arb` - Error messages
  - [ ] `app_fa.arb` - Settings

### Medium Priority

- [ ] **Discover Screen** - Card swiping UI
- [ ] **Search Screen** - Advanced filters
- [x] **Edit Photos Screen** - Photo management
- [ ] **Face Verification** - Profile picture verification
- [ ] **Premium Subscription** - Purchase flow

### Low Priority

- [ ] **Chat System** - Real-time messaging with WebSocket
- [ ] **Likes & Matches** - Match management
- [ ] **Block User** - Safety features
- [ ] **Push Notifications** - Firebase setup

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `API_BASE_URL` | Backend API URL | `http://10.0.2.2:8000/api/v1` |
| `WS_BASE_URL` | WebSocket URL for chat | `ws://10.0.2.2:8000/api/v1` |
| `WEB_CLIENT_ID` | Google OAuth Client ID | Required for Google Sign-In |

## Error Handling

The app provides user-friendly error messages for common scenarios:

| HTTP Status | User Message |
|-------------|--------------|
| 401 | "Incorrect email or password. Please try again." |
| 404 | "User not found. Please check your email." |
| 409 | "Account already exists. Please login." |
| 422 | "Please check your information and try again." |
| 429 | "Too many attempts. Please wait a moment." |
| Network | "Cannot connect to server. Make sure backend is running." |

## Backend Requirements

Make sure the backend server is running:

```bash
cd backend
uvicorn app.main:app --reload --port 8000
```

Verify connection:

```bash
curl http://localhost:8000/api/v1/auth/health
```

Expected response: `{"status":"healthy","redis":"connected"}`

## Session Progress

| Session | Focus | Status |
|---------|-------|--------|
| 16 | Project Setup & Auth Screens | ✅ |
| 17 | Onboarding Flow (6 Steps) | ✅ |
| 18 | Photo Upload & Profile | ✅ |
| 19 | Location Services | ✅ |
| 20 | Google Sign-In | ✅ |
| 21 | Profile Edit & Account Settings | ✅ |
| 22 | Settings Screen & Dark Mode | ✅ |
| 23 | Localization, Discover Screen & Profile Detail Redesign | ✅ |
| 24 | Discover & Swiping (Swipe Stamps, Interest Icons from Backend) | ✅ |
| 25 | Chat System (Messages + WebSocket) | ⬜ |
| 26 | Likes, Matches & Production | ⬜ |

## Discover Screen Redesign (Session 23-24)

### What changed
- **Gradient pill buttons** — Replace 3 small circles with icon-only circular gradient buttons using theme colors only (primary, error). No text labels, no overflow.
- **Swipe stamps** — NOPE/LIKE stamps appear when dragging card (like Tinder). NOPE = error color, LIKE = primary color.
- **Interest icons from backend** — Fetches `/api/v1/interests` to get emoji icons, displays them before interest names on card and detail screen.
- **Emoji section headers** — Profile detail sections use emoji prefixes: 🔥 About, 💪 Physical, 🏠 Lifestyle, 🌍 Background, 🗣️ Languages, ❤️ Interests, 💬 Prompts.
- **42 ARB keys** — All discover/profile strings localized (EN + FA). All hardcoded English strings replaced.
- **Theme-only colors** — Every color in discover files comes from `AppTheme` light/dark constants. Zero hardcoded `Colors.xxx`.
- **New file:** `lib/widgets/discover_action_button.dart` — Shared circular gradient button widget.
- **New file:** `lib/widgets/user_card.dart` — Swipeable card with stamp overlays and interest chips.
- **New file:** `lib/screens/discover/profile_detail_screen.dart` — Full profile view with emoji sections and gradient action buttons.

### Color rules (strict)
| Element | Color Source |
|---------|-------------|
| Reject (X) / NOPE stamp / Premium badge / Gender female | `lightError` / `darkError` |
| Chat button / LIKE stamp / Verified badge / Gender male | `lightPrimary` / `darkPrimary` |
| Like (Heart) button / Match dialog heart | `lightPrimary` / `darkPrimary` (via `likeGradient`) |
| Message sent checkmark | `lightSuccess` / `darkSuccess` |
| Limit indicator | `lightSuccess` / `lightWarning` |

## Translation Status (Session 22)

| Screen/Messages | English | Persian |
|-----------------|---------|---------|
| Splash Screen | ✅ | 🔄 |
| Login Screen | ✅ | 🔄 |
| Sign Up Screen | ✅ | 🔄 |
| Verify Code Screen | ✅ | 🔄 |
| Basic Info Screen | ✅ | 🔄 |
| Profile Details Screen | ✅ | 🔄 |
| Interests Screen | ✅ | 🔄 |
| Prompts Screen | ✅ | 🔄 |
| Photo Upload Screen | ✅ | 🔄 |
| Profile Screen | ✅ | 🔄 |
| Edit Basic Info Screen | 🔄 | 🔄 |
| Edit Profile Details Screen | 🔄 | 🔄 |
| Edit Interests Screen | 🔄 | 🔄 |
| Edit Prompts Screen | 🔄 | 🔄 |
| Edit Photos Screen | 🔄 | 🔄 |
| Avatar Crop Screen | 🔄 | 🔄 |
| Error Messages | ✅ | 🔄 |
| Validation Messages | ✅ | 🔄 |

## Development

### Run in debug mode

```bash
flutter run
```

### Run with specific flavor

```bash
flutter run --flavor dev
```

### Build APK

```bash
flutter build apk --release
```

### Build App Bundle

```bash
flutter build appbundle --release
```

## Troubleshooting

### Connection refused

Make sure backend is running and `API_BASE_URL` is correct.

### Google Sign-In not working

Make sure `WEB_CLIENT_ID` is set correctly in `.env` and `google-services.json` is configured.

### Packages not downloading

If you have network issues, try:

```bash
flutter pub get --offline
```

### Emulator can't connect to localhost

Use `10.0.2.2` instead of `localhost` in `.env` file.

### Location not working

Make sure location permissions are enabled and GPS is on.

## Contributing

This project is developed by Ehsan (solo developer).

## License

All rights reserved.

## Contact

For questions or support, please open an issue on GitHub.
```

---

## Summary of Changes:

1. **Added Translation Section** - Details localization files and status
2. **Added Todo List** - Including translation tasks
3. **Updated Session Progress** - Added Session 21 (Profile Edit) and Session 22 (Localization)
4. **Added Translation Status Table** - Shows what's translated and what's not
5. **Updated Features** - Added completed features
6. **Updated Tech Stack** - Added Google Sign-In and Geolocator
7. **Updated Project Structure** - Added all new screens
8. **Added Todo List** - Clear priorities for next sessions
9. **Added Settings Screen** - Dark mode, privacy, notifications, language picker
10. **Added SettingsProvider** - State management with API sync + local persistence
11. **Wired Dark Mode** - Dynamic theme switching via MaterialApp themeMode
12. **Updated Translations** - Added 16 new settings-related keys in both EN and FA