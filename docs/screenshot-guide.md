# App Store Screenshot Guide — Tim-Bak-Toe

## Required Sizes

You need screenshots for **two iPhone sizes** and **one iPad size** minimum:

| Device Class | Size (pixels) | Simulator to Use |
|---|---|---|
| iPhone 6.7" | 1290 × 2796 | iPhone 15 Pro Max or iPhone 16 Pro Max |
| iPhone 6.5" | 1284 × 2778 | iPhone 15 Plus or iPhone 14 Pro Max |
| iPad 12.9" (6th gen) | 2048 × 2732 | iPad Pro 12.9-inch (6th generation) |

The 6.7" set is required. The 6.5" can reuse the same images if you check "Use 6.7-inch Display screenshots" in App Store Connect. Same logic applies to iPad — one size covers all.

You can upload **up to 10 screenshots** per device class. Minimum is 3. I'd recommend 5.

---

## Screenshots to Capture (in order)

### 1. Home Screen
**What to show**: The main menu with the XO3 logo and game mode buttons visible.
**Why**: First impression — shows branding and that there are multiple modes.
**Tip**: Light mode looks cleaner for App Store.

### 2. Gameplay — Placement Phase (mid-game)
**What to show**: A game in progress with 2-3 pieces already placed per side, one piece being dragged. Timer bar visible and partially filled.
**Setup**: Start a Local game. Place a few pieces. Take screenshot mid-drag if possible, or just with pieces on the board.
**Why**: Shows the core mechanic and the timer pressure.

### 3. Gameplay — Relocation Phase
**What to show**: All 6 pieces on the board (3 per player), showing that the board isn't full and pieces can be moved.
**Setup**: Keep playing until all pieces are placed. Capture the state where it's clear pieces need to be relocated.
**Why**: This is the unique mechanic — the "twist" that differentiates from regular tic-tac-toe.

### 4. Win State
**What to show**: The winner overlay with confetti animation and the "You Win" message.
**Setup**: Win a game and screenshot the overlay.
**Why**: Shows polish and celebration.

### 5. AI Difficulty Selection / Game Mode Picker
**What to show**: The game mode picker with difficulty levels visible.
**Setup**: Navigate to the mode selection showing Easy/Medium/Hard.
**Why**: Shows the AI feature and replayability.

---

## How to Take Screenshots in Simulator

1. Run the app on the correct simulator device
2. Navigate to the screen you want
3. **Cmd+S** in Simulator to save screenshot (saves to Desktop)
4. Or: **File → Save Screen** in Simulator menu

For iPad, run on iPad Pro 12.9-inch simulator and take the same 5 screens.

---

## Screenshot Naming Convention

Name them for easy upload:

```
screenshots/
├── iphone67/
│   ├── 01-home.png
│   ├── 02-gameplay-placement.png
│   ├── 03-gameplay-relocation.png
│   ├── 04-win.png
│   └── 05-mode-picker.png
├── iphone65/
│   └── (same names, or reuse 6.7")
└── ipad129/
    ├── 01-home.png
    ├── 02-gameplay-placement.png
    ├── 03-gameplay-relocation.png
    ├── 04-win.png
    └── 05-mode-picker.png
```

## Notes

- Use **light mode** for all screenshots (cleaner on the App Store white background)
- Make sure the status bar shows a good time (like 9:41 — Apple's canonical time). Simulator usually handles this.
- If you want marketing frames (text above device mockup), let me know and I'll generate those templates for you after you have the raw screenshots.
