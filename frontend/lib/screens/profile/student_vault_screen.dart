import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/psk_theme.dart';
import '../auth/student_verify_dialog.dart';

class StudentVaultScreen extends StatelessWidget {
  const StudentVaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.user;
    final isStudent = user.isStudent;

    return Scaffold(
      backgroundColor: PskTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Shield Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: isStudent ? PskTheme.studentGradient : PskTheme.cardGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: isStudent
                        ? PskTheme.studentShield.withOpacity(0.35)
                        : Colors.black45,
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          isStudent ? '🎓' : '👤',
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isStudent ? 'STUDENT SHIELD ACTIVE' : 'REGULAR PLAYER MODE',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              isStudent
                                  ? (user.universityName ?? 'University of Zagreb')
                                  : 'Tap below to activate student 50% refund benefit',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LIFETIME LOSSES REFUNDED',
                              style: GoogleFonts.outfit(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '€${user.totalLossRefunded.toStringAsFixed(2)}',
                              style: GoogleFonts.outfit(
                                color: PskTheme.pskGold,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (c) => const StudentVerifyDialog(),
                            );
                          },
                          child: Text(
                            isStudent ? 'EDIT STATUS' : 'VERIFY NOW',
                            style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Benefit Breakdown
            Text(
              'YOUR STUDENT BENEFITS',
              style: GoogleFonts.outfit(
                color: PskTheme.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),

            _buildBenefitTile(
              icon: '⚽',
              title: '50% Sportsbook Loss Refund',
              subtitle: 'If any single or combo ticket loses, 50% of your stake is instantly refunded back to your balance.',
              active: isStudent,
            ),
            _buildBenefitTile(
              icon: '🎰',
              title: '50% Casino Slot Loss Refund',
              subtitle: 'Any non-winning spin on PSK Vegas slots automatically triggers a 50% cash recovery.',
              active: isStudent,
            ),
            _buildBenefitTile(
              icon: '⚔️',
              title: 'Squad Battles 2× Double Win',
              subtitle: 'Compete in Team vs Team campus challenges. Winning squads receive double their entry stake.',
              active: isStudent,
            ),
            _buildBenefitTile(
              icon: '🛡️',
              title: '18+ Responsible Gambling Shield',
              subtitle: 'Certified compliance with Croatian Act on Games of Chance & EU AI Act (no predatory dark patterns).',
              active: isStudent,
            ),

            const SizedBox(height: 20),

            // Student Card Details (if active)
            if (isStudent) ...[
              Text(
                'VERIFIED IDENTITY DETAILS',
                style: GoogleFonts.outfit(
                  color: PskTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PskTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: PskTheme.surfaceHighlight),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Institution', user.universityName ?? 'University of Zagreb'),
                    const Divider(color: Colors.white12, height: 16),
                    _buildDetailRow('Card (X-ica) #', user.studentIdNumber ?? '0036592811'),
                    const Divider(color: Colors.white12, height: 16),
                    _buildDetailRow('Age Gate', '18+ Certified (Zakon o igrama na sreću)'),
                    const Divider(color: Colors.white12, height: 16),
                    _buildDetailRow('Current Squad', user.activeSquadName ?? 'Zagreb Wolves 🐺'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitTile({
    required String icon,
    required String title,
    required String subtitle,
    required bool active,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PskTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: active ? PskTheme.studentShield.withOpacity(0.3) : PskTheme.surfaceHighlight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PskTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: active ? PskTheme.studentShield.withOpacity(0.15) : Colors.white10,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        active ? 'ACTIVE' : 'LOCKED',
                        style: GoogleFonts.inter(
                          color: active ? PskTheme.studentShield : PskTheme.textMuted,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(fontSize: 11, color: PskTheme.textSecondary, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(color: PskTheme.textMuted, fontSize: 12)),
        Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
