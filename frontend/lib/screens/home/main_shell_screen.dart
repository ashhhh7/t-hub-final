import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/psk_theme.dart';
import '../../widgets/student_shield_pill.dart';
import '../dashboard/master_dashboard_screen.dart';
import '../sports/sports_feed_screen.dart';
import '../casino/casino_lobby_screen.dart';
import '../squads/squad_battles_screen.dart';
import '../profile/student_vault_screen.dart';
import '../profile/wallet_history_screen.dart';
import '../auth/login_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    MasterDashboardScreen(onNavigateTab: (idx) => setState(() => _currentIndex = idx)),
    const SportsFeedScreen(),
    const CasinoLobbyScreen(),
    const SquadBattlesScreen(),
    const StudentVaultScreen(),
    const WalletHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.user;

    return Scaffold(
      backgroundColor: PskTheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: PskTheme.surface.withOpacity(0.98),
          elevation: 0,
          titleSpacing: 14,
          title: Row(
            children: [
              // PSK Logo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: PskTheme.pskGold,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'PSK',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF070B19),
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Student Shield Pill
              const StudentShieldPill(),
            ],
          ),
          actions: [
            // Live Wallet Balance Button
            GestureDetector(
              onTap: () => setState(() => _currentIndex = 5),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: PskTheme.surfaceHighlight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: PskTheme.pskGold.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_balance_wallet, color: PskTheme.pskGold, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '€${user.balance.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Logout / Switch User
            IconButton(
              icon: const Icon(Icons.logout, size: 18, color: Colors.white60),
              tooltip: 'Switch User Profile',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (c) => const LoginScreen()),
                );
              },
            ),
            const SizedBox(width: 4),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: PskTheme.surfaceHighlight.withOpacity(0.5), height: 1),
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: PskTheme.surface,
          border: Border(top: BorderSide(color: PskTheme.surfaceHighlight.withOpacity(0.8), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: PskTheme.pskGold,
          unselectedItemColor: PskTheme.textMuted,
          selectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 10),
          unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 9.5),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer),
              label: 'Sports',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.casino),
              label: 'Casino',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.groups),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: PskTheme.dangerRed,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                    ),
                  ),
                ],
              ),
              label: 'Squads 2×',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.school,
                color: user.isStudent ? PskTheme.studentShield : null,
              ),
              label: 'Student 50%',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
          ],
        ),
      ),
    );
  }
}
