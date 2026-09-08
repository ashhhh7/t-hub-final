import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/psk_theme.dart';
import '../screens/auth/student_verify_dialog.dart';

class StudentShieldPill extends StatelessWidget {
  const StudentShieldPill({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isStudent = appState.user.isStudent;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => const StudentVerifyDialog(),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isStudent
              ? PskTheme.studentShield.withOpacity(0.15)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isStudent ? PskTheme.studentShield : Colors.white24,
            width: 1.2,
          ),
          boxShadow: isStudent
              ? [
                  BoxShadow(
                    color: PskTheme.studentShield.withOpacity(0.25),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isStudent ? '🎓' : '👤',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isStudent ? 'STUDENT SHIELD' : 'REGULAR USER',
                  style: GoogleFonts.outfit(
                    color: isStudent ? PskTheme.studentShield : Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  isStudent ? '50% Loss Refund ON' : 'Tap to Verify Student',
                  style: GoogleFonts.inter(
                    color: isStudent ? PskTheme.pskGold : Colors.white54,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 14,
              color: isStudent ? PskTheme.studentShield : Colors.white38,
            ),
          ],
        ),
      ),
    );
  }
}
