import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/psk_theme.dart';
import '../../widgets/refund_celebration_dialog.dart';

class SlotGameDialog extends StatefulWidget {
  final String gameTitle;
  final String provider;

  const SlotGameDialog({
    super.key,
    required this.gameTitle,
    required this.provider,
  });

  @override
  State<SlotGameDialog> createState() => _SlotGameDialogState();
}

class _SlotGameDialogState extends State<SlotGameDialog> with TickerProviderStateMixin {
  final List<String> _symbols = ['🍒', '🍋', '🍇', '🔔', '7️⃣', '💎', '🪙'];
  List<String> _reels = ['7️⃣', '7️⃣', '7️⃣'];

  double _stake = 2.0;
  bool _isSpinning = false;
  String _lastResultMessage = 'Place your spin to play!';
  Color _resultColor = Colors.white70;

  late AnimationController _spinAnimCtrl;

  @override
  void initState() {
    super.initState();
    _spinAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _spinAnimCtrl.dispose();
    super.dispose();
  }

  void _spin() {
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.user.balance < _stake) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient balance to spin!')),
      );
      return;
    }

    setState(() {
      _isSpinning = true;
      _lastResultMessage = 'Spinning the reels...';
      _resultColor = PskTheme.pskGold;
    });

    _spinAnimCtrl.repeat();

    // Fast cycling symbols during spin
    int counter = 0;
    final random = Random();
    Timer.periodic(const Duration(milliseconds: 90), (timer) {
      counter++;
      if (mounted) {
        setState(() {
          _reels = [
            _symbols[random.nextInt(_symbols.length)],
            _symbols[random.nextInt(_symbols.length)],
            _symbols[random.nextInt(_symbols.length)],
          ];
        });
      }

      if (counter >= 15) {
        timer.cancel();
        _finalizeSpin();
      }
    });
  }

  void _finalizeSpin() {
    final appState = Provider.of<AppState>(context, listen: false);
    final random = Random();
    final roll = random.nextDouble();

    bool isWin = false;
    double multiplier = 0.0;
    List<String> finalReels;

    if (roll < 0.15) {
      // 3 of a kind high (7s or Diamonds)
      final sym = roll < 0.05 ? '7️⃣' : '💎';
      finalReels = [sym, sym, sym];
      isWin = true;
      multiplier = (sym == '7️⃣') ? 15.0 : 8.0;
    } else if (roll < 0.38) {
      // 3 of a kind medium
      final sym = _symbols[random.nextInt(3)];
      finalReels = [sym, sym, sym];
      isWin = true;
      multiplier = 4.0;
    } else if (roll < 0.50) {
      // 2 of a kind
      final sym = _symbols[random.nextInt(_symbols.length)];
      final other = _symbols[(random.nextInt(_symbols.length - 1) + 1) % _symbols.length];
      finalReels = [sym, sym, other];
      isWin = true;
      multiplier = 1.5;
    } else {
      // Loss
      finalReels = ['🍒', '🔔', '7️⃣'];
      finalReels.shuffle();
      isWin = false;
      multiplier = 0.0;
    }

    final spinResult = appState.playSlotSpin(
      stake: _stake,
      isWin: isWin,
      multiplier: multiplier,
      gameName: widget.gameTitle,
    );

    _spinAnimCtrl.stop();

    setState(() {
      _isSpinning = false;
      _reels = finalReels;

      if (isWin) {
        final winAmt = spinResult['winAmount'] ?? (_stake * multiplier);
        _lastResultMessage = 'WINNER! +€${winAmt.toStringAsFixed(2)} (${multiplier.toStringAsFixed(1)}x)! 🎉';
        _resultColor = PskTheme.successGreen;
      } else {
        if (spinResult['refundAmount'] != null && spinResult['refundAmount'] > 0) {
          _lastResultMessage = 'Spin Lost • 🎓 Student 50% Refunded (+€${spinResult['refundAmount'].toStringAsFixed(2)})';
          _resultColor = PskTheme.studentShield;
        } else {
          _lastResultMessage = 'No match this time. Try again!';
          _resultColor = PskTheme.textMuted;
        }
      }
    });

    // If student 50% refund activated, show celebration modal
    if (!isWin && spinResult['refundAmount'] != null && spinResult['refundAmount'] > 0) {
      showDialog(
        context: context,
        builder: (ctx) => RefundCelebrationDialog(
          refundAmount: spinResult['refundAmount'],
          originalStake: _stake,
          gameOrTicketTitle: '${widget.gameTitle} (${widget.provider})',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isStudent = appState.user.isStudent;

    return Dialog(
      backgroundColor: PskTheme.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFF2B3D75), width: 1.5),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.gameTitle,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Provider: ${widget.provider}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: PskTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 20),

              // Student 50% Shield Badge on slot machine
              if (isStudent)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: PskTheme.studentShield.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: PskTheme.studentShield.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Text('🎓', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Student Shield Active: 50% of losing spins are auto-refunded to balance!',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: PskTheme.studentShield,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Slot Machine Cabinet Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B264F), Color(0xFF090E22)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: PskTheme.pskGold, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: PskTheme.pskGold.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Jackpot Ticker
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: PskTheme.pskGold.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.stars, color: PskTheme.pskGold, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'JACKPOT: €48,290.45',
                            style: GoogleFonts.outfit(
                              color: PskTheme.pskGold,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3 Reels Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildReelBox(_reels[0]),
                        _buildReelBox(_reels[1]),
                        _buildReelBox(_reels[2]),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Win line indicator
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: PskTheme.goldGradient,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Status Message
                    Text(
                      _lastResultMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: _resultColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Stake Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BET PER SPIN',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: PskTheme.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        '€${_stake.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: PskTheme.pskGold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildStakeBtn('€1', 1.0),
                      const SizedBox(width: 6),
                      _buildStakeBtn('€2', 2.0),
                      const SizedBox(width: 6),
                      _buildStakeBtn('€5', 5.0),
                      const SizedBox(width: 6),
                      _buildStakeBtn('€10', 10.0),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Spin Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PskTheme.pskGold,
                    foregroundColor: const Color(0xFF070B19),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isSpinning ? null : _spin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isSpinning ? Icons.refresh : Icons.play_arrow,
                        size: 24,
                        color: const Color(0xFF070B19),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isSpinning ? 'SPINNING...' : 'SPIN (€${_stake.toStringAsFixed(2)})',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReelBox(String symbol) {
    return Container(
      width: 80,
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF070A18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          symbol,
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }

  Widget _buildStakeBtn(String label, double amount) {
    final isSelected = _stake == amount;
    return InkWell(
      onTap: _isSpinning ? null : () => setState(() => _stake = amount),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? PskTheme.pskGold : PskTheme.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? PskTheme.pskGold : Colors.white12),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? Colors.black : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
