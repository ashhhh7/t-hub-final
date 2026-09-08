import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/psk_theme.dart';

class LiveOddsButton extends StatelessWidget {
  final String label;
  final double odds;
  final bool isSelected;
  final VoidCallback onTap;

  const LiveOddsButton({
    super.key,
    required this.label,
    required this.odds,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? PskTheme.primaryBlue
                : PskTheme.surfaceHighlight.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? PskTheme.pskGold : Colors.white12,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: PskTheme.primaryBlue.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : PskTheme.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                odds.toStringAsFixed(2),
                style: GoogleFonts.outfit(
                  color: isSelected ? PskTheme.pskGold : Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
