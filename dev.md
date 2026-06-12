## `mobile_dev.md` - Flutter Dating App (Updated Session 16)

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
7. [Session 17: Main Layout & Discover Screen](#7-session-17-main-layout--discover-screen)
8. [Session 18: Search & Profile Screens](#8-session-18-search--profile-screens)
9. [Session 19: Chat System (Messages + WebSocket)](#9-session-19-chat-system-messages--websocket)
10. [Session 20: Likes & Matches Tabs](#10-session-20-likes--matches-tabs)
11. [Session 21: Block & Safety Features](#11-session-21-block--safety-features)
12. [Session 22: Polish & Production](#12-session-22-polish--production)
13. [UI Mockups](#13-ui-mockups-badoo-inspired)

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
| Flutter project setup | ✅ |
| Dependencies installed | ✅ |
| Folder structure created | ✅ |
| Environment variables (.env) | ✅ |
| API Service (Dio) | ✅ |
| Auth Service (login, register) | ✅ |
| Storage Service (secure token storage) | ✅ |
| Auth Provider (state management) | ✅ |
| Splash Screen | ✅ |
| Welcome Screen | ✅ |
| Login Screen | ✅ |
| Register Screen | ✅ |
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
│   └── auth_provider.dart       # Auth state management
├── screens/
│   ├── splash_screen.dart       # Splash screen
│   ├── welcome_screen.dart      # Welcome screen
│   ├── login_screen.dart        # Login screen
│   ├── register_screen.dart     # Register screen
│   └── main_screen.dart         # Main screen (placeholder)
├── widgets/
│   └── loading_widget.dart      # Loading indicator
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

### Authentication Flow

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

### Error Handling

| HTTP Status | User Message |
|-------------|--------------|
| 401 | "Incorrect email or password. Please try again." |
| 404 | "User not found. Please check your email." |
| 409 | "Account already exists. Please login." |
| 422 | "Please check your information and try again." |
| Network | "Cannot connect to server. Make sure backend is running." |

### Files Created (Session 16)

| File | Lines | Description |
|------|-------|-------------|
| `lib/main.dart` | 50 | App entry point, MultiProvider |
| `lib/config/app_colors.dart` | 60 | Color definitions |
| `lib/config/app_theme.dart` | 70 | Theme configuration |
| `lib/config/app_constants.dart` | 30 | Constants from .env |
| `lib/models/user.dart` | 50 | User model |
| `lib/services/api_service.dart` | 80 | HTTP client with Dio |
| `lib/services/auth_service.dart` | 60 | Auth API calls |
| `lib/services/storage_service.dart` | 50 | Secure token storage |
| `lib/providers/auth_provider.dart` | 180 | Auth state management |
| `lib/screens/splash_screen.dart` | 50 | Splash screen |
| `lib/screens/welcome_screen.dart` | 80 | Welcome screen |
| `lib/screens/login_screen.dart` | 150 | Login form |
| `lib/screens/register_screen.dart` | 200 | Register form |
| `lib/screens/main_screen.dart` | 50 | Main screen (placeholder) |
| `lib/widgets/loading_widget.dart` | 30 | Loading indicator |
| `lib/utils/validators.dart` | 40 | Form validation |

---

## 7. Session 17: Main Layout & Discover Screen

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
| `lib/screens/main_screen.dart` | Bottom nav shell, tab switching |
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

### Implementation Details

```dart
// Card swipe using flutter_tinder_swipe
TinderSwipeCard(
  card: ProfileCard(user: user),
  onSwipedLeft: () => onPass(user),
  onSwipedRight: () => onLike(user),
)

// Match animation overlay
if (matched) {
  showMatchDialog(context, matchedUser);
}
```

### Tests Checklist

- [ ] Bottom navigation switches between 4 tabs
- [ ] Discover loads card stack from API
- [ ] Swipe right calls like API
- [ ] Swipe left calls pass API
- [ ] Match detection works
- [ ] Match animation shows
- [ ] "No more profiles" state shows when stack empty

---

## 8. Session 18: Search & Profile Screens

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

### API Endpoints to Connect

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/search` | GET | Search users with filters |
| `/users/me` | GET | Get own profile |
| `/users/me` | PUT | Update own profile |
| `/users/me/photos` | POST | Upload photo |
| `/users/me/photos/{id}` | DELETE | Delete photo |
| `/users/me/photos/{id}/main` | PUT | Set main photo |
| `/users/{user_id}` | GET | Get other user's profile |

### Search Filters

| Filter | Type | Default |
|--------|------|---------|
| age_min | int | 18 |
| age_max | int | 100 |
| distance_km | int | null |
| gender | string | null |
| province | string | null |
| city | string | null |
| has_photos | bool | null |
| is_verified | bool | null |

### Tests Checklist

- [ ] Search returns results based on filters
- [ ] Province/city filters work
- [ ] Profile screen shows user info
- [ ] Edit profile updates data
- [ ] Photo upload works
- [ ] Set main photo works
- [ ] Delete photo works

---

## 9. Session 19: Chat System (Messages + WebSocket)

### Goals
- Chats list screen
- Chat detail screen with real-time messaging
- WebSocket connection per chat
- Message bubbles (sent / received)
- Unread message indicators

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

### API Endpoints to Connect

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/matches` | GET | Get matches list |
| `/messages/{match_id}` | GET | Get chat history |
| `/messages/{match_id}/text` | POST | Send text message |
| `/messages/{match_id}/photo` | POST | Send photo message |
| `/messages/{match_id}/voice` | POST | Send voice message |
| `/messages/{match_id}/accept` | POST | Accept chat request |
| `/messages/read` | POST | Mark as read |
| `/messages/delivered` | POST | Mark as delivered |

### WebSocket Connection

```dart
// Connect to chat
ws://localhost:8000/api/v1/ws/chat/{match_id}?token={access_token}

// Send message
channel.sink.add(jsonEncode({'content': message}));

// Receive message
channel.stream.listen((message) {
  // Handle incoming message
});
```

### Tests Checklist

- [ ] Chats list shows all matches
- [ ] Last message preview shows
- [ ] Tap chat opens detail screen
- [ ] Messages load with pagination
- [ ] Send text message via WebSocket
- [ ] Receive messages in real-time
- [ ] Message status (sent/delivered/read)
- [ ] Unread message counter

---

## 10. Session 20: Likes & Matches Tabs

### Goals
- Messages tab (active chats) ✅ from Session 19
- Likes Sent tab (profiles you liked)
- Likes Received tab (premium — who liked you)
- MatchProvider for state

### Files to Create

| File | Description |
|------|-------------|
| `lib/screens/chats_screen.dart` | Updated with 3-tab structure |
| `lib/widgets/messages_tab.dart` | Matched users list |
| `lib/widgets/likes_sent_tab.dart` | Profiles I liked |
| `lib/widgets/likes_received_tab.dart` | Profiles who liked me (premium gate) |
| `lib/providers/match_provider.dart` | Fetch matches + likes state |
| `lib/services/like_service.dart` | Get likes sent/received API calls |

### Tab Structure

```
Chats Screen
├── Tab 1 — Messages   → GET /matches
├── Tab 2 — Likes Sent → GET /likes/sent
└── Tab 3 — Likes Received → GET /likes/received (premium only)
```

### Premium Gate for Likes Received

```dart
if (!isPremium) {
  return PremiumRequiredWidget(
    message: "Upgrade to premium to see who liked you",
  );
}
```

### Tests Checklist

- [ ] Messages tab shows matches
- [ ] Likes Sent tab shows profiles user liked
- [ ] Likes Received tab shows premium gate for free users
- [ ] Likes Received tab shows list for premium users

---

## 11. Session 21: Block & Safety Features

### Goals
- Block a user from their profile
- Block a user from Discover via long-press
- Unblock from Blocked Users settings screen
- BlockProvider managing state

### Backend Endpoints (already live)

| Action | Method | Endpoint |
|--------|--------|----------|
| Block | POST | `/api/v1/blocks/{user_id}/block` |
| Unblock | POST | `/api/v1/blocks/{user_id}/unblock` |
| List blocked | GET | `/api/v1/blocks` |

### Files to Create

| File | Description |
|------|-------------|
| `lib/models/blocked_user.dart` | BlockedUser model |
| `lib/services/block_service.dart` | blockUser(), unblockUser(), getBlockedUsers() |
| `lib/providers/block_provider.dart` | blockedIds set, block/unblock actions |
| `lib/screens/blocked_users_screen.dart` | Settings screen — list with Unblock button |
| `lib/widgets/block_action_button.dart` | Reusable Block/Unblock button |

### Where Block Is Accessible

| Location | How to Trigger |
|----------|---------------|
| Profile screen (other user) | Tap ⋮ menu → "Block User" |
| Discover card | Long-press card → bottom sheet → "Block" |
| Chat detail screen | Tap ⋮ menu → "Block User" |
| Settings screen | "Blocked Users" list item |

### Block Flow

1. User taps Block
2. Confirmation dialog: "Block [Name]? They won't be able to message you or appear in your Discover."
3. User confirms → POST to block endpoint
4. On success:
   - BlockProvider adds userId to blockedIds
   - DiscoverProvider removes card from stack
   - If in chat: input disabled, banner shown
5. Snackbar: "User blocked"

### Chat Behaviour After Block

```
┌──────────────────────────────────┐
│  ⚠️  You have blocked this user.  │
│     Unblock to send messages.    │
└──────────────────────────────────┘
```

---

## 12. Session 22: Polish & Production

### Goals
- Hero animations for profile images
- Staggered list animations
- Shimmer / skeleton loaders
- Network error handling + retry
- Offline indicator
- Build APK + App Bundle

### Tasks

1. **Animations**
   - Hero animations on profile photos
   - Staggered list animations
   - Smooth page transitions

2. **Loading States**
   - Shimmer effect on Discover cards
   - Skeleton loaders on search results
   - Loading indicators on chat list

3. **Error Handling**
   - Global Dio interceptor for errors
   - Retry logic for failed requests
   - Offline banner when no connection

4. **Build**

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (Google Play)
flutter build appbundle --release
```

---

## 13. UI Mockups (Badoo-inspired)

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
├─────────────────────────────┤
│  ○ User Name      1 hour ago│
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
│  Stats: 150 likes, 45 chats │
│  ┌──────────────────────┐   │
│  │   Edit Profile       │   │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │   Get Premium        │   │
│  └──────────────────────┘   │
└─────────────────────────────┘
```

### Blocked Users Screen
```
┌─────────────────────────────┐
│  ←  Blocked Users           │
├─────────────────────────────┤
│  ○ Username         Unblock │
├─────────────────────────────┤
│  ○ Username         Unblock │
├─────────────────────────────┤
│  ○ Username         Unblock │
└─────────────────────────────┘
```

---

## Next Session

**Session 17: Main Layout & Discover Screen**

Ready to start Session 17 when you are. 🚀
```