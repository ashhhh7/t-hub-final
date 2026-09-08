import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/psk_theme.dart';
import '../../models/bet_model.dart';
import '../../widgets/refund_celebration_dialog.dart';

class BetslipBottomSheet extends StatefulWidget {
  const BetslipBottomSheet({super.key});

  @override
  State<BetslipBottomSheet> createState() => _BetslipBottomSheetState();
}

class _BetslipBottomSheetState extends State<BetslipBottomSheet> {
  double _stake = 10.0;
  final TextEditingController _stakeCtrl = TextEditingController(text: '10.0');

  @override
  void initState() {
    super.initState();
    _stakeCtrl.addListener(() {
      final parsed = double.tryParse(_stakeCtrl.text);
      if (parsed != null && parsed != _stake) {
        setState(() => _stake = parsed);
      }
    });
  }

  void _setStake(double amount) {
    setState(() {
      _stake = amount;
      _stakeCtrl.text = amount.toStringAsFixed(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final selections = appState.betslipSelections;
    final isStudent = appState.user.isStudent;
    final totalOdds = appState.calculateTotalOdds();
    final potentialWin = _stake * totalOdds;
    final potentialRefund = isStudent ? _stake * 0.5 : 0.0;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: PskTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: PskTheme.surfaceHighlight, width: 2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: PskTheme.pskGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.receipt_long, color: PskTheme.pskGold, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  'BETSLIP (${selections.length})',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                if (selections.isNotEmpty)
                  TextButton(
                    onPressed: appState.clearBetslip,
                    child: Text(
                      'Clear All',
                      style: GoogleFonts.inter(color: PskTheme.dangerRed, fontSize: 12),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white60, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),

          // Content
          Expanded(
            child: selections.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sports_soccer, size: 56, color: Colors.white24),
                          const SizedBox(height: 14),
                          Text(
                            'Your Betslip is Empty',
                            style: GoogleFonts.outfit(fontSize: 18, color: Colors.white70),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap on odds (1, X, 2) in the Sportsbook feed to add selections.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 12, color: PskTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    children: [
                      // Selections list
                      ...selections.map((sel) {
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sel.league,
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: PskTheme.textMuted,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      sel.fixtureName,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: PskTheme.primaryBlue.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            sel.selectionName,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: PskTheme.primaryCyan,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Odds: ${sel.odds.toStringAsFixed(2)}',
                                          style: GoogleFonts.outfit(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: PskTheme.pskGold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.white38, size: 18),
                                onPressed: () => appState.toggleSelection(sel),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 12),

                      // Stake options
                      Text(
                        'STAKE AMOUNT (€)',
                        style: GoogleFonts.outfit(
                          color: PskTheme.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _stakeCtrl,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                prefixText: '€ ',
                                prefixStyle: GoogleFonts.outfit(color: PskTheme.pskGold, fontSize: 18),
                                filled: true,
                                fillColor: PskTheme.background,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: PskTheme.surfaceHighlight),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildChip('€5', () => _setStake(5.0)),
                          const SizedBox(width: 6),
                          _buildChip('€10', () => _setStake(10.0)),
                          const SizedBox(width: 6),
                          _buildChip('€25', () => _setStake(25.0)),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Summary Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: PskTheme.background,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: PskTheme.surfaceHighlight),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Odds:', style: GoogleFonts.inter(color: PskTheme.textMuted, fontSize: 12)),
                                Text(
                                  totalOdds.toStringAsFixed(2),
                                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Potential Return:', style: GoogleFonts.inter(color: PskTheme.textMuted, fontSize: 12)),
                                Text(
                                  '€${potentialWin.toStringAsFixed(2)}',
                                  style: GoogleFonts.outfit(
                                    color: PskTheme.pskGold,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            if (isStudent) ...[
                              const Divider(color: Colors.white12, height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text('🎓', style: TextStyle(fontSize: 12)),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Student Loss Shield (50%):',
                                        style: GoogleFonts.inter(
                                          color: PskTheme.studentShield,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '€${potentialRefund.toStringAsFixed(2)} Refund if Lost',
                                    style: GoogleFonts.inter(
                                      color: PskTheme.studentShield,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      if (isStudent) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: PskTheme.studentShield.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: PskTheme.studentShield.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.shield, color: PskTheme.studentShield, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Guaranteed 50% refund applied to your balance if any outcome loses.',
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
          ),

          // Bottom Action Button
          if (selections.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PskTheme.pskGold,
                    foregroundColor: const Color(0xFF070B19),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final ticket = appState.placeTicket(_stake);
                    if (ticket != null) {
                      Navigator.of(context).pop();
                      _showTicketPlacedDialog(context, ticket);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Insufficient balance or invalid stake!')),
                      );
                    }
                  },
                  child: Text(
                    'PLACE BET • €${_stake.toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: PskTheme.surfaceHighlight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white12),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showTicketPlacedDialog(BuildContext context, PlacedTicket ticket) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final appState = Provider.of<AppState>(context, listen: false);

            return Dialog(
              backgroundColor: PskTheme.surfaceElevated,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFF2B3D75)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: PskTheme.successGreen, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'TICKET PLACED SUCCESSFULLY!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ticket ID: ${ticket.ticketId}',
                      style: GoogleFonts.inter(color: PskTheme.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: PskTheme.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Stake:', style: GoogleFonts.inter(color: PskTheme.textMuted, fontSize: 12)),
                              Text('€${ticket.stake.toStringAsFixed(2)}', style: GoogleFonts.outfit(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Potential Win:', style: GoogleFonts.inter(color: PskTheme.textMuted, fontSize: 12)),
                              Text('€${ticket.potentialWin.toStringAsFixed(2)}', style: GoogleFonts.outfit(color: PskTheme.pskGold, fontSize: 15, fontWeight: FontWeight.w900)),
                            ],
                          ),
                          if (ticket.isStudentProtected) ...[
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('🎓 Student Protection:', style: GoogleFonts.inter(color: PskTheme.studentShield, fontSize: 11, fontWeight: FontWeight.bold)),
                                Text('€${(ticket.stake * 0.5).toStringAsFixed(2)} Refund (50%)', style: GoogleFonts.inter(color: PskTheme.studentShield, fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '⚡ FAST-FORWARD SIMULATION (FOR TESTING)',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: PskTheme.pskGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PskTheme.successGreen,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              appState.resolveTicket(ticket.ticketId, true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: PskTheme.successGreen,
                                  content: Text(
                                    '🎉 Bet Won! €${ticket.potentialWin.toStringAsFixed(2)} credited to balance!',
                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                            child: const Text('SIMULATE WIN 🎉', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PskTheme.dangerRed,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              final res = appState.resolveTicket(ticket.ticketId, false);
                              if (res['refundAmount'] > 0) {
                                showDialog(
                                  context: context,
                                  builder: (c) => RefundCelebrationDialog(
                                    refundAmount: res['refundAmount'],
                                    originalStake: ticket.stake,
                                    gameOrTicketTitle: 'Sports Ticket #${ticket.ticketId}',
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Ticket lost.')),
                                );
                              }
                            },
                            child: Text(
                              ticket.isStudentProtected ? 'SIMULATE LOSS (50% REFUND)' : 'SIMULATE LOSS',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Close & Keep Pending', style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
