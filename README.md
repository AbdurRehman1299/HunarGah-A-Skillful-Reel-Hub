# 📱 Hunargah - A Skillful Reel Hub

Hunargah is a cross-platform mobile application built with Flutter that bridges the gap between modern, fast-paced media and structured education. By utilizing a continuous-scroll vertical video feed (similar to popular social media platforms), Hunargah provides a distraction-free, engaging environment for microlearning and skill acquisition. 

## ✨ Key Features

* **📱 Intelligent Vertical Video Feed:** A high-performance, scrollable feed of short educational videos. Features "visibility detection" to automatically play the visible video and pause others, saving battery and data.
* **🔐 Secure Authentication:** Seamless user registration and login powered by Firebase Authentication.
* **❤️ Interactive Learning:** Users can like, comment, and save their favorite educational videos to their personal library.
* **🧠 Interactive Quizzes:** Built-in quiz dialogs to test user knowledge directly within the app.
* **👨‍🏫 Ustad Profiles:** Dedicated profile screens for content creators/educators to showcase their courses and playlists.
* **🌙 Dynamic Theming:** Full support for both Light and Dark modes, with user preferences saved securely via local storage.
* **⚡ State Management:** Built using GetX for highly reactive, jank-free UI updates and efficient route management.

## 🛠️ Tech Stack

* **Frontend:** Flutter & Dart
* **Backend Framework:** Firebase (Authentication, Cloud Firestore, Cloud Storage)
* **Architecture:** MVVM (Model-View-ViewModel)
* **State Management & Routing:** GetX
* **Local Storage:** Flutter Secure Storage

## 🏗️ System Architecture

Hunargah strictly follows the **MVVM (Model-View-ViewModel)** architectural pattern to ensure a scalable and maintainable codebase:
* **Model:** Dart classes representing real-world data (Users, Videos, Comments) synced with Firebase.
* **View:** "Dumb" Flutter UI components that only handle displaying data and capturing user interactions.
* **ViewModel (GetX Controllers):** The connective tissue that fetches data from Firebase, processes logic, and instantly updates the Views without rebuilding the entire screen.

## 📁 Project Structure (GetX MVVM)

The app strictly follows the MVVM architectural pattern using GetX to ensure scalable and maintainable code.

```text
lib/
├── core/                   # Global constants, app theme, and shared utilities
├── database/               # Firebase services and API calls
├── models/                 # Data Models (e.g., UserModel, Lesson, QuizOption)
├── controllers/            # ViewModels (e.g., UserProfileController, QuizController)
├── views/                  # UI Screens (StatelessWidgets)
│   ├── onboarding/         # Login, Registration, Profile Setup
│   ├── dashboard/          # Main Home Layout
│   ├── course/             # Playlist, Video Player
│   ├── profile/            # User Profile, Edit Profile, Settings
│   └── components/         # Reusable widgets (CustomAppBar, Buttons)
└── main.dart               # App entry point & GetX route definitions
```