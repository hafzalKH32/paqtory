# PAQTORY 🛒📺

A demo Flutter app that combines **live shopping sessions** with a **shared cart** experience.  
Hosts can run live sessions, highlight products in real time, and viewers can add items to their cart while chatting.

---

## ✨ Features

- **Firebase Email/Password login**
- **Live sessions list**
- **Live session screen**
    - Real-time chat (Firestore)
    - Product highlight panel
    - Bottom product carousel
- **Shared cart**
    - Cart state is global (via `CartBloc`)
    - Cart accessible from multiple screens
- **Products listing**
- **Order success screen**

---

## 🧱 Tech Stack

- **Flutter** (Dart)
- **State management**: `flutter_bloc`
- **Backend**: Firebase
    - Authentication
    - Cloud Firestore
- **Architecture**:
    - `Bloc` + `Repository` pattern
    - Feature-based folder structure

---

## 📂 Folder Structure (simplified)

```text
lib/
  data/
    models/
      session_model.dart
      product_model.dart
      message_model.dart
    repository/
      auth_repository.dart
      session_repository.dart
      product_repository.dart

  logic/
    login/
      login_bloc.dart
    session/
      session_bloc.dart
    live/
      live_bloc.dart
    cart/
      cart_bloc.dart
    product/
      product_bloc.dart

  ui/
    login/
      login_screen.dart
    session/
      session_screen.dart        // SessionsScreen
    live/
      live_screen.dart           // LiveSessionScreen
    cart/
      cart_screen.dart
    product/
      product_screen.dart
    success/
      success_screen.dart

  main.dart
```

---

## 🔁 Application Flow

### ➤ App Launch
- App initializes Firebase
- Opens **Login Screen** (`'/'` route)
- If login succeeds → navigate to **SessionsScreen**

### ➤ SessionsScreen (`/sessions`)
- Loads all available live sessions via `SessionsBloc`
- Selecting a session → open `/live` with session arguments

### ➤ LiveSessionScreen (`/live`)
Includes:
- Real-time chat
- Product highlight from Firestore
- Product bottom strip
- Cart icon visible always

Cart shared across screens via `MultiBlocProvider` in `main.dart`:
```dart
MultiBlocProvider( providers: [
    BlocProvider<CartBloc>(create: (_) => CartBloc()),
  ],
);
```

---

## 🚀 Next Steps

1.  **Set up Firebase**:
    - Create a new Firebase project.
    - Set up Firebase Authentication (Email/Password).
    - Set up Cloud Firestore. Make sure your security rules are configured correctly.
    - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the project.

2.  **Run the app**:
    - Run `flutter pub get`
    - Run the app on an emulator or a physical device.

3.  **Explore the code**:
    - Start with `main.dart` to see the routes and providers.
    - Check out `ui/login/login_screen.dart` and `logic/login/login_bloc.dart` to understand the authentication flow.
    - Explore `ui/live/live_screen.dart` to see how the chat, product highlights, and cart are integrated.
  
## App Screenshots
![image alt](https://github.com/hafzalKH32/paqtory/blob/master/screenshots.png?raw=true)
