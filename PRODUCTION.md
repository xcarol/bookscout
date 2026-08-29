# BookScout - Production Checklist

This document outlines the steps required to transition BookScout from a development/testing environment to a fully public production release on the Google Play Store.

## 1. Google Play Console & SHA-1
- [ ] **Upload first App Bundle (.aab)**: Upload your first release build to the Internal Testing track. This triggers Google Play to generate the official App Signing Key.
- [ ] **Obtain Production SHA-1**: Go to **Play Console > Release > Setup > App integrity** (or **App signing**) and copy the **SHA-1 certificate fingerprint** of the App signing key certificate.

## 2. Firebase Configuration
- [ ] **Add Production SHA-1**: Go to **Firebase Console > Project Settings > General**. Under your Android app, click **Add fingerprint** and paste the Production SHA-1.
- [ ] **Update `google-services.json`**: Re-download the `google-services.json` file and place it in `app/android/app/` before building the final production `.aab`. (Això assegura que Firebase reconegui els usuaris que es descarreguen l'app des de la botiga).

## 3. Google Cloud Console (OAuth & Verification)
- [ ] **Create Production OAuth Client**: If Firebase didn't do it automatically, go to **GCP > APIs & Services > Credentials** and create a new Android OAuth Client ID using your new Production SHA-1.
- [ ] **Verify Ownership**: Now that the app is in the Play Console, you can click the **Verify ownership** button on your OAuth Client ID.
- [ ] **Publish OAuth Consent Screen**:
  - Go to **APIs & Services > OAuth consent screen**.
  - Click **Publish App** to move it from "Testing" to "In production".
  - **Verification Process**: Com que BookScout utilitza un *scope* sensible (`.../auth/drive.file`), hauràs de passar el procés de verificació de Google. Et demanaran pujar un vídeo a YouTube demostrant com l'app utilitza Google Drive exclusivament per fer *backups* de l'usuari.

## 4. Privacy Policy & Legal
- [ ] **Create a Privacy Policy**: Write a privacy policy explaining that the app accesses Google Drive solely to backup the user's local database into their own account, and that no personal data is collected or sent to third-party servers.
- [ ] **Host the Policy**: Host this document on a public URL (e.g., GitHub Pages, un web personal, etc.).
- [ ] **Link it**: Add the Privacy Policy URL to both the Google Play Console (App Content section) and the Google Cloud OAuth Consent Screen.

## 5. Security Restrictions
- [ ] **Restrict API Keys**: Go to **GCP > APIs & Services > Credentials**. Edit your `GOOGLE_BOOKS_API_KEY` (and any other auto-generated Android API keys) and configure the **Application restrictions**. Assign them to your Android package name (`com.xicra.bookscout`) and add both your Debug and Production SHA-1 fingerprints perquè ningú més pugui fer servir la teva quota gratuïta.
