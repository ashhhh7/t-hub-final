# PSK Student & Youth Innovation Hub 🏆🎓

> **T-Hub Final Submission** — Inspired by [PSK.hr (Prva Sportska Kladionica)](https://www.psk.hr/), tailored for university students and young adult sports fans with built-in financial safety nets and social gaming mechanics.

---

## 🌟 Overview & Core Innovations

This project introduces a next-generation platform for youth sports and gaming engagement, compliant with Croatian and EU gambling regulations (18+ age verification, responsible gambling limits, and GDPR Art. 25 data privacy).

### 1. 🛡️ Student 50% Loss Refund Guarantee
- **The Problem**: University students and young adults often face volatility and financial risk when participating in sports betting and gaming.
- **The Innovation**: A built-in student safety net. When a verified university student incurs a loss on sports tickets, casino spins, or team squad battles, **50% of the invested amount is automatically refunded** back to their wallet balance immediately.
- **Interactive Celebration**: Features animated celebration modals displaying exact refund amounts and updated wallet balances.

### 2. 🐺 Squad Battles: Team vs Team Co-op Arena (2× Double Win)
- Campus students team up into university squads:
  - 🐺 **Zagreb Wolves** (University of Zagreb)
  - ⚡ **Split Titans** (University of Split)
  - 🦅 **Rijeka Eagles** (University of Rijeka)
  - 🎮 **Osijek Cyberpunks** (University of Osijek)
- Squads enter head-to-head match prediction clashes and slot tournaments.
- **2× Double Win Payout**: Members pool entry stakes (e.g. €10/player), and winning squad members receive **double their payout (€20)** directly credited to their balance.

### 3. 🤝 Deep Squads: Friend Invitation & Team Joining
- **"Invite Friends to Team"**: One-touch invitation modal accessible directly from the Squads arena.
- **Campus Mates Directory**: Browse online campus friends (*Marko_FER*, *Ana_Ekonomija*, *Luka_PMF*, *Marta_FSB*) or enter any custom student handle (`@username`).
- **Interactive Friend Request Receipt**: When an invite is dispatched, friends receive a prompt:
  > *"Hey [Friend], [User] invited you to join Zagreb Wolves 🐺!"*
- **Accept & Join**: When the friend accepts, they are immediately added to the live team roster, updating team counts and player lists with online badges and captain designations.
- **Sent & Incoming Invites Manager**: Live status tracking (`PENDING`, `ACCEPTED`, `DECLINED`) and cross-team invitation handling.

### 4. ⚽ Sportsbook & Interactive Betslip
- Real fixture data inspired by the FEG Hackathon dataset:
  - Dinamo Zagreb vs Hajduk Split (Live Croatian Super Derby)
  - Feyenoord vs Go Ahead Eagles
  - Lecce vs AS Roma
  - ATP Cincinnati Masters
- Live multi-selection betslip with automatic Student Shield loss-protection indicators and instant simulation tools.

### 5. 🎰 Casino Lobby & Interactive Slot Machine
- Features top provider games: *Sizzling Hot Deluxe*, *Sugar Rush 1000*, *40 Super Hot Bell Link*.
- Playable 3-reel slot machine with customizable stakes (€1, €2, €5, €10), progressive jackpot (€48,290+), and automatic 50% loss refund on non-winning spins for students.

---

## 🏗️ Repository Structure

```
├── .gitignore                   # Ignores large raw datasets, build artifacts, IDE files
├── README.md                    # Project documentation & architecture overview
├── data/                        # Dataset schemas & analysis (raw CSVs ignored via .gitignore)
│   ├── dataset_comprehensive_analysis.json
│   └── FEG Innovation Hackaton 2026 - EU regulations guide.pdf
└── frontend/                    # Complete Flutter Application
    ├── lib/
    │   ├── main.dart            # Entry point & shell navigation
    │   ├── models/
    │   │   ├── bet_model.dart   # Fixtures, odds, tickets, and betslip models
    │   │   ├── casino_game.dart # Slot games and casino catalog
    │   │   ├── squad_model.dart # Squads, members, invites, and campus friends
    │   │   └── user_model.dart  # User profile, student status, and wallet balance
    │   ├── screens/
    │   │   ├── auth/            # Login and student card verification
    │   │   ├── casino/          # Casino lobby and interactive slot machine
    │   │   ├── profile/         # Student Vault & transaction history
    │   │   ├── sports/          # Sportsbook feed and betslip bottom sheet
    │   │   └── squads/          # Squad battles & friend invitation dialog
    │   ├── state/
    │   │   └── app_state.dart   # Central reactive state management (Provider)
    │   └── theme/
    │       └── psk_theme.dart   # Bespoke PSK brand design system
    ├── test/
    │   └── widget_test.dart     # Comprehensive test suites (100% pass)
    ├── web/                     # Web deployment assets & index.html
    └── pubspec.yaml             # Flutter dependencies & config
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x or later)
- [Google Chrome](https://www.google.com/chrome/) or mobile emulator/device

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ashhhh7/t-hub-final.git
   cd t-hub-final
   ```

2. **Navigate to the frontend directory:**
   ```bash
   cd frontend
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the application:**
   ```bash
   # Run on Chrome Web
   flutter run -d chrome

   # Or run on connected Android/iOS device
   flutter run
   ```

---

## 🧪 Automated Testing

Run all unit and widget tests:
```bash
cd frontend
flutter test
```

All 4 test suites pass cleanly:
- ✅ **Login Screen Rendering**
- ✅ **Student 50% Loss Refund Safety Net Calculation**
- ✅ **Squad Battle 2× Double Win Payout**
- ✅ **Friend Invite & Squad Team Roster Join**

---

## ⚖️ Compliance & Responsible Gaming

- **18+ Age Gate**: Strictly enforced verification prior to placing any bets or entering matches.
- **Croatian Act on Games of Chance (*Zakon o igrama na sreću*)**: Compliant with certified RNG limits and identity checks.
- **EU GDPR Art. 25**: Data protection by design for all student verification credentials.
