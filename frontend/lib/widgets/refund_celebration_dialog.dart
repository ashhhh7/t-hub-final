import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/psk_theme.dart';

class RefundCelebrationDialog extends StatelessWidget {
  final double refundAmount;
  final double originalStake;
  final String gameOrTicketTitle;
  final VoidCallback? onDismiss;

  const RefundCelebrationDialog({
    super.key,
    required this.refundAmount,
    required this.originalStake,
    required this.gameOrTicketTitle,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: PskTheme.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: PskTheme.studentShield, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Glowing Shield Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: PskTheme.studentGradient,
                boxShadow: [
                  BoxShadow(
                    color: PskTheme.studentShield.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '🎓',
                  style: TextStyle(fontSize: 36),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'STUDENT SHIELD ACTIVATED!',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: PskTheme.studentShield,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '50% Loss Protection Triggered',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: PskTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: PskTheme.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: PskTheme.surfaceHighlight),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Event / Game:',
                        style: GoogleFonts.inter(color: PskTheme.textMuted, fontSize: 12),
                      ),
                      Flexible(
                        child: Text(
                          gameOrTicketTitle,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Original Stake:',
                        style: GoogleFonts.inter(color: PskTheme.textMuted, fontSize: 12),
                      ),
                      Text(
                        '€${originalStake.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          color: PskTheme.dangerRed,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Refunded to Wallet (50%):',
                        style: GoogleFonts.inter(
                          color: PskTheme.studentShield,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '+€${refundAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          color: PskTheme.pskGold,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'As a verified 18+ university student, your bankroll is protected against total loss.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: PskTheme.textMuted,
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PskTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onDismiss?.call();
                },
                child: Text(
                  'AWESOME, CONTINUE PLAYING',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
