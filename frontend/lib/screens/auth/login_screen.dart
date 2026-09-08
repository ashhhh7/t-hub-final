import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/psk_theme.dart';
import '../home/main_shell_screen.dart';
import 'student_verify_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController(text: 'luka_student26');
  final _passwordCtrl = TextEditingController(text: '••••••••');
  bool _rememberMe = true;

  void _proceedToApp(BuildContext context, {required bool askStudentPrompt}) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainShellScreen()),
    );

    if (askStudentPrompt) {
      // Delay slightly so the shell is rendered before showing the student verification prompt
      Future.delayed(const Duration(milliseconds: 400), () {
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => const StudentVerifyDialog(),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PskTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // PSK Logo & Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: PskTheme.brandGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: PskTheme.primaryBlue.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: PskTheme.pskGold,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'PSK',
                            style: TextStyle(
                              color: Color(0xFF070B19),
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'STUDENT & YOUTH HUB',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'Prva Sportska Kladionica • 2026',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Card container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: PskTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: PskTheme.surfaceHighlight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 25,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to PSK Hub',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sign in to access Sportsbook, Casino, and 2× Squad Battles.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: PskTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Username field
                        Text(
                          'USERNAME OR EMAIL',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: PskTheme.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _usernameCtrl,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Enter username',
                            hintStyle: const TextStyle(color: Colors.white30),
                            filled: true,
                            fillColor: PskTheme.background,
                            prefixIcon: const Icon(Icons.person, color: PskTheme.primaryBlue, size: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: PskTheme.surfaceHighlight),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        Text(
                          'PASSWORD',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: PskTheme.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: const TextStyle(color: Colors.white30),
                            filled: true,
                            fillColor: PskTheme.background,
                            prefixIcon: const Icon(Icons.lock, color: PskTheme.primaryBlue, size: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: PskTheme.surfaceHighlight),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Remember me row
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: PskTheme.primaryBlue,
                              onChanged: (v) => setState(() => _rememberMe = v ?? true),
                            ),
                            Text(
                              'Remember me',
                              style: GoogleFonts.inter(fontSize: 12, color: PskTheme.textSecondary),
                            ),
                            const Spacer(),
                            Text(
                              'Forgot password?',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: PskTheme.primaryCyan,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Standard Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PskTheme.pskGold,
                              foregroundColor: const Color(0xFF070B19),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              final appState = Provider.of<AppState>(context, listen: false);
                              appState.login(
                                username: _usernameCtrl.text,
                                isStudent: false,
                              );
                              // Ask student verification after login!
                              _proceedToApp(context, askStudentPrompt: true);
                            },
                            child: Text(
                              'LOGIN & CONTINUE',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Quick 1-Tap Demo Logins
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: PskTheme.surfaceHighlight.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.flash_on, color: PskTheme.pskGold, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              '1-TAP QUICK DEMO MODES',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: PskTheme.pskGold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Student 1-tap
                        InkWell(
                          onTap: () {
                            final appState = Provider.of<AppState>(context, listen: false);
                            appState.login(
                              username: 'Luka_Student26',
                              isStudent: true,
                              universityName: 'University of Zagreb (Sveučilište u Zagrebu)',
                              studentIdNumber: '0036592811',
                            );
                            _proceedToApp(context, askStudentPrompt: false);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              color: PskTheme.studentShield.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: PskTheme.studentShield.withOpacity(0.4)),
                            ),
                            child: Row(
                              children: [
                                const Text('🎓', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Login as Student (50% Refund Active)',
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: PskTheme.studentShield,
                                        ),
                                      ),
                                      Text(
                                        'UniZg FER • 50% loss refund guarantee enabled',
                                        style: GoogleFonts.inter(fontSize: 10, color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 12, color: PskTheme.studentShield),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Regular Player 1-tap
                        InkWell(
                          onTap: () {
                            final appState = Provider.of<AppState>(context, listen: false);
                            appState.login(
                              username: 'Marko_Pro',
                              isStudent: false,
                            );
                            _proceedToApp(context, askStudentPrompt: false);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Row(
                              children: [
                                const Text('👤', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Login as Regular Player',
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Standard betting rules without student shield',
                                        style: GoogleFonts.inter(fontSize: 10, color: PskTheme.textMuted),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white38),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Responsible Gambling / 18+ Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.redAccent),
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '18+',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Games of Chance are prohibited for persons under 18 • PSK HR',
                          style: GoogleFonts.inter(color: PskTheme.textMuted, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
