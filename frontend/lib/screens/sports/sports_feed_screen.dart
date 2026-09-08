import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/psk_theme.dart';
import '../../models/bet_model.dart';
import '../../widgets/live_odds_button.dart';
import 'betslip_bottom_sheet.dart';

class SportsFeedScreen extends StatefulWidget {
  const SportsFeedScreen({super.key});

  @override
  State<SportsFeedScreen> createState() => _SportsFeedScreenState();
}

class _SportsFeedScreenState extends State<SportsFeedScreen> {
  String _selectedSport = 'ALL';

  final List<Map<String, String>> _categories = [
    {'key': 'ALL', 'label': '🔥 All Sports'},
    {'key': 'Football', 'label': '⚽ Football'},
    {'key': 'Tennis', 'label': '🎾 Tennis'},
    {'key': 'Basketball', 'label': '🏀 Basketball'},
    {'key': 'Lottery', 'label': '🎱 World Lotteries'},
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final allFixtures = appState.fixtures;

    final filteredFixtures = _selectedSport == 'ALL'
        ? allFixtures
        : allFixtures.where((f) => f.sport.toLowerCase() == _selectedSport.toLowerCase()).toList();

    return Scaffold(
      backgroundColor: PskTheme.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Categories tab row
              SliverToBoxAdapter(
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.only(top: 8, bottom: 4),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedSport == cat['key'];
                      return ChoiceChip(
                        label: Text(
                          cat['label']!,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? const Color(0xFF070B19) : Colors.white70,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: PskTheme.pskGold,
                        backgroundColor: PskTheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? PskTheme.pskGold : Colors.white12,
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedSport = cat['key']!);
                        },
                      );
                    },
                  ),
                ),
              ),

              // Super Derby Live Feature Banner
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A2750), Color(0xFF0C1329)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: PskTheme.primaryBlue.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: PskTheme.primaryBlue.withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: PskTheme.dangerRed,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'LIVE 62\'',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'SuperSport HNL Super Derby',
                            style: GoogleFonts.inter(
                              color: PskTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          const Text('📺 HD Stream', style: TextStyle(fontSize: 11, color: PskTheme.primaryCyan)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dinamo Zagreb',
                                  style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Hajduk Split',
                                  style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: PskTheme.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Text(
                              '1 - 0',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: PskTheme.pskGold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          LiveOddsButton(
                            label: '1 (Dinamo)',
                            odds: 1.55,
                            isSelected: appState.isSelected('fix_dinamo_hajduk', 'Dinamo Zagreb'),
                            onTap: () {
                              appState.toggleSelection(
                                const BetSelection(
                                  fixtureId: 'fix_dinamo_hajduk',
                                  fixtureName: 'Dinamo Zagreb vs Hajduk Split',
                                  league: 'SuperSport HNL',
                                  marketName: 'Match Winner (1X2)',
                                  selectionName: 'Dinamo Zagreb',
                                  odds: 1.55,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 6),
                          LiveOddsButton(
                            label: 'X (Draw)',
                            odds: 3.60,
                            isSelected: appState.isSelected('fix_dinamo_hajduk', 'Draw'),
                            onTap: () {
                              appState.toggleSelection(
                                const BetSelection(
                                  fixtureId: 'fix_dinamo_hajduk',
                                  fixtureName: 'Dinamo Zagreb vs Hajduk Split',
                                  league: 'SuperSport HNL',
                                  marketName: 'Match Winner (1X2)',
                                  selectionName: 'Draw',
                                  odds: 3.60,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 6),
                          LiveOddsButton(
                            label: '2 (Hajduk)',
                            odds: 5.50,
                            isSelected: appState.isSelected('fix_dinamo_hajduk', 'Hajduk Split'),
                            onTap: () {
                              appState.toggleSelection(
                                const BetSelection(
                                  fixtureId: 'fix_dinamo_hajduk',
                                  fixtureName: 'Dinamo Zagreb vs Hajduk Split',
                                  league: 'SuperSport HNL',
                                  marketName: 'Match Winner (1X2)',
                                  selectionName: 'Hajduk Split',
                                  odds: 5.50,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TODAY\'S MATCHES & LIVE ODDS',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: PskTheme.textMuted,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        '${filteredFixtures.length} Events',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: PskTheme.primaryCyan,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Fixtures list
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final fixture = filteredFixtures[index];
                      return _buildFixtureCard(context, fixture, appState);
                    },
                    childCount: filteredFixtures.length,
                  ),
                ),
              ),
            ],
          ),

          // Floating Betslip Banner if selections > 0
          if (appState.betslipSelections.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const BetslipBottomSheet(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: PskTheme.brandGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: PskTheme.primaryBlue.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: PskTheme.pskGold,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${appState.betslipSelections.length}',
                          style: GoogleFonts.outfit(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'VIEW BETSLIP',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Odds: ${appState.calculateTotalOdds().toStringAsFixed(2)} • ${appState.user.isStudent ? '50% Shield ON 🎓' : 'Ready'}',
                            style: GoogleFonts.inter(
                              color: PskTheme.pskGold,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFixtureCard(BuildContext context, SportFixture fixture, AppState appState) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PskTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PskTheme.surfaceHighlight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // League & Time
          Row(
            children: [
              if (fixture.isLive) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: PskTheme.dangerRed,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  fixture.startTime,
                  style: GoogleFonts.inter(
                    color: PskTheme.dangerRed,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
                const Icon(Icons.access_time, size: 12, color: PskTheme.textMuted),
                const SizedBox(width: 4),
                Text(
                  fixture.startTime,
                  style: GoogleFonts.inter(
                    color: PskTheme.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Text(
                '•  ${fixture.league}',
                style: GoogleFonts.inter(
                  color: PskTheme.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                fixture.sport,
                style: GoogleFonts.inter(color: PskTheme.textMuted, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Teams
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fixture.homeTeam,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fixture.awayTeam,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (fixture.currentScore != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: PskTheme.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    fixture.currentScore!,
                    style: GoogleFonts.outfit(
                      color: PskTheme.pskGold,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Odds Buttons
          Row(
            children: [
              LiveOddsButton(
                label: '1',
                odds: fixture.oddsHome,
                isSelected: appState.isSelected(fixture.id, fixture.homeTeam),
                onTap: () {
                  appState.toggleSelection(
                    BetSelection(
                      fixtureId: fixture.id,
                      fixtureName: '${fixture.homeTeam} vs ${fixture.awayTeam}',
                      league: fixture.league,
                      marketName: 'Match Winner',
                      selectionName: fixture.homeTeam,
                      odds: fixture.oddsHome,
                    ),
                  );
                },
              ),
              if (fixture.oddsDraw > 1.0) ...[
                const SizedBox(width: 6),
                LiveOddsButton(
                  label: 'X',
                  odds: fixture.oddsDraw,
                  isSelected: appState.isSelected(fixture.id, 'Draw'),
                  onTap: () {
                    appState.toggleSelection(
                      BetSelection(
                        fixtureId: fixture.id,
                        fixtureName: '${fixture.homeTeam} vs ${fixture.awayTeam}',
                        league: fixture.league,
                        marketName: 'Match Winner',
                        selectionName: 'Draw',
                        odds: fixture.oddsDraw,
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(width: 6),
              LiveOddsButton(
                label: '2',
                odds: fixture.oddsAway,
                isSelected: appState.isSelected(fixture.id, fixture.awayTeam),
                onTap: () {
                  appState.toggleSelection(
                    BetSelection(
                      fixtureId: fixture.id,
                      fixtureName: '${fixture.homeTeam} vs ${fixture.awayTeam}',
                      league: fixture.league,
                      marketName: 'Match Winner',
                      selectionName: fixture.awayTeam,
                      odds: fixture.oddsAway,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
