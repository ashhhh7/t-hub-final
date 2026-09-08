import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/psk_theme.dart';
import '../../models/squad_model.dart';
import '../../widgets/refund_celebration_dialog.dart';
import 'invite_friends_dialog.dart';

class SquadBattlesScreen extends StatefulWidget {
  const SquadBattlesScreen({super.key});

  @override
  State<SquadBattlesScreen> createState() => _SquadBattlesScreenState();
}

class _SquadBattlesScreenState extends State<SquadBattlesScreen> {
  bool _showRoster = true;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.user;
    final squads = appState.squads;
    final battles = appState.squadBattles;
    final incomingInvites = appState.incomingInvites;

    final mySquad = squads.firstWhere(
      (s) => s.id == (user.activeSquadId ?? 'sq_zagreb_wolves'),
      orElse: () => squads.first,
    );

    return Scaffold(
      backgroundColor: PskTheme.background,
      body: CustomScrollView(
        slivers: [
          // Header Banner: 2x Double Win Explainer & Incoming Request Alert
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: PskTheme.squadGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE94057).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Text('⚡', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              'YOUTH & CAMPUS SQUAD CO-OP',
                              style: GoogleFonts.outfit(
                                color: PskTheme.pskGold,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '2× WIN POOL',
                          style: GoogleFonts.outfit(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Squad Battles: Team vs Team',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Team up with campus friends. Out-predict the opposing squad and take home DOUBLE the entry payout (2× return)!',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Incoming Invites Alert Pill (if any)
          if (incomingInvites.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (c) => const InviteFriendsDialog(),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: PskTheme.pskGold.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: PskTheme.pskGold.withOpacity(0.6)),
                    ),
                    child: Row(
                      children: [
                        const Text('📨', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'You have ${incomingInvites.length} pending squad invite from campus friends! Tap to view & accept.',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: PskTheme.pskGold, size: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Active Squad Profile Card with Invite Friends Action
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PskTheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: PskTheme.surfaceHighlight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: PskTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: PskTheme.pskGold, width: 1.5),
                        ),
                        child: Center(
                          child: Text(mySquad.avatarIcon, style: const TextStyle(fontSize: 26)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  mySquad.name,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: PskTheme.primaryBlue.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    mySquad.tag,
                                    style: GoogleFonts.inter(
                                      color: PskTheme.primaryCyan,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              mySquad.universityAffiliation,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: PskTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.swap_horiz, color: PskTheme.pskGold),
                        tooltip: 'Switch Squad',
                        onPressed: () => _showSwitchSquadSheet(context, squads, appState),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSquadStat('MEMBERS', '${mySquad.membersCount} Players'),
                      _buildSquadStat('RECORD', '${mySquad.wins}W - ${mySquad.losses}L'),
                      _buildSquadStat('EARNINGS', '€${mySquad.totalEarnings.toStringAsFixed(0)}'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // INVITE FRIENDS BUTTON
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PskTheme.pskGold,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (c) => const InviteFriendsDialog(),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person_add, size: 18, color: Colors.black),
                              const SizedBox(width: 8),
                              Text(
                                'INVITE YOUR FRIENDS TO TEAM',
                                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: PskTheme.surfaceHighlight,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: Icon(_showRoster ? Icons.group : Icons.group_outlined, color: Colors.white),
                        tooltip: 'Toggle Roster',
                        onPressed: () => setState(() => _showRoster = !_showRoster),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Team Roster Section (Expandable)
          if (_showRoster)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PskTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shield_outlined, color: PskTheme.studentShield, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '${mySquad.name.toUpperCase()} ROSTER (${mySquad.members.length} CAMPUS PLAYERS)',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: PskTheme.studentShield,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (c) => const InviteFriendsDialog(),
                            );
                          },
                          child: Text(
                            '+ Add Member',
                            style: GoogleFonts.inter(
                              color: PskTheme.pskGold,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...mySquad.members.map((member) {
                      final isCaptain = member.role == 'Captain';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: PskTheme.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isCaptain ? PskTheme.pskGold.withOpacity(0.4) : Colors.white10,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: member.isOnline ? PskTheme.successGreen : Colors.white30,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.name,
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    member.university,
                                    style: GoogleFonts.inter(color: PskTheme.textMuted, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isCaptain ? PskTheme.pskGold.withOpacity(0.15) : Colors.white10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                member.role,
                                style: GoogleFonts.inter(
                                  color: isCaptain ? PskTheme.pskGold : Colors.white70,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

          // Section Header: Active Battles
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LIVE SQUAD CLASH ARENA',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: PskTheme.textMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    '2× Winning Payout',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: PskTheme.pskGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Battle Cards List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final battle = battles[index];
                  return _buildBattleCard(context, battle, appState);
                },
                childCount: battles.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquadStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: PskTheme.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBattleCard(BuildContext context, SquadBattle battle, AppState appState) {
    final isLive = battle.status == SquadBattleStatus.live;
    final isCompleted = battle.status == SquadBattleStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PskTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLive ? PskTheme.primaryCyan.withOpacity(0.5) : PskTheme.surfaceHighlight,
          width: isLive ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mode and Status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isLive
                      ? PskTheme.dangerRed
                      : (isCompleted ? PskTheme.successGreen : PskTheme.surfaceHighlight),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isLive ? 'LIVE CLASH' : (isCompleted ? 'COMPLETED' : 'MATCHMAKING'),
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                battle.gameMode,
                style: GoogleFonts.inter(
                  color: PskTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: PskTheme.pskGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: PskTheme.pskGold.withOpacity(0.3)),
                ),
                child: Text(
                  'Pool: €${battle.totalPrizePool.toStringAsFixed(0)}',
                  style: GoogleFonts.outfit(
                    color: PskTheme.pskGold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            battle.title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),

          // Team vs Team Face-off Arena
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: PskTheme.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Team A
                Column(
                  children: [
                    Text(battle.teamA.avatarIcon, style: const TextStyle(fontSize: 32)),
                    const SizedBox(height: 4),
                    Text(
                      battle.teamA.name,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Score: ${battle.teamAScore}',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: PskTheme.primaryCyan,
                      ),
                    ),
                  ],
                ),

                // VS Badge
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: PskTheme.surfaceHighlight,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    'VS',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: PskTheme.pskGold,
                    ),
                  ),
                ),

                // Team B
                Column(
                  children: [
                    Text(battle.teamB.avatarIcon, style: const TextStyle(fontSize: 32)),
                    const SizedBox(height: 4),
                    Text(
                      battle.teamB.name,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Score: ${battle.teamBScore}',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Prize and Rules
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: PskTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Entry: €${battle.entryStakePerPlayer.toStringAsFixed(2)} / player',
                  style: GoogleFonts.inter(color: PskTheme.textSecondary, fontSize: 12),
                ),
                Row(
                  children: [
                    const Icon(Icons.military_tech, color: PskTheme.pskGold, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Win: €${battle.doubleWinPayout.toStringAsFixed(2)} (2× Double)',
                      style: GoogleFonts.outfit(
                        color: PskTheme.pskGold,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Action Buttons: Join Battle / Test 2x Double Win
          if (!isCompleted) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PskTheme.pskGold,
                      foregroundColor: const Color(0xFF070B19),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final success = appState.enterSquadBattle(battle.battleId);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: PskTheme.primaryBlue,
                            content: Text(
                              '⚔️ Joined ${battle.title}! Stake of €${battle.entryStakePerPlayer.toStringAsFixed(2)} deposited into prize pool.',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Insufficient balance to join battle!')),
                        );
                      }
                    },
                    child: Text(
                      'JOIN SQUAD BATTLE (€${battle.entryStakePerPlayer.toStringAsFixed(2)})',
                      style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Simulation Controls to directly verify double payout and 50% refund
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PskTheme.successGreen,
                      side: const BorderSide(color: PskTheme.successGreen),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      final res = appState.claimSquadBattleResult(battle.battleId, userTeamWon: true);
                      _showVictoryDialog(context, battle, res['payout']);
                    },
                    child: const Text('SIMULATE 2× VICTORY 🏆', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PskTheme.dangerRed,
                      side: const BorderSide(color: PskTheme.dangerRed),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      final res = appState.claimSquadBattleResult(battle.battleId, userTeamWon: false);
                      if (res['refund'] > 0) {
                        showDialog(
                          context: context,
                          builder: (c) => RefundCelebrationDialog(
                            refundAmount: res['refund'],
                            originalStake: battle.entryStakePerPlayer,
                            gameOrTicketTitle: battle.title,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Battle lost. Better luck next match!')),
                        );
                      }
                    },
                    child: Text(
                      appState.user.isStudent ? 'SIMULATE LOSS (50% REFUND)' : 'SIMULATE LOSS',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: PskTheme.successGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: PskTheme.successGreen),
              ),
              child: Text(
                '🎉 BATTLE FINISHED • WINNERS CREDITED 2× PAYOUT',
                style: GoogleFonts.outfit(
                  color: PskTheme.successGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showVictoryDialog(BuildContext context, SquadBattle battle, double payout) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: PskTheme.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: PskTheme.pskGold, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: PskTheme.goldGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: PskTheme.pskGold.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(child: Text('🏆', style: TextStyle(fontSize: 36))),
              ),
              const SizedBox(height: 18),
              Text(
                'SQUAD 2× DOUBLE WIN!',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: PskTheme.pskGold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your squad was crowned Champions in ${battle.title}!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: PskTheme.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Original Entry:', style: GoogleFonts.inter(color: PskTheme.textMuted, fontSize: 12)),
                        Text('€${battle.entryStakePerPlayer.toStringAsFixed(2)}', style: GoogleFonts.outfit(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(color: Colors.white12, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('2× Winning Payout:', style: GoogleFonts.inter(color: PskTheme.successGreen, fontSize: 13, fontWeight: FontWeight.bold)),
                        Text(
                          '+€${payout.toStringAsFixed(2)}',
                          style: GoogleFonts.outfit(
                            color: PskTheme.pskGold,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PskTheme.pskGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'CLAIM 2× PAYOUT & CONTINUE',
                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSwitchSquadSheet(BuildContext context, List<Squad> squads, AppState appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: PskTheme.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SELECT CAMPUS SQUAD',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              ...squads.map((sq) {
                final isCurrent = sq.id == appState.user.activeSquadId;
                return ListTile(
                  leading: Text(sq.avatarIcon, style: const TextStyle(fontSize: 28)),
                  title: Text(sq.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
                  subtitle: Text(sq.universityAffiliation, style: GoogleFonts.inter(fontSize: 11, color: PskTheme.textMuted)),
                  trailing: isCurrent
                      ? const Icon(Icons.check_circle, color: PskTheme.pskGold)
                      : TextButton(
                          child: const Text('Join'),
                          onPressed: () {
                            appState.selectSquad(sq.id);
                            Navigator.of(ctx).pop();
                          },
                        ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
