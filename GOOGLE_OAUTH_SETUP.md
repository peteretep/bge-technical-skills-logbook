# Google OAuth Setup Instructions

This guide will help you complete the Google OAuth authentication setup for the Skills Logbook application.

## Prerequisites

The application has been configured with Google OAuth support. You just need to obtain and configure your Google credentials.

## Step 1: Create Google OAuth Credentials

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing project
3. Navigate to **APIs & Services** > **Credentials**
4. Click **+ CREATE CREDENTIALS** > **OAuth 2.0 Client ID**
5. If prompted, configure the OAuth consent screen:
   - Choose **External** user type
   - Fill in the required fields (app name, user support email, developer contact)
   - Add scopes: `email` and `profile`
   - Add test users if in testing mode
6. Create OAuth 2.0 Client ID:
   - Application type: **Web application**
   - Name: Skills Logbook (or your preferred name)
   - Authorized redirect URIs:
     - For development: `http://localhost:3000/users/auth/google_oauth2/callback`
     - For production: `https://yourdomain.com/users/auth/google_oauth2/callback`
7. Click **Create** and save your credentials

## Step 2: Configure Environment Variables

1. Create a `.env` file in the project root (if it doesn't exist):
   ```bash
   touch .env
   ```

2. Add your Google credentials to the `.env` file:
   ```
   GOOGLE_CLIENT_ID=your_actual_client_id_here
   GOOGLE_CLIENT_SECRET=your_actual_client_secret_here
   ```

3. The `.env` file is already in `.gitignore`, so your credentials won't be committed to git

## Step 3: Restart the Rails Server

After adding the environment variables, restart your Rails server:

```bash
rails server
```

## Testing

1. Navigate to the login page: `http://localhost:3000/users/sign_in`
2. You should see a "Sign in with Google" button
3. Click it and authenticate with your Google account
4. You should be redirected back to the application and logged in

## Troubleshooting

### Error: "redirect_uri_mismatch"
- Make sure the redirect URI in Google Cloud Console exactly matches: `http://localhost:3000/users/auth/google_oauth2/callback`
- Check for trailing slashes or http vs https

### Error: "Access blocked: This app's request is invalid"
- Make sure you've configured the OAuth consent screen
- Add your email as a test user if the app is in testing mode

### Environment variables not loading
- Make sure you've restarted the Rails server after creating/updating the `.env` file
- Verify the `.env` file is in the project root directory

## Production Deployment

For production deployment, you'll need to:

1. Update the authorized redirect URI in Google Cloud Console to use your production domain
2. Set the environment variables on your hosting platform (not in a `.env` file)
3. Move your app out of "Testing" mode in the OAuth consent screen (or keep it in testing and add authorized users)

## Features

- Users can sign in with their Google account
- School name is automatically extracted from email domain
- Password is not required for OAuth users
- Users can still use traditional email/password authentication
