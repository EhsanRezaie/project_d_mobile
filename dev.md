باشه سلطان. فایل `dev.md` رو آپدیت میکنم با تغییراتی که انجام دادیم.

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
6. [Completed Features (Session 16)](#6-completed-features-session-16)
7. [Onboarding Flow (Session 16.5)](#7-onboarding-flow-session-165)
8. [Session 17: Main Layout & Discover Screen](#8-session-17-main-layout--discover-screen)
9. [Session 18: Search & Profile Screens](#9-session-18-search--profile-screens)
10. [Session 19: Chat System (Messages + WebSocket)](#10-session-19-chat-system-messages--websocket)
11. [Session 20: Likes & Matches Tabs](#11-session-20-likes--matches-tabs)
12. [Session 21: Block & Safety Features](#12-session-21-block--safety-features)
13. [Session 22: Polish & Production](#13-session-22-polish--production)
14. [UI Mockups](#14-ui-mockups-badoo-inspired)

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
| **Session 16** | ✅ COMPLETED |
| **Session 16.5 (Onboarding Fix)** | ✅ COMPLETED |
| Flutter project setup | ✅ |
| Dependencies installed | ✅ |
| Folder structure created | ✅ |
| Environment variables (.env) | ✅ |
| API Service (Dio) | ✅ |
| Auth Service (login, register) | ✅ |
| Storage Service (secure token storage) | ✅ |
| Auth Provider (state management) | ✅ |
| Onboarding Provider (complete) | ✅ |
| Splash Screen | ✅ |
| Welcome Screen | ✅ |
| Login Screen | ✅ |
| EmailPasswordScreen (new) | ✅ |
| NameAgeScreen (with registration) | ✅ |
| HeightWeightScreen | ✅ |
| PhotoScreen | ✅ |
| LocationScreen | ✅ |
| MainScreen (placeholder) | ✅ |
| Onboarding progress bar | ✅ |
| Error handling (user-friendly messages) | ✅ |
| Navigation between auth screens | ✅ |

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
│   └── onboarding_provider.dart # Onboarding data + API submit
├── screens/
│   ├── splash_screen.dart       # Splash screen
│   ├── welcome_screen.dart      # Welcome screen
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
```

---

## 6. Completed Features (Session 16)

### Authentication Flow (Basic)

```
Splash Screen (2 sec)
    ↓
Check token in secure storage
    ↓
If token exists → Main Screen
If no token → Welcome Screen
    ↓
Login / Register
    ↓
On success → Save token → Main Screen
On error → Show user-friendly error message
```

### API Integration

| Endpoint | Method | Status |
|----------|--------|--------|
| `/auth/register` | POST | ✅ |
| `/auth/login` | POST | ✅ |
| `/auth/refresh` | POST | ⬜ |
| `/auth/logout` | POST | ⬜ |

---

## 7. Onboarding Flow (Session 16.5)

### Fixed Navigation Flow

```
Welcome Screen (Login / Create Account)
    ↓ (Create Account)
EmailPasswordScreen (No progress bar)
    ↓
NameAgeScreen (Progress 1/4) ← Registration API call here
    ↓
HeightWeightScreen (Progress 2/4)
    ↓
PhotoScreen (Progress 3/4)
    ↓
LocationScreen (Progress 4/4) ← Submit all data
    ↓
MainScreen
```

### Onboarding Screens Detail

| Screen | Progress Bar | Fields Collected | API Call |
|--------|--------------|-----------------|----------|
| EmailPasswordScreen | ❌ | email, password | ❌ |
| NameAgeScreen | 1/4 | name, age, gender, referralCode | ✅ register() |
| HeightWeightScreen | 2/4 | height, weight | ❌ |
| PhotoScreen | 3/4 | photos (optional/skip) | ❌ |
| LocationScreen | 4/4 | gps, province, city | ✅ submitAllData() |

### OnboardingProvider Methods

| Method | Description |
|--------|-------------|
| `saveEmailAndPassword()` | Store temp email/password |
| `updateUserInfo()` | Store name, age, gender, etc. |
| `updatePhysicalInfo()` | Store height, weight |
| `updateLocation()` | Store GPS or manual location |
| `submitAllData()` | Send all collected data to backend |
| `getAllData()` | Return all data as Map |
| `clearAll()` | Reset all stored data |

### Fixed Files (Session 16.5)

| File | Fix Applied |
|------|-------------|
| `welcome_screen.dart` | Create Account button → EmailPasswordScreen |
| `login_screen.dart` | Create Account button → EmailPasswordScreen |
| `height_weight_screen.dart` | Navigation → PhotoScreen (not HomeScreen) |
| `photo_screen.dart` | Added ProgressBar (step 3/4) |
| `location_screen.dart` | Navigation → MainScreen, added validation |
| `onboarding_provider.dart` | Added updateLocation(), submitAllData(), getAllData() |

---

## 8. Session 17: Main Layout & Discover Screen

### Goals
- Bottom navigation bar with 4 tabs
- Discover screen with swipeable profile cards
- Like / Pass / Super Like actions wired to API
- DiscoverProvider managing card stack state
- Real match animation when both users like each other

### Files to Create

| File | Description |
|------|-------------|
| `lib/models/profile.dart` | Profile model for discover |
| `lib/screens/main_screen.dart` | Bottom nav shell, tab switching (placeholder exists) |
| `lib/screens/discover_screen.dart` | Card stack, action buttons |
| `lib/widgets/profile_card.dart` | Profile photo, name, age, bio card |
| `lib/providers/discover_provider.dart` | Fetch users, track swipe state |
| `lib/services/discover_service.dart` | Get users, post like/pass |

### API Endpoints to Connect

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/discover` | GET | Get card stack |
| `/swipes` | POST | Send like/pass |
| `/swipes/stats` | GET | Get remaining likes |

---

## 9. Session 18: Search & Profile Screens

### Goals
- Search screen with age / location / gender filters
- View any user's profile
- Own profile screen
- Edit profile + photo upload

### Files to Create

| File | Description |
|------|-------------|
| `lib/screens/search_screen.dart` | Search input + filter chips + results grid |
| `lib/screens/profile_screen.dart` | User profile view (own + others) |
| `lib/screens/edit_profile_screen.dart` | Edit bio, age, photos |
| `lib/widgets/filter_chip.dart` | Reusable filter chip widget |
| `lib/providers/search_provider.dart` | Search state management |
| `lib/providers/profile_provider.dart` | Profile state |
| `lib/services/search_service.dart` | Search API calls |
| `lib/services/profile_service.dart` | Profile API calls |
| `lib/utils/image_picker_helper.dart` | Camera / gallery picker |

---

## 10. Session 19: Chat System (Messages + WebSocket)

### Goals
- Chats list screen
- Chat detail screen with real-time messaging
- WebSocket connection per chat

### Files to Create

| File | Description |
|------|-------------|
| `lib/screens/chats_screen.dart` | Chat list (matches with last message) |
| `lib/screens/chat_detail_screen.dart` | Full conversation screen |
| `lib/services/websocket_service.dart` | Connect, send, receive, disconnect |
| `lib/providers/chat_provider.dart` | Message state, unread counts |
| `lib/widgets/chat_bubble.dart` | Sent/received bubble with timestamp |
| `lib/models/message.dart` | Message model |
| `lib/models/match.dart` | Match model |

---

## 11. Session 20: Likes & Matches Tabs

### Goals
- Messages tab (active chats)
- Likes Sent tab (profiles you liked)
- Likes Received tab (premium — who liked you)

### Tab Structure

```
Chats Screen
├── Tab 1 — Messages   → GET /matches
├── Tab 2 — Likes Sent → GET /likes/sent
└── Tab 3 — Likes Received → GET /likes/received (premium only)
```

---

## 12. Session 21: Block & Safety Features

### Goals
- Block a user from their profile
- Block a user from Discover via long-press
- Unblock from Blocked Users settings screen

### Backend Endpoints

| Action | Method | Endpoint |
|--------|--------|----------|
| Block | POST | `/api/v1/blocks/{user_id}/block` |
| Unblock | POST | `/api/v1/blocks/{user_id}/unblock` |
| List blocked | GET | `/api/v1/blocks` |

### Where Block Is Accessible

| Location | How to Trigger |
|----------|---------------|
| Profile screen (other user) | Tap ⋮ menu → "Block User" |
| Discover card | Long-press card → bottom sheet → "Block" |
| Chat detail screen | Tap ⋮ menu → "Block User" |
| Settings screen | "Blocked Users" list item |

---

## 13. Session 22: Polish & Production

### Goals
- Hero animations for profile images
- Shimmer / skeleton loaders
- Network error handling + retry
- Offline indicator
- Build APK + App Bundle

### Build Commands

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (Google Play)
flutter build appbundle --release
```

---

## 14. UI Mockups (Badoo-inspired)

### Discover Screen
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

### Chats Screen (3 tabs)
```
┌─────────────────────────────┐
│  ←  Chats                   │
├─────────────────────────────┤
│ ┌──────────┬──────────┬────┐│
│ │ Messages │Likes Sent│Likes││
│ └──────────┴──────────┴────┘│
├─────────────────────────────┤
│  ○ User Name       2 min ago│
│    Last message preview      │
└─────────────────────────────┘
```

### Profile Screen
```
┌─────────────────────────────┐
│  ←  Profile          ✏️  ⋮  │
├─────────────────────────────┤
│         ┌───────┐           │
│         │ Photo │           │
│         └───────┘           │
│        Name, Age            │
│        Location             │
│  ┌──────────────────────┐   │
│  │ Bio text here...      │   │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │   Edit Profile       │   │
│  └──────────────────────┘   │
└─────────────────────────────┘
```

---

## Next Session

**Session 17: Main Layout & Discover Screen**

Ready to start Session 17 when you are. 🚀
```

## خلاصه تغییرات اعمال شده در dev.md:

1. **Current Status** - اضافه شدن Session 16.5 و Onboarding Fix
2. **Project Structure** - آپدیت با فایل‌های جدید onboarding و widgets
3. **Onboarding Flow (Section 7)** - اضافه شدن کامل
   - جدول screens با progress bar و API calls
   - OnboardingProvider متدها
   - فایل‌های fixed شده
4. **Session 17 و بعدش** - شماره‌ها تغییر کردند

کامیت برای این تغییر:

```bash
git add dev.md
git commit -m "docs: update dev.md with onboarding flow changes (Session 16.5)

- Add complete onboarding flow documentation
- Add EmailPasswordScreen as step 0
- Document all 5 onboarding screens with progress bar steps
- Add OnboardingProvider methods reference
- List all fixed files from Session 16.5
- Update project structure with new files"
```