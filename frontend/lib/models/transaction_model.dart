enum TransactionType {
  deposit,
  betStake,
  betWin,
  betLoss,
  studentRefund,
  slotSpinStake,
  slotSpinWin,
  slotSpinStudentRefund,
  squadBattleEntry,
  squadBattle2xWin,
}

class WalletTransaction {
  final String id;
  final TransactionType type;
  final double amount; // positive for credits, negative for debits
  final DateTime timestamp;
  final String title;
  final String description;
  final String? referenceId;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.timestamp,
    required this.title,
    required this.description,
    this.referenceId,
  });

  bool get isCredit => amount > 0;
}
