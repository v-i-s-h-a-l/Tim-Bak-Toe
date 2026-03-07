# App Store Submission Checklist — Tim-Bak-Toe (XO3)

## Pre-Submission (You)

### GitHub Pages Setup
- [ ] Push the `docs/privacy-policy.html` to your repo
- [ ] Enable GitHub Pages (Settings → Pages → Source: Deploy from branch, `/docs` folder)
- [ ] Verify privacy policy loads at: `https://v-i-s-h-a-l.github.io/Tim-Bak-Toe/privacy-policy.html`
- [ ] Update the URL in metadata if your GitHub username/repo differs

### Screenshots
- [ ] Capture 5 screenshots on iPhone 15 Pro Max simulator (6.7" — 1290×2796)
- [ ] Capture 5 screenshots on iPad Pro 12.9" simulator (2048×2732)
- [ ] See `screenshot-guide.md` for which screens to capture

### Build
- [ ] Archive the app (Product → Archive)
- [ ] Upload to App Store Connect (Organizer → Distribute → App Store Connect)

---

## App Store Connect Setup

### App Record (if not created yet)
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. My Apps → + → New App
3. Fill in:
   - **Platforms**: iOS
   - **Name**: Tim-Bak-Toe
   - **Primary Language**: English (U.S.)
   - **Bundle ID**: indie.bulty.XO3
   - **SKU**: XO3-2026

### App Information Tab
- [ ] **Subtitle**: `3 Pieces. 5 Seconds. No Draws.`
- [ ] **Category**: Games → Board
- [ ] **Secondary Category**: Games → Strategy
- [ ] **Content Rights**: "This app does not contain, show, or access third-party content"
- [ ] **Age Rating**: Fill questionnaire (all answers "None" → results in 4+)

### Pricing and Availability
- [ ] **Price**: Free
- [ ] **Availability**: All territories

### App Privacy
- [ ] Click "Get Started" under App Privacy
- [ ] Select **"No, we do not collect data from this app"**
- [ ] Save

### Version Page (iOS 2.0)
- [ ] **Screenshots**: Upload for iPhone 6.7" and iPad 12.9"
- [ ] **Promotional Text**: Copy from `app-store-metadata.md`
- [ ] **Description**: Copy from `app-store-metadata.md`
- [ ] **Keywords**: `tic-tac-toe,tictactoe,board game,strategy,puzzle,multiplayer,xo,noughts,crosses,brain,3 pieces`
- [ ] **Support URL**: `https://github.com/v-i-s-h-a-l/Tim-Bak-Toe`
- [ ] **Marketing URL**: `https://v-i-s-h-a-l.github.io/Tim-Bak-Toe/`
- [ ] **Privacy Policy URL**: `https://v-i-s-h-a-l.github.io/Tim-Bak-Toe/privacy-policy.html`
- [ ] **Build**: Select the uploaded build
- [ ] **What's New**: `Tim-Bak-Toe 2.0 — completely rebuilt with a fresh design, smoother animations, and online multiplayer via Game Center.`

### Review Information
- [ ] **Contact Info**: Your name, email, phone
- [ ] **Notes**: `This is a tic-tac-toe game with a unique mechanic: each player gets exactly 3 pieces. After all pieces are placed, players relocate existing pieces. Uses Apple Game Center for online multiplayer. No IAP. No ads. No data collection.`
- [ ] **Sign-In Required**: No

### Final
- [ ] Click **"Add for Review"**
- [ ] Click **"Submit to App Review"**

---

## Common Rejection Reasons to Avoid

1. **Privacy Policy URL not loading** — Make sure GitHub Pages is live before submitting
2. **Broken Game Center** — Test that matchmaking actually works on a real device (not just simulator)
3. **Missing screenshot sizes** — 6.7" iPhone is mandatory
4. **Crash on launch** — Test on a real device, not just simulator
5. **Metadata mismatch** — Make sure the app name in the binary matches what's in App Store Connect
