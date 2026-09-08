import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/psk_theme.dart';
import '../../models/bet_model.dart';
import '../squads/invite_friends_dialog.dart';
import '../casino/slot_game_dialog.dart';
import '../sports/betslip_bottom_sheet.dart';

class MasterDashboardScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const MasterDashboardScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.user;
    final squad = appState.currentSquad;
    final featuredBattle = appState.squadBattles.first;
    final featuredFixture = appState.fixtures.first;

    return Scaffold(
      backgroundColor: PskTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. WELCOME & STUDENT STATUS BANNER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F1B3E), Color(0xFF070B19)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: PskTheme.primaryBlue.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: PskTheme.primaryBlue.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: PskTheme.primaryBlue.withValues(alpha: 0.25),
                      border: Border.all(color: PskTheme.studentShield, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        user.isStudent ? '🐺' : '👤',
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              user.username,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: PskTheme.studentShield.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: PskTheme.studentShield.withValues(alpha: 0.6)),
                              ),
                              child: Text(
                                '18+ VERIFIED',
                                style: GoogleFonts.outfit(
                                  color: PskTheme.studentShield,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.isStudent ? (user.universityName ?? 'University Student') : 'Regular PSK Player',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Wallet Balance Quick View
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'WALLET',
                        style: GoogleFonts.outfit(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        '€${user.balance.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          color: PskTheme.pskGold,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. STUDENT 50% LOSS REFUND SHIELD WIDGET
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    PskTheme.studentShield.withValues(alpha: 0.18),
                    const Color(0xFF0F2636),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: PskTheme.studentShield.withValues(alpha: 0.6)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: PskTheme.studentShield.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.shield, color: PskTheme.studentShield, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'STUDENT 50% LOSS REFUND ACTIVE',
                              style: GoogleFonts.outfit(
                                color: PskTheme.studentShield,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.6,
                              ),
                            ),
                            Text(
                              'Any lost bet, casino spin, or squad match refunds 50% immediately.',
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF070B19),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: PskTheme.studentShield.withValues(alpha: 0.4)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'TOTAL SAVED',
                              style: GoogleFonts.outfit(
                                color: Colors.white60,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '€${user.totalLossRefunded.toStringAsFixed(2)}',
                              style: GoogleFonts.outfit(
                                color: PskTheme.studentShield,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. SQUADS CO-OP COMMAND CENTER (2X DOUBLE WIN & INVITE FRIENDS)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PskTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: PskTheme.pskGold.withValues(alpha: 0.6)),
                boxShadow: [
                  BoxShadow(
                    color: PskTheme.pskGold.withValues(alpha: 0.1),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(squad.avatarIcon, style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                squad.name,
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '${squad.membersCount} Campus Members • ${squad.universityAffiliation}',
                                style: GoogleFonts.inter(
                                  color: Colors.white60,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // INVITE BUTTON
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => const InviteFriendsDialog(),
                          );
                        },
                        icon: const Icon(Icons.person_add, size: 14, color: Color(0xFF070B19)),
                        label: Text(
                          'INVITE',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF070B19),
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PskTheme.pskGold,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),

                  const Divider(color: Colors.white10, height: 24),

                  // Battle Match Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF070B19),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: PskTheme.pskGold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '⚔️ LIVE CLASH',
                                style: GoogleFonts.outfit(
                                  color: PskTheme.pskGold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: PskTheme.successGreen.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '2× DOUBLE PAYOUT: €${featuredBattle.doubleWinPayout.toStringAsFixed(0)}',
                                style: GoogleFonts.outfit(
                                  color: PskTheme.successGreen,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${featuredBattle.teamA.name} vs ${featuredBattle.teamB.name}',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Entry: €${featuredBattle.entryStakePerPlayer.toStringAsFixed(0)}/player • ${featuredBattle.gameMode}',
                          style: GoogleFonts.inter(
                            color: Colors.white60,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  final entered = appState.enterSquadBattle(featuredBattle.battleId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: entered ? PskTheme.successGreen : PskTheme.dangerRed,
                                      content: Text(
                                        entered ? '🐺 Entered battle with €10 entry stake!' : 'Insufficient balance!',
                                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: PskTheme.pskGold),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                child: Text(
                                  'ENTER (€10)',
                                  style: GoogleFonts.outfit(
                                    color: PskTheme.pskGold,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  final res = appState.claimSquadBattleResult(featuredBattle.battleId, userTeamWon: true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: PskTheme.successGreen,
                                      content: Text(
                                        '🏆 VICTORY! Double Win €${res['payout']} paid to wallet!',
                                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PskTheme.successGreen,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                child: Text(
                                  'SIMULATE WIN (2×)',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. FEATURED DERBY ODDS & BETSLIP INTEGRATION
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PskTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.sports_soccer, color: PskTheme.pskGold, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'FEATURED DERBY MATCH',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: PskTheme.dangerRed.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'LIVE 64\'',
                          style: GoogleFonts.outfit(
                            color: PskTheme.dangerRed,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${featuredFixture.homeTeam} vs ${featuredFixture.awayTeam}',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    featuredFixture.league,
                    style: GoogleFonts.inter(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Odds Buttons
                  Row(
                    children: [
                      _buildQuickOdds(
                        context,
                        appState,
                        featuredFixture,
                        '1 (${featuredFixture.homeTeam})',
                        featuredFixture.oddsHome,
                      ),
                      const SizedBox(width: 8),
                      _buildQuickOdds(
                        context,
                        appState,
                        featuredFixture,
                        'X (Draw)',
                        featuredFixture.oddsDraw,
                      ),
                      const SizedBox(width: 8),
                      _buildQuickOdds(
                        context,
                        appState,
                        featuredFixture,
                        '2 (${featuredFixture.awayTeam})',
                        featuredFixture.oddsAway,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 5. CASINO QUICK LAUNCHER & SLOTS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF26123D), Color(0xFF130924)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF9D4EDD).withValues(alpha: 0.6)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9D4EDD).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.casino, color: Color(0xFFE0AAFF), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CASINO JACKPOT: €48,290.45',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFE0AAFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Sizzling Hot Deluxe • 50% Refund on Losses',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => const SlotGameDialog(
                          gameTitle: 'Sizzling Hot Deluxe',
                          provider: 'Novomatic / Greentube',
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9D4EDD),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: Text(
                      'SPIN',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 6. RESPONSIBLE GAMING & REGULATION FOOTER
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF070B19),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user, color: Colors.white38, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '18+ Odgovorno klađenje • Zakon o igrama na sreću • GDPR Art. 25 Privacy by Design',
                      style: GoogleFonts.inter(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickOdds(
    BuildContext context,
    AppState appState,
    SportFixture fixture,
    String label,
    double odds,
  ) {
    final isSelected = appState.isSelected(fixture.id, label);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          appState.toggleSelection(
            BetSelection(
              fixtureId: fixture.id,
              fixtureName: '${fixture.homeTeam} vs ${fixture.awayTeam}',
              league: fixture.league,
              marketName: '1X2',
              selectionName: label,
              odds: odds,
            ),
          );
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => const BetslipBottomSheet(),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? PskTheme.pskGold : const Color(0xFF070B19),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? PskTheme.pskGold : Colors.white24,
            ),
          ),
          child: Column(
            children: [
              Text(
                label.split(' ').first,
                style: GoogleFonts.outfit(
                  color: isSelected ? const Color(0xFF070B19) : Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                odds.toStringAsFixed(2),
                style: GoogleFonts.outfit(
                  color: isSelected ? const Color(0xFF070B19) : PskTheme.pskGold,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
