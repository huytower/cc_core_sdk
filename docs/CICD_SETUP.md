# CI/CD Setup Guide

This guide explains how to set up CI/CD for building and distributing AAB files to Firebase App Distribution using GitHub Actions.

## Overview

The CI/CD pipeline automatically:
- Builds Android App Bundle (AAB) for different flavors (free, uat, prod)
- Signs the AAB with your release keystore
- Uploads the AAB to Firebase App Distribution for testing

## Prerequisites

1. **GitHub Repository** with Actions enabled
2. **Firebase Project** with App Distribution configured
3. **Android Keystore** for signing release builds

## Required GitHub Secrets

Configure these secrets in your GitHub repository settings (`Settings > Secrets and variables > Actions`):

### Android Signing Secrets

| Secret Name | Description | How to Generate |
|-------------|-------------|-----------------|
| `KEYSTORE_BASE64` | Base64-encoded keystore file | `base64 -i your-keystore.jks \| pbcopy` (Mac) or `base64 -w 0 your-keystore.jks` (Linux) |
| `KEYSTORE_PASSWORD` | Password for the keystore | Set when creating keystore |
| `KEY_PASSWORD` | Password for the key | Set when creating keystore |
| `KEY_ALIAS` | Alias of the key in keystore | Set when creating keystore |

### Firebase App Distribution Secrets

| Secret Name | Description | How to Generate |
|-------------|-------------|-----------------|
| `FIREBASE_APP_ID` | Your Firebase App ID | Found in Firebase Console > Project Settings > General |
| `FIREBASE_SERVICE_CREDENTIALS` | Firebase service account JSON | See Firebase Service Account Setup below |
| `FIREBASE_TESTER_GROUPS` | Comma-separated tester groups | Create groups in Firebase App Distribution |

## Setup Steps

### 1. Create Android Keystore

If you don't have a keystore, create one:

```bash
keytool -genkey -v -keystore ~/keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias your-alias
```

Remember to:
- Store the keystore file securely
- Remember all passwords (keystore password and key password)
- Note the key alias

### 2. Encode Keystore to Base64

**On Mac/Linux:**
```bash
base64 -i your-keystore.jks | pbcopy
```

**On Windows (PowerShell):**
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("your-keystore.jks")) | Set-Clipboard
```

### 3. Setup Firebase App Distribution

#### a. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing one
3. Add an Android app with your package name:
   - `mobile.template` (prod)
   - `mobile.template.uat` (uat)
   - `mobile.template.free` (free)

#### b. Get Firebase App ID

1. Go to Project Settings > General
2. Scroll to "Your apps" section
3. Find your Android app and copy the App ID (format: `1:123456789:android:abcdef`)

#### c. Create Service Account

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Navigate to IAM & Admin > Service Accounts
4. Click "Create Service Account"
5. Grant the following roles:
   - Firebase App Distribution Admin
   - (Optional) Firebase Viewer
6. Create and download the JSON key file
7. Copy the entire content of the JSON file

#### d. Create Tester Groups

1. Go to Firebase Console > App Distribution
2. Create tester groups (e.g., `internal-testers`, `beta-testers`)
3. Add testers to groups via email

### 4. Add Secrets to GitHub

1. Go to your GitHub repository
2. Navigate to `Settings > Secrets and variables > Actions`
3. Click "New repository secret"
4. Add each secret from the tables above

### 5. Configure Local Signing (Optional)

For local release builds, create `android/key.properties`:

```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=keystore.jks
```

Place your keystore file at `android/app/keystore.jks`

Add `android/key.properties` to `.gitignore` (it should already be there).

## Workflow Triggers

The GitHub Actions workflow triggers on:

1. **Push to main branch** - Builds and deploys `uat` flavor by default
2. **Pull requests to main** - Builds `free` flavor for testing (no deployment)
3. **Manual dispatch** - Choose any flavor (free, uat, prod) to build and deploy

### Manual Deployment

To manually deploy a specific flavor:

1. Go to GitHub Actions tab
2. Select "Build and Distribute AAB to Firebase App Distribution"
3. Click "Run workflow"
4. Choose the flavor you want to build
5. Click "Run workflow"

## Workflow Features

- **Automatic flavor detection**: Uses `uat` by default, or chosen flavor in manual dispatch
- **Artifact retention**: AAB files are kept as GitHub artifacts for 30 days
- **Security**: Keystore is cleaned up after the build
- **Release notes**: Automatically includes commit SHA, branch, and build number
- **Pull request handling**: Builds but doesn't deploy for PRs

## Build Output

The AAB file will be at:
```
build/app/outputs/bundle/{FLAVOR}Release/app-{FLAVOR}-release.aab
```

Flavors:
- `free`: `build/app/outputs/bundle/freeRelease/app-free-release.aab`
- `uat`: `build/app/outputs/bundle/uatRelease/app-uat-release.aab`
- `prod`: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`

## Troubleshooting

### Build fails with signing errors

- Verify all secrets are correctly set
- Check that `KEYSTORE_BASE64` is properly encoded
- Ensure passwords match your keystore credentials

### Firebase App Distribution fails

- Verify `FIREBASE_APP_ID` is correct
- Check that service account has proper permissions
- Ensure `FIREBASE_SERVICE_CREDENTIALS` is valid JSON
- Verify tester groups exist in Firebase Console

### Local build issues

- Ensure `android/key.properties` exists for local builds
- Verify keystore file path in `key.properties`
- Check that local.properties contains Flutter version info

### Flutter version mismatch

The workflow uses Flutter 3.24.5. To change:
- Update `FLUTTER_VERSION` in `.github/workflows/firebase-app-distribution.yml`

## Security Best Practices

1. **Never commit keystore files** to the repository
2. **Rotate credentials** periodically
3. **Limit access** to service accounts
4. **Use different keys** for different environments
5. **Monitor Firebase App Distribution** access logs

## Next Steps

After setup:

1. Test the workflow by manually triggering it
2. Verify the AAB appears in Firebase App Distribution
3. Invite testers to your configured groups
4. Set up branch protection rules if needed
5. Consider adding automated testing to the workflow

## Additional Resources

- [Firebase App Distribution Documentation](https://firebase.google.com/docs/app-distribution)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Android App Bundle Guide](https://developer.android.com/guide/app-bundle)
- [Flutter Build Documentation](https://docs.flutter.dev/deployment/android)