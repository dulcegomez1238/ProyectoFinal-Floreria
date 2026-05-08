# Florist Management Application (Florería)

This document outlines the plan to create a cross-platform (Android, Web, Windows) florist management application using Flutter and Firebase.

## Goal Description
Build a complete Flutter application for managing a florist shop. The app will feature a modern, attractive UI, Firebase Authentication (Email, Password, Google Sign-in), and Cloud Firestore integration for a "Florería" CRUD.

## User Review Required
> [!IMPORTANT]
> **Firebase Configuration**: I can write all the necessary code, but to physically connect the app to your specific Firebase project (`floreria`), you will need to run the `flutterfire configure` command on your machine since it requires you to be authenticated with your Google account in the Firebase CLI. I will provide the steps for this, but please confirm if you are okay with doing this step yourself!

> [!NOTE]
> **UI and Styling**: The app will use `google_fonts` for modern typography and use a clean, vibrant color palette suited for a florist (e.g., greens and floral colors).

## Open Questions
1. Do you already have the Firebase CLI installed and are logged into your Google account on your terminal?
2. Do you have a specific color scheme in mind, or can I choose a modern green/pink botanical theme?

## Proposed Changes

### Project Initialization & Configuration
- Run `flutter create --platforms android,web,windows .` in `c:\floreria`.
- Add dependencies to `pubspec.yaml`:
  - `firebase_core`
  - `firebase_auth`
  - `cloud_firestore`
  - `google_sign_in`
  - `provider` (for state management)
  - `google_fonts` (for modern typography)

### Models
#### [NEW] lib/models/usuario_model.dart
Data model representing the User entity.
#### [NEW] lib/models/floreria_model.dart
Data model representing the Floreria entity (e.g., id, name, location, contact, createdAt).

### Services
#### [NEW] lib/services/auth_service.dart
Handles Firebase Authentication:
- Login with Email/Password
- Registration
- Password Reset (Forgot Password)
- Google Sign-In
#### [NEW] lib/services/firestore_service.dart
Handles Cloud Firestore CRUD operations:
- Add a new Floreria
- List Florerias (real-time stream)
- Update a Floreria
- Delete a Floreria

### Screens (UI)
#### [NEW] lib/screens/login_screen.dart
Modern login screen with options to sign in, register, reset password, and Google Sign-In.
#### [NEW] lib/screens/register_screen.dart
Screen to create a new account.
#### [NEW] lib/screens/home_screen.dart
Main dashboard displaying the list of Florerias, utilizing modern cards and lists.
#### [NEW] lib/screens/floreria_form_screen.dart
Screen to add or update Floreria details.

### Main App
#### [MODIFY] lib/main.dart
Initializes Firebase, sets up Providers, configures the theme, and handles authentication state (directing to Login or Home based on the user's status).

## Verification Plan

### Automated Tests
- N/A for this initial setup, relying on manual verification of CRUD.

### Manual Verification
1. Open the app on Windows, Web, or Android.
2. Attempt to register a new user.
3. Log out and log in again.
4. Try Google Sign-In.
5. Create a new "Floreria" record.
6. Verify it appears in the list.
7. Edit the record and verify changes.
8. Delete the record.
