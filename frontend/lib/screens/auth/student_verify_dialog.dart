import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/psk_theme.dart';

class StudentVerifyDialog extends StatefulWidget {
  const StudentVerifyDialog({super.key});

  @override
  State<StudentVerifyDialog> createState() => _StudentVerifyDialogState();
}

class _StudentVerifyDialogState extends State<StudentVerifyDialog> {
  bool _selectedStudent = true;
  String _selectedUni = 'University of Zagreb (Sveučilište u Zagrebu)';
  final TextEditingController _studentIdCtrl = TextEditingController(text: '0036592811');
  bool _confirmed18Plus = true;

  final List<String> _universities = [
    'University of Zagreb (Sveučilište u Zagrebu)',
    'University of Split (Sveučilište u Splitu)',
    'University of Rijeka (Sveučilište u Rijeci)',
    'University of Osijek (Sveučilište u Osijeku)',
    'Zagreb University of Applied Sciences (TVZ)',
    'VERN\' University / Algebra University',
    'International / Erasmus Student Card (ISIC)',
  ];

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _selectedStudent = appState.user.isStudent;
    if (appState.user.universityName != null &&
        _universities.contains(appState.user.universityName)) {
      _selectedUni = appState.user.universityName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: PskTheme.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFF2B3D75), width: 1.5),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: PskTheme.studentGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('🎓', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Verification',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Unlock the 50% Loss Refund Guarantee',
                          style: GoogleFonts.inter(
                            fontSize: 12,
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
              const Divider(color: Colors.white12, height: 28),

              // Question banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: PskTheme.studentShield.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: PskTheme.studentShield.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: PskTheme.studentShield, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Are you currently enrolled as a University / College student (18+)?',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Options
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedStudent = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: _selectedStudent
                              ? PskTheme.studentShield.withOpacity(0.18)
                              : PskTheme.background,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _selectedStudent ? PskTheme.studentShield : Colors.white12,
                            width: _selectedStudent ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text('🎓', style: TextStyle(fontSize: 24)),
                            const SizedBox(height: 6),
                            Text(
                              'YES, I AM A STUDENT',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _selectedStudent ? PskTheme.studentShield : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '50% Refund Benefit',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: PskTheme.pskGold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedStudent = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: !_selectedStudent
                              ? Colors.white.withOpacity(0.12)
                              : PskTheme.background,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: !_selectedStudent ? Colors.white70 : Colors.white12,
                            width: !_selectedStudent ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text('👤', style: TextStyle(fontSize: 24)),
                            const SizedBox(height: 6),
                            Text(
                              'REGULAR PLAYER',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: !_selectedStudent ? Colors.white : Colors.white60,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Standard rules',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: PskTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (_selectedStudent) ...[
                const SizedBox(height: 20),
                Text(
                  'SELECT HIGHER-EDUCATION INSTITUTION:',
                  style: GoogleFonts.outfit(
                    color: PskTheme.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: PskTheme.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: PskTheme.surfaceHighlight),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedUni,
                      dropdownColor: PskTheme.surfaceElevated,
                      items: _universities.map((uni) {
                        return DropdownMenuItem(
                          value: uni,
                          child: Text(
                            uni,
                            style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedUni = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'STUDENT CARD (X-ICA) NUMBER:',
                  style: GoogleFonts.outfit(
                    color: PskTheme.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _studentIdCtrl,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'e.g. 0036592811',
                    hintStyle: const TextStyle(color: Colors.white30),
                    filled: true,
                    fillColor: PskTheme.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: PskTheme.surfaceHighlight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: PskTheme.studentShield),
                    ),
                    prefixIcon: const Icon(Icons.badge, color: PskTheme.studentShield, size: 20),
                  ),
                ),
                const SizedBox(height: 14),
                // 18+ verification check
                Row(
                  children: [
                    Checkbox(
                      value: _confirmed18Plus,
                      activeColor: PskTheme.studentShield,
                      onChanged: (val) => setState(() => _confirmed18Plus = val ?? false),
                    ),
                    Expanded(
                      child: Text(
                        'I certify that I am 18+ years of age (Mandatory under Croatian Act on Games of Chance & EU Regulations).',
                        style: GoogleFonts.inter(
                          color: PskTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 22),
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedStudent ? PskTheme.pskGold : PskTheme.primaryBlue,
                    foregroundColor: const Color(0xFF070B19),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final appState = Provider.of<AppState>(context, listen: false);
                    appState.updateStudentStatus(
                      isStudent: _selectedStudent,
                      universityName: _selectedStudent ? _selectedUni : null,
                      studentIdNumber: _selectedStudent ? _studentIdCtrl.text : null,
                    );
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: _selectedStudent
                            ? const Color(0xFF003B5C)
                            : const Color(0xFF1E2D5A),
                        content: Row(
                          children: [
                            Text(_selectedStudent ? '🎓' : '👤', style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _selectedStudent
                                    ? 'Student Shield Active! 50% loss refund enabled.'
                                    : 'Profile updated to Regular Player.',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedStudent ? PskTheme.studentShield : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Text(
                    _selectedStudent ? 'ACTIVATE 50% REFUND SHIELD 🎓' : 'CONFIRM SELECTION',
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
      ),
    );
  }
}
