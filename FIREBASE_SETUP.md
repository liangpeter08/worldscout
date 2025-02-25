# Firebase and Firestore Setup Guide

## Prerequisites
- Flutter SDK installed
- Firebase account
- Firebase CLI installed

## Step 1: Create a Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter "worldscout" as the project name
4. Enable Google Analytics if desired
5. Click "Create project"

## Step 2: Register Your App with Firebase
### For Android:
1. In Firebase Console, click the Android icon
2. Enter package name: `com.example.worldscout`
3. Enter app nickname: "WorldScout"
4. Download the `google-services.json` file
5. Place it in the `android/app` directory

### For iOS:
1. In Firebase Console, click the iOS icon
2. Enter Bundle ID: `com.example.worldscout`
3. Enter app nickname: "WorldScout"
4. Download the `GoogleService-Info.plist` file
5. Place it in the `ios/Runner` directory

### For Web:
1. In Firebase Console, click the Web icon
2. Register app with nickname "WorldScout"
3. Copy the Firebase configuration

## Step 3: Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

## Step 4: Configure Your Flutter App
```bash
flutterfire configure --project=worldscout-9d813
```

## Step 5: Enable Authentication Methods
1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Enable "Email/Password" authentication
4. Save changes

## Step 6: Create Firestore Database
1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Start in production mode
4. Choose a location closest to your users
5. Click "Enable"

## Step 7: Set Up Firestore Security Rules
1. In Firebase Console, go to "Firestore Database"
2. Click "Rules" tab
3. Replace with the following rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User profiles
    match /users/{userId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Posts
    match /posts/{postId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
          request.auth.uid == resource.data.userId;
    }
    
    // Likes
    match /likes/{likeId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Saved posts
    match /saved_posts/{savedId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
          request.auth.uid == request