import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../state/app_state.dart';
import '../../theme/psk_theme.dart';
import '../../models/transaction_model.dart';

class WalletHistoryScreen extends StatefulWidget {
  const WalletHistoryScreen({super.key});

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  String _filter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.user;
    final allTxs = appState.transactions;

    final filteredTxs = allTxs.where((tx) {
      if (_filter == 'REFUNDS') {
        return tx.type == TransactionType.studentRefund ||
            tx.type == TransactionType.slotSpinStudentRefund;
      } else if (_filter == 'WINS') {
        return tx.type == TransactionType.betWin ||
            tx.type == TransactionType.slotSpinWin ||
            tx.type == TransactionType.squadBattle2xWin;
      } else if (_filter == 'STAKES') {
        return tx.amount < 0;
      }
      return true;
    }).toList();

    final dateFormat = DateFormat('MMM dd, HH:mm');

    return Scaffold(
      backgroundColor: PskTheme.background,
      body: CustomScrollView(
        slivers: [
          // Balance Overview Card
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: PskTheme.brandGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: PskTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ACTIVE BALANCE',
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('EUR (€)', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '€${user.balance.toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Quick Deposit Buttons
                  Row(
                    children: [
                      _buildQuickDepositBtn(context, '+€20', 20.0),
                      const SizedBox(width: 8),
                      _buildQuickDepositBtn(context, '+€50', 50.0),
                      const SizedBox(width: 8),
                      _buildQuickDepositBtn(context, '+€100', 100.0),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Filter chips row
          SliverToBoxAdapter(
            child: Container(
              height: 44,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterChip('ALL', 'All Activity'),
                  _buildFilterChip('REFUNDS', '🎓 50% Refunds'),
                  _buildFilterChip('WINS', '🎉 Wins & 2× Payouts'),
                  _buildFilterChip('STAKES', '💸 Stakes Placed'),
                ],
              ),
            ),
          ),

          // Transaction list
          if (filteredTxs.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      const Icon(Icons.receipt, size: 48, color: Colors.white24),
                      const SizedBox(height: 12),
                      Text('No transactions found in this category', style: GoogleFonts.inter(color: PskTheme.textMuted)),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final tx = filteredTxs[index];
                    final isRefund = tx.type == TransactionType.studentRefund ||
                        tx.type == TransactionType.slotSpinStudentRefund;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isRefund
                            ? PskTheme.studentShield.withOpacity(0.08)
                            : PskTheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isRefund ? PskTheme.studentShield.withOpacity(0.4) : PskTheme.surfaceHighlight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: isRefund
                                  ? PskTheme.studentShield.withOpacity(0.2)
                                  : (tx.isCredit ? PskTheme.successGreen.withOpacity(0.15) : PskTheme.surfaceHighlight),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                isRefund
                                    ? '🎓'
                                    : (tx.type == TransactionType.deposit
                                        ? '💳'
                                        : (tx.type == TransactionType.squadBattle2xWin
                                            ? '🏆'
                                            : (tx.isCredit ? '🎉' : '💸'))),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.title,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isRefund ? PskTheme.studentShield : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  tx.description,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: PskTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dateFormat.format(tx.timestamp),
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    color: PskTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            tx.isCredit ? '+€${tx.amount.toStringAsFixed(2)}' : '-€${(-tx.amount).toStringAsFixed(2)}',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: isRefund
                                  ? PskTheme.studentShield
                                  : (tx.isCredit ? PskTheme.successGreen : PskTheme.dangerRed),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: filteredTxs.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickDepositBtn(BuildContext context, String label, double amount) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.18),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          Provider.of<AppState>(context, listen: false).deposit(amount);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: PskTheme.primaryBlue,
              content: Text('€${amount.toStringAsFixed(2)} deposited into your balance!'),
            ),
          );
        },
        child: Text(label, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _filter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.black : Colors.white70,
          ),
        ),
        selected: isSelected,
        selectedColor: PskTheme.pskGold,
        backgroundColor: PskTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: isSelected ? PskTheme.pskGold : Colors.white12),
        ),
        onSelected: (sel) {
          if (sel) setState(() => _filter = key);
        },
      ),
    );
  }
}
