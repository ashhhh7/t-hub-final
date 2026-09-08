import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/psk_theme.dart';
import '../../models/squad_model.dart';

class InviteFriendsDialog extends StatefulWidget {
  const InviteFriendsDialog({super.key});

  @override
  State<InviteFriendsDialog> createState() => _InviteFriendsDialogState();
}

class _InviteFriendsDialogState extends State<InviteFriendsDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _customNameCtrl = TextEditingController();
  final TextEditingController _customUniCtrl = TextEditingController(text: 'University of Zagreb (FER)');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customNameCtrl.dispose();
    _customUniCtrl.dispose();
    super.dispose();
  }

  void _sendInvite(BuildContext context, String friendName, String friendUni) {
    final appState = Provider.of<AppState>(context, listen: false);
    final invite = appState.sendSquadInvite(
      friendName: friendName,
      friendUni: friendUni,
    );

    // Show simulated friend receipt popup so user can test the exact acceptance flow!
    _showSimulatedFriendReceivedModal(context, invite);
  }

  void _showSimulatedFriendReceivedModal(BuildContext context, SquadInvite invite) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: PskTheme.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: PskTheme.pskGold, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PskTheme.pskGold.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('📨', style: TextStyle(fontSize: 32)),
                ),
                const SizedBox(height: 14),
                Text(
                  'INVITATION DELIVERED!',
                  style: GoogleFonts.outfit(
                    color: PskTheme.pskGold,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Simulated perspective of your friend (${invite.receiverName}):',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: PskTheme.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: PskTheme.background,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(invite.squadAvatar, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  invite.squadName,
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Invited by: ${invite.senderName}',
                                  style: GoogleFonts.inter(
                                    color: PskTheme.studentShield,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '"Join our squad for the upcoming Derby Prediction Clash! 2× Double Win pool."',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'What does your friend do?',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PskTheme.successGreen,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          final appState = Provider.of<AppState>(context, listen: false);
                          appState.friendAcceptsInvite(invite.id);
                          Navigator.of(ctx).pop();
                          _showFriendJoinedCelebration(context, invite);
                        },
                        child: Text(
                          'ACCEPT & JOIN ✅',
                          style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white70,
                          side: const BorderSide(color: Colors.white24),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          final appState = Provider.of<AppState>(context, listen: false);
                          appState.friendDeclinesInvite(invite.id);
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${invite.receiverName} declined the invitation.')),
                          );
                        },
                        child: Text(
                          'DECLINE ❌',
                          style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFriendJoinedCelebration(BuildContext context, SquadInvite invite) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: PskTheme.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: PskTheme.successGreen, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.celebration, color: PskTheme.successGreen, size: 54),
                const SizedBox(height: 14),
                Text(
                  'FRIEND JOINED YOUR SQUAD!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: PskTheme.successGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${invite.receiverName} accepted the request and is now an official member of ${invite.squadName} ${invite.squadAvatar}!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PskTheme.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people, color: PskTheme.pskGold, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Team Roster Size Increased!',
                        style: GoogleFonts.inter(
                          color: PskTheme.pskGold,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PskTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'GREAT, VIEW SQUAD ROSTER',
                      style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentSquad = appState.currentSquad;
    final friends = appState.campusFriends;
    final sentInvites = appState.sentInvites;
    final incomingInvites = appState.incomingInvites;

    return Dialog(
      backgroundColor: PskTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFF2B3D75), width: 1.5),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 640),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: PskTheme.brandGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(currentSquad.avatarIcon, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invite Friends to ${currentSquad.name}',
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${currentSquad.membersCount} Members • Team Roster',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: PskTheme.studentShield,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Tabs
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: PskTheme.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: PskTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: PskTheme.textMuted,
                  labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12),
                  tabs: [
                    const Tab(text: 'Campus Mates'),
                    Tab(text: 'Sent (${sentInvites.length})'),
                    Tab(text: 'Incoming (${incomingInvites.length})'),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Campus Mates List + Custom Input
                    ListView(
                      children: [
                        // Custom Username Input Box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: PskTheme.surfaceElevated,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'INVITE ANY FRIEND BY USERNAME',
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: PskTheme.pskGold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _customNameCtrl,
                                      style: const TextStyle(color: Colors.white, fontSize: 13),
                                      decoration: InputDecoration(
                                        hintText: 'Enter campus friend username',
                                        hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                                        filled: true,
                                        fillColor: PskTheme.background,
                                        prefixIcon: const Icon(Icons.person_add, color: PskTheme.primaryBlue, size: 18),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: PskTheme.pskGold,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      if (_customNameCtrl.text.trim().isNotEmpty) {
                                        _sendInvite(
                                          context,
                                          _customNameCtrl.text.trim(),
                                          _customUniCtrl.text.trim(),
                                        );
                                        _customNameCtrl.clear();
                                      }
                                    },
                                    child: const Text('INVITE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),
                        Text(
                          'SUGGESTED ONLINE CAMPUS STUDENTS',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: PskTheme.textMuted,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 8),

                        ...friends.map((friend) {
                          final alreadyInSquad = currentSquad.memberNames.contains(friend.name);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: PskTheme.surfaceElevated,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    Text(friend.avatar, style: const TextStyle(fontSize: 26)),
                                    if (friend.isOnline)
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: PskTheme.successGreen,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        friend.name,
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        friend.university,
                                        style: GoogleFonts.inter(
                                          color: PskTheme.textMuted,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (alreadyInSquad)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text('In Team', style: TextStyle(color: Colors.white60, fontSize: 10)),
                                  )
                                else if (friend.isInvited)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: PskTheme.pskGold.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: PskTheme.pskGold.withOpacity(0.4)),
                                    ),
                                    child: const Text('Invited', style: TextStyle(color: PskTheme.pskGold, fontSize: 10, fontWeight: FontWeight.bold)),
                                  )
                                else
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: PskTheme.primaryBlue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () => _sendInvite(context, friend.name, friend.university),
                                    child: const Text('INVITE +', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),

                    // Tab 2: Sent Invites List
                    sentInvites.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.send, color: Colors.white24, size: 40),
                                const SizedBox(height: 8),
                                Text('No invites sent yet.', style: GoogleFonts.inter(color: PskTheme.textMuted)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: sentInvites.length,
                            itemBuilder: (context, index) {
                              final inv = sentInvites[index];
                              Color statusColor;
                              String statusText;

                              switch (inv.status) {
                                case InviteStatus.accepted:
                                  statusColor = PskTheme.successGreen;
                                  statusText = 'ACCEPTED (IN TEAM)';
                                  break;
                                case InviteStatus.declined:
                                  statusColor = PskTheme.dangerRed;
                                  statusText = 'DECLINED';
                                  break;
                                case InviteStatus.pending:
                                  statusColor = PskTheme.pskGold;
                                  statusText = 'PENDING ACCEPTANCE';
                                  break;
                              }

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: PskTheme.surfaceElevated,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.outgoing_mail, color: Colors.white70, size: 24),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            inv.receiverName,
                                            style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            inv.receiverUniversity,
                                            style: GoogleFonts.inter(color: PskTheme.textMuted, fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: statusColor.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: statusColor.withOpacity(0.4)),
                                          ),
                                          child: Text(
                                            statusText,
                                            style: GoogleFonts.inter(
                                              color: statusColor,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        if (inv.status == InviteStatus.pending) ...[
                                          const SizedBox(height: 4),
                                          InkWell(
                                            onTap: () {
                                              appState.friendAcceptsInvite(inv.id);
                                              _showFriendJoinedCelebration(context, inv);
                                            },
                                            child: Text(
                                              'Simulate Accept ✅',
                                              style: GoogleFonts.inter(
                                                color: PskTheme.studentShield,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                    // Tab 3: Incoming Invites List
                    incomingInvites.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.inbox, color: Colors.white24, size: 40),
                                const SizedBox(height: 8),
                                Text('No incoming squad requests.', style: GoogleFonts.inter(color: PskTheme.textMuted)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: incomingInvites.length,
                            itemBuilder: (context, index) {
                              final inv = incomingInvites[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: PskTheme.surfaceElevated,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: PskTheme.pskGold.withOpacity(0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(inv.squadAvatar, style: const TextStyle(fontSize: 24)),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Join ${inv.squadName}',
                                                style: GoogleFonts.outfit(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'From: ${inv.senderName}',
                                                style: GoogleFonts.inter(
                                                  color: PskTheme.textMuted,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.white70,
                                            side: const BorderSide(color: Colors.white24),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          onPressed: () => appState.declineIncomingInvite(inv),
                                          child: const Text('DECLINE', style: TextStyle(fontSize: 10)),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: PskTheme.successGreen,
                                            foregroundColor: Colors.black,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          onPressed: () {
                                            appState.acceptIncomingInvite(inv);
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Joined ${inv.squadName}!')),
                                            );
                                          },
                                          child: const Text('ACCEPT & JOIN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
