## `README.md` برای پروژه Flutter

```markdown
# Iranian Dating App - Flutter Mobile Client

Flutter mobile client for Iranian dating app (Badoo-style).

## Features

- ✅ User Authentication (Register, Login)
- ✅ Secure token storage with flutter_secure_storage
- ✅ Environment configuration via .env
- ✅ Clean architecture with Provider state management
- ⬜ Discover card swiping (Coming in Session 17)
- ⬜ Search with filters (Coming in Session 18)
- ⬜ Profile management & photo upload (Coming in Session 18)
- ⬜ Real-time chat with WebSocket (Coming in Session 19)
- ⬜ Likes & matches system (Coming in Session 20)
- ⬜ Block users (Coming in Session 21)

## Tech Stack

| Category | Package |
|----------|---------|
| Framework | Flutter 3.x |
| State Management | Provider |
| HTTP Client | Dio |
| WebSocket | web_socket_channel |
| Secure Storage | flutter_secure_storage |
| Local Storage | shared_preferences |
| Image Picker | image_picker |
| Image Caching | cached_network_image |
| Environment | flutter_dotenv |

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
│   ├── app_colors.dart       # Color palette
│   ├── app_constants.dart    # API URLs, keys
│   └── app_theme.dart        # Theme configuration
├── models/                   # Data models
│   └── user.dart             # User model
├── services/                 # API services
│   ├── api_service.dart      # Dio HTTP client
│   ├── auth_service.dart     # Auth API calls
│   └── storage_service.dart  # Secure token storage
├── providers/                # State management
│   └── auth_provider.dart    # Auth state
├── screens/                  # UI screens
│   ├── splash_screen.dart    # Splash screen
│   ├── welcome_screen.dart   # Welcome screen
│   ├── login_screen.dart     # Login screen
│   ├── register_screen.dart  # Register screen
│   └── main_screen.dart      # Main screen (placeholder)
├── widgets/                  # Reusable widgets
│   └── loading_widget.dart   # Loading indicator
└── utils/                    # Utilities
    └── validators.dart       # Form validators
```

## API Integration

The app connects to a FastAPI backend with the following endpoints:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/auth/register` | POST | User registration |
| `/auth/login` | POST | User login |
| `/auth/refresh` | POST | Refresh access token |
| `/auth/logout` | POST | User logout |
| `/users/me` | GET | Get current user profile |
| `/users/me` | PUT | Update user profile |
| `/discover` | GET | Get card stack for swiping |
| `/swipes` | POST | Send like/pass |
| `/matches` | GET | Get matches list |
| `/messages/{match_id}` | GET | Get chat history |
| `/messages/{match_id}/text` | POST | Send text message |
| `/search` | GET | Search users with filters |
| `/blocks/{user_id}/block` | POST | Block user |
| `/blocks` | GET | List blocked users |

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `API_BASE_URL` | Backend API URL | `http://10.0.2.2:8000/api/v1` |
| `WS_BASE_URL` | WebSocket URL for chat | `ws://10.0.2.2:8000/api/v1` |

## Error Handling

The app provides user-friendly error messages for common scenarios:

| HTTP Status | User Message |
|-------------|--------------|
| 401 | "Incorrect email or password. Please try again." |
| 404 | "User not found. Please check your email." |
| 409 | "Account already exists. Please login." |
| 422 | "Please check your information and try again." |
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
| 17 | Main Layout & Discover Screen | ⬜ |
| 18 | Search & Profile Screens | ⬜ |
| 19 | Chat System (Messages + WebSocket) | ⬜ |
| 20 | Likes & Matches Tabs | ⬜ |
| 21 | Block & Safety Features | ⬜ |
| 22 | Polish & Production | ⬜ |

## Development

### Run in debug mode

```bash
flutter run
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

### Packages not downloading

If you have network issues, try:

```bash
flutter pub get --offline
```

### Emulator can't connect to localhost

Use `10.0.2.2` instead of `localhost` in `.env` file.

## Contributing

This project is developed by Ehsan (solo developer).

## License

All rights reserved.

## Contact

For questions or support, please open an issue on GitHub.
```

---

## `.gitignore` برای پروژه Flutter

```gitignore
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# VS Code related
.vscode/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Android related
**/android/**/gradle-wrapper.jar
**/android/.gradle
**/android/captures/
**/android/gradlew
**/android/gradlew.bat
**/android/local.properties
**/android/**/GeneratedPluginRegistrant.java

# iOS/Xcode related
**/ios/**/*.mode1v3
**/ios/**/*.mode2v3
**/ios/**/*.moved-aside
**/ios/**/*.pbxuser
**/ios/**/*.perspectivev3
**/ios/**/*sync/
**/ios/**/.sconsign.dblite
**/ios/**/.tags*
**/ios/**/build
**/ios/**/DerivedData/
**/ios/**/Flutter/App.framework
**/ios/**/Flutter/Flutter.framework
**/ios/**/Flutter/Flutter.podspec
**/ios/**/Flutter/Generated.xcconfig
**/ios/**/Flutter/ephemeral/
**/ios/**/Flutter/app.flx
**/ios/**/Flutter/app.zip
**/ios/**/Flutter/flutter_assets/
**/ios/**/Flutter/flutter_export_environment.sh
**/ios/**/ServiceDefinitions.json
**/ios/**/Runner/GeneratedPluginRegistrant.*

# Environment
.env
.env.production

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Exceptions to above rules
!**/ios/**/default.mode1v3
!**/ios/**/default.mode2v3
!**/ios/**/default.pbxuser
!**/ios/**/default.perspectivev3

# End of https://www.toptal.com/developers/gitignore/api/flutter
```

---

حالا این فایل‌ها رو توی پروژه فلترت بذار و commit کن.