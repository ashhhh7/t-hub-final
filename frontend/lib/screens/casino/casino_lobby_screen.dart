import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/psk_theme.dart';
import 'slot_game_dialog.dart';

class CasinoLobbyScreen extends StatefulWidget {
  const CasinoLobbyScreen({super.key});

  @override
  State<CasinoLobbyScreen> createState() => _CasinoLobbyScreenState();
}

class _CasinoLobbyScreenState extends State<CasinoLobbyScreen> {
  String _selectedCategory = 'ALL';

  final List<Map<String, String>> _games = [
    {
      'title': 'Sizzling Hot Deluxe',
      'provider': 'Novomatic / Greentube',
      'category': 'Classic',
      'icon': '🔥',
      'rtp': '95.66%',
      'color': '0xFFE65100',
    },
    {
      'title': '40 Super Hot Bell Link',
      'provider': 'Amusnet (EGT)',
      'category': 'Bell Link',
      'icon': '🔔',
      'rtp': '96.24%',
      'color': '0xFFD84315',
    },
    {
      'title': 'Sugar Rush 1000',
      'provider': 'Pragmatic Play',
      'category': 'Drops & Wins',
      'icon': '🍬',
      'rtp': '96.53%',
      'color': '0xFFC2185B',
    },
    {
      'title': 'Royal Seven XXL',
      'provider': 'Gamomat',
      'category': 'Classic',
      'icon': '7️⃣',
      'rtp': '96.11%',
      'color': '0xFF303F9F',
    },
    {
      'title': 'Mega Fire Blaze: Wild Pistolero',
      'provider': 'Playtech',
      'category': 'Jackpot',
      'icon': '🤠',
      'rtp': '95.96%',
      'color': '0xFF455A64',
    },
    {
      'title': 'BlackJack Multihand',
      'provider': 'Playtech',
      'category': 'Table Games',
      'icon': '🃏',
      'rtp': '99.50%',
      'color': '0xFF00796B',
    },
    {
      'title': '100 Power Hot Dice Edition',
      'provider': 'Amusnet',
      'category': 'Classic',
      'icon': '🎲',
      'rtp': '95.80%',
      'color': '0xFF6A1B9A',
    },
    {
      'title': 'Gates of Olympus 1000',
      'provider': 'Pragmatic Play',
      'category': 'Drops & Wins',
      'icon': '⚡',
      'rtp': '96.50%',
      'color': '0xFFF57F17',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isStudent = appState.user.isStudent;

    final filteredGames = _selectedCategory == 'ALL'
        ? _games
        : _games.where((g) => g['category'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: PskTheme.background,
      body: CustomScrollView(
        slivers: [
          // Jackpot & Student Benefit Banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C1654), Color(0xFF130924)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF9C27B0).withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.2),
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
                      const Icon(Icons.bolt, color: PskTheme.pskGold, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        'PSK VEGAS MEGA JACKPOT',
                        style: GoogleFonts.outfit(
                          color: PskTheme.pskGold,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('BELL LINK 🔔', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '€48,290.45',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isStudent
                          ? PskTheme.studentShield.withOpacity(0.15)
                          : Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isStudent ? PskTheme.studentShield : Colors.white24,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(isStudent ? '🎓' : '💡', style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            isStudent
                                ? 'Student Shield Active: 50% refund applied to any losing spin!'
                                : 'Tip: Verified Students enjoy 50% automatic loss refunds.',
                            style: GoogleFonts.inter(
                              color: isStudent ? PskTheme.studentShield : Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Categories Bar
          SliverToBoxAdapter(
            child: Container(
              height: 44,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip('ALL', '🎰 All Slots'),
                  _buildCategoryChip('Classic', '🍒 Fruit Classics'),
                  _buildCategoryChip('Bell Link', '🔔 Bell Link'),
                  _buildCategoryChip('Drops & Wins', '🍬 Drops & Wins'),
                  _buildCategoryChip('Jackpot', '💎 Jackpots'),
                  _buildCategoryChip('Table Games', '🃏 Table Games'),
                ],
              ),
            ),
          ),

          // Games Grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.82,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final game = filteredGames[index];
                  return _buildGameCard(context, game, isStudent);
                },
                childCount: filteredGames.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String key, String label) {
    final isSelected = _selectedCategory == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.black : Colors.white70,
          ),
        ),
        selected: isSelected,
        selectedColor: PskTheme.pskGold,
        backgroundColor: PskTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: isSelected ? PskTheme.pskGold : Colors.white12),
        ),
        onSelected: (sel) {
          if (sel) setState(() => _selectedCategory = key);
        },
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, Map<String, String> game, bool isStudent) {
    return Container(
      decoration: BoxDecoration(
        color: PskTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PskTheme.surfaceHighlight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner thumbnail simulation
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(int.parse(game['color']!)).withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      game['icon']!,
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'RTP ${game['rtp']}',
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (isStudent)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: PskTheme.studentShield.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(color: PskTheme.studentShield),
                        ),
                        child: const Text('🎓', style: TextStyle(fontSize: 10)),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game['title']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  game['provider']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: PskTheme.textMuted,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PskTheme.pskGold,
                      foregroundColor: const Color(0xFF070B19),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => SlotGameDialog(
                          gameTitle: game['title']!,
                          provider: game['provider']!,
                        ),
                      );
                    },
                    child: Text(
                      'PLAY SLOT 🎰',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
