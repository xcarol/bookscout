# BookScout Development Guide

This document contains technical information and setup instructions for developing and building the BookScout application.

## Google Books API Key Setup

BookScout uses the Google Books API to search for books. To ensure the app functions correctly both locally and when published, follow these instructions to set up your API Key.

### 1. Enable the API
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Select your project.
3. Navigate to **APIs & Services > Library**.
4. Search for **Books API** and click **Enable**.

### 2. Create the API Key
1. Navigate to **APIs & Services > Credentials**.
2. Click **Create Credentials > API key**.
3. Copy the generated API key.

### 3. Configure API Key Restrictions (Crucial)
Since we are calling the Google Books API via REST (HTTP `GET`) from a Flutter app, standard "Android apps" restrictions will **not** work automatically (the API won't know the app's package name or certificate). Instead, we must use **HTTP Referrers**.

1. In the API Key settings page, under **Application restrictions**, select **Websites (HTTP referrers)**.
2. Under **Website restrictions**, click **ADD**.
3. Enter the following referrer exact URL (or wildcard):
   `https://com.xicra.bookscout/*`
4. Click **Save**.

*Note: The Flutter code (`lib/services/api/google_books_service.dart`) is configured to send the `Referer: https://com.xicra.bookscout/` header in every request to validate this restriction.*

### 4. Configure `.env` for Local Development
1. Create a `.env` file in the root directory of the project (if it doesn't exist).
2. Add your API key to the file:
   ```env
   GOOGLE_BOOKS_API_KEY=your_api_key_here
   ```
3. Do **not** commit the `.env` file to version control (it should be in `.gitignore`).

### 5. Configure GitHub Actions Secrets
For CI/CD to build the app with the API key, you must inject the `.env` file during the GitHub Actions workflow.

1. Go to your repository on GitHub.
2. Navigate to **Settings > Secrets and variables > Actions**.
3. Click **New repository secret**.
4. Name the secret: `ENV_FILE`
5. Set the value to the contents of your `.env` file:
   ```env
   GOOGLE_BOOKS_API_KEY=your_api_key_here
   ```
6. The GitHub Actions workflow (e.g., `.github/workflows/android-build-publish.yml`) will automatically read this secret and recreate the `.env` file before compiling the app bundle.
