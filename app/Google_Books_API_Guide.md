# Google Books API Setup & Key Restriction Guide for Android

A concise guide on enabling the Google Books API, retrieving your Debug and
Production SHA-1 fingerprints, and securing your API Key.

---

## Step 1: Enable the Google Books API

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Select your existing project (or create a new one).
3. Navigate to **APIs & Services** > **Library**.
4. Search for **Google Books API**, click on it, and select **Enable**.

---

## Step 2: Retrieve Your Debug SHA-1 Fingerprint

To test the API during local development, retrieve the SHA-1 fingerprint of
your local debug keystore:

Run the following command in your terminal:

```bash
keytool -list -v \
  -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android
```

Look for the `SHA1` line under the `Variant: debug` section and copy the
fingerprint value.

---

## Step 3: Retrieve Your Production SHA-1 Fingerprint

Google Play App Signing manages your production release key.

> **Prerequisite:** Upload at least one `.aab` (Android App Bundle) to any
> release track (e.g., *Internal Testing*) so Google Play can generate the app
> signing certificate.

1. Log in to the [Google Play Console](https://play.google.com/console).
2. Select your application.
3. In the left menu, navigate to **Protected with Play** (*Protegit amb Play*).
4. Click on **Play Store protection** (*Protecció de Play Store*).
5. Under **Protect your app signing key** (*Protegeix la clau de signatura
   d'aplicacions*), locate the **App signing key certificate**.
6. Copy the **SHA-1 fingerprint**.

---

## Step 4: Create and Restrict the API Key

1. Go back to [Google Cloud Console](https://console.cloud.google.com/) >
   **APIs & Services** > **Credentials**.
2. Click **Create Credentials** at the top and select **API key**.
3. Click on the newly generated API key to open its settings.

### 4.1. Set Application Restrictions (Android)

1. Under **Application restrictions**, select **Android apps**.
2. Click **Add an item**:
   * **Package name:** Enter the app's package name (`com.xicra.bookscout`).
   * **SHA-1 fingerprint:** Paste the **Debug SHA-1 fingerprint**.
3. Click **Add an item** again:
   * **Package name:** Enter the same package name (`com.xicra.bookscout`).
   * **SHA-1 fingerprint:** Paste the **Production SHA-1 fingerprint** (from
     Play Console).

### 4.2. Set API Restrictions

1. Under **API restrictions**, choose **Restrict key**.
2. Select **Google Books API** from the dropdown list.
3. Click **Save**.

> ⏱️ **Note:** It can take between 5 to 10 minutes for newly saved
> restrictions to take effect globally.
