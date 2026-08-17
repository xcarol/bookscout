# BookScout Development Guide

This document contains technical information and setup instructions for developing and building the BookScout application.

## Project Structure

BookScout is split into two main components:
- `app/`: The Flutter frontend client.
- `backend/`: The Node.js Backend-for-Frontend (BFF) which handles search orchestration, caching, and rate limiting by communicating with Google Books, Open Library, and Firestore.

---

## 1. Local Development Setup

To run the full stack locally, you need to start the backend server and then the Flutter app.

### Backend Setup
1. Navigate to the `backend/` directory: `cd backend`
2. Install dependencies: `npm install`
3. Create a `.env` file in the `backend/` directory (see API Key & Firebase setup below).
4. Start the server: `npm start` (Runs on port 8080 by default).

### Frontend Setup
1. Navigate to the `app/` directory: `cd app`
2. Fetch dependencies: `flutter pub get`
3. Run the app: `flutter run`

---

## 2. API Keys and Credentials

### Google Books API Key
BookScout uses the Google Books API for search. The API key is managed securely by the backend.

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Enable the **Books API** under **APIs & Services > Library**.
3. Create an API key under **APIs & Services > Credentials**.
4. **Configure Restrictions**: 
   - Under **Application restrictions**, select **None**.
   *(Note: Since the API key is now securely stored in the Node.js backend and not shipped with the mobile app, we no longer need HTTP Referrer restrictions.)*
5. Add the key to `backend/.env`:
   ```env
   GOOGLE_BOOKS_API_KEY=your_api_key_here
   ```

### Firebase Admin SDK (Firestore Cache)
The backend uses Firestore to cache full book metadata.

1. Go to the [Firebase Console](https://console.firebase.google.com/) and select your project.
2. Navigate to **Project Settings** (the gear icon) > **Service Accounts**.
3. Click **Generate new private key** to download the Firebase Admin SDK Service Account key (JSON format).
2. Place the JSON file in the `backend/` directory (e.g., `bookscout-firebase-adminsdk.json`). Do not commit this to source control.
3. Add the credential path to `backend/.env`:
   ```env
   GOOGLE_APPLICATION_CREDENTIALS=./bookscout-firebase-adminsdk.json
   ```

*Note: If the Firebase credentials are not provided, the backend will gracefully skip the Firestore cache and query external APIs directly.*

---

## 3. Configure GitHub Actions Secrets
For CI/CD workflows to build the backend or frontend with necessary keys, inject the `.env` file during the GitHub Actions workflow.

1. Go to your repository on GitHub.
2. Navigate to **Settings > Secrets and variables > Actions**.
3. Click **New repository secret**.
4. Name the secret: `ENV_FILE`
5. Set the value to the contents of your backend `.env` file:
   ```env
   GOOGLE_BOOKS_API_KEY=your_api_key_here
   GOOGLE_APPLICATION_CREDENTIALS=./bookscout-firebase-adminsdk.json
   ```
6. Your deployment workflow will automatically read this secret and recreate the `.env` file for the backend.
