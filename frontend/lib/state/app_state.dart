import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/bet_model.dart';
import '../models/squad_model.dart';
import '../models/transaction_model.dart';

class AppState extends ChangeNotifier {
  UserProfile _user = const UserProfile(
    id: 'usr_feg_2026_stu',
    username: 'Luka_Student26',
    email: 'luka.fer@unizg.hr',
    isStudent: true,
    universityName: 'University of Zagreb (Sveučilište u Zagrebu)',
    studentIdNumber: '0036592811',
    balance: 125.00,
    totalLossRefunded: 37.50,
    activeSquadId: 'sq_zagreb_wolves',
    activeSquadName: 'Zagreb Wolves 🐺',
  );

  UserProfile get user => _user;
  bool get isLoggedIn => true;

  // Selected bets in betslip
  final List<BetSelection> _betslipSelections = [];
  List<BetSelection> get betslipSelections => List.unmodifiable(_betslipSelections);

  // Placed tickets history
  final List<PlacedTicket> _placedTickets = [];
  List<PlacedTicket> get placedTickets => List.unmodifiable(_placedTickets);

  // Transaction Ledger
  final List<WalletTransaction> _transactions = [];
  List<WalletTransaction> get transactions => List.unmodifiable(_transactions);

  // Fixtures from real dataset
  final List<SportFixture> _fixtures = [
    const SportFixture(
      id: 'fix_dinamo_hajduk',
      sport: 'Football',
      league: 'SuperSport HNL (Croatia)',
      homeTeam: 'Dinamo Zagreb',
      awayTeam: 'Hajduk Split',
      startTime: 'In-Play 62\'',
      isLive: true,
      currentScore: '1 - 0',
      minute: '62\'',
      oddsHome: 1.55,
      oddsDraw: 3.60,
      oddsAway: 5.50,
    ),
    const SportFixture(
      id: 'fix_feyenoord_goahead',
      sport: 'Football',
      league: 'Eredivisie (Netherlands)',
      homeTeam: 'Feyenoord Rotterdam',
      awayTeam: 'Go Ahead Eagles',
      startTime: 'Today, 20:45',
      isLive: false,
      oddsHome: 1.35,
      oddsDraw: 5.10,
      oddsAway: 8.20,
    ),
    const SportFixture(
      id: 'fix_lecce_roma',
      sport: 'Football',
      league: 'Serie A (Italy)',
      homeTeam: 'Lecce',
      awayTeam: 'AS Roma',
      startTime: 'Today, 21:00',
      isLive: false,
      oddsHome: 4.20,
      oddsDraw: 3.50,
      oddsAway: 1.92,
    ),
    const SportFixture(
      id: 'fix_alcaraz_sinner',
      sport: 'Tennis',
      league: 'ATP Cincinnati Masters',
      homeTeam: 'Carlos Alcaraz',
      awayTeam: 'Jannik Sinner',
      startTime: 'In-Play Set 2',
      isLive: true,
      currentScore: '6-4, 3-4',
      minute: 'Set 2',
      oddsHome: 1.85,
      oddsDraw: 1.00,
      oddsAway: 1.95,
    ),
    const SportFixture(
      id: 'fix_cibona_zadar',
      sport: 'Basketball',
      league: 'Premijer Liga (Croatia)',
      homeTeam: 'KK Cibona',
      awayTeam: 'KK Zadar',
      startTime: 'Tomorrow, 18:00',
      isLive: false,
      oddsHome: 2.15,
      oddsDraw: 14.50,
      oddsAway: 1.72,
    ),
  ];
  List<SportFixture> get fixtures => List.unmodifiable(_fixtures);

  // Squads
  late final List<Squad> _squads;
  List<Squad> get squads => List.unmodifiable(_squads);

  // Active Squad Battles
  final List<SquadBattle> _squadBattles = [];
  List<SquadBattle> get squadBattles => List.unmodifiable(_squadBattles);

  // Campus Friends available to invite
  final List<CampusFriend> _campusFriends = [
    CampusFriend(
      name: 'Marta_FSB',
      university: 'UniZg (Faculty of Mechanical Engineering)',
      avatar: '👩‍🔬',
      isOnline: true,
    ),
    CampusFriend(
      name: 'Filip_FER',
      university: 'UniZg (Faculty of Electrical Engineering)',
      avatar: '👨‍💻',
      isOnline: true,
    ),
    CampusFriend(
      name: 'Ivan_KIF',
      university: 'UniZg (Faculty of Kinesiology)',
      avatar: '🏃‍♂️',
      isOnline: true,
    ),
    CampusFriend(
      name: 'Elena_UniRi',
      university: 'University of Rijeka (RITEH)',
      avatar: '👩‍🎓',
      isOnline: false,
    ),
    CampusFriend(
      name: 'Duje_Split',
      university: 'University of Split (FESB)',
      avatar: '⚡',
      isOnline: true,
    ),
    CampusFriend(
      name: 'Klara_EFZG',
      university: 'UniZg (Faculty of Economics)',
      avatar: '📈',
      isOnline: true,
    ),
    CampusFriend(
      name: 'Borna_PMF',
      university: 'UniZg (Faculty of Science)',
      avatar: '🔬',
      isOnline: false,
    ),
  ];
  List<CampusFriend> get campusFriends => List.unmodifiable(_campusFriends);

  // Sent Invites
  final List<SquadInvite> _sentInvites = [];
  List<SquadInvite> get sentInvites => List.unmodifiable(_sentInvites);

  // Incoming Invites (received from other players)
  final List<SquadInvite> _incomingInvites = [];
  List<SquadInvite> get incomingInvites => List.unmodifiable(_incomingInvites);

  AppState() {
    _initSquads();
    _initDemoData();
  }

  void _initSquads() {
    _squads = [
      Squad(
        id: 'sq_zagreb_wolves',
        name: 'Zagreb Wolves',
        tag: 'ZGW',
        avatarIcon: '🐺',
        universityAffiliation: 'University of Zagreb (FER/FSB)',
        membersCount: 5,
        wins: 19,
        losses: 5,
        totalEarnings: 2150.00,
        memberNames: ['Luka_Zagreb (You)', 'Petar_FER', 'Ana_PMF', 'Mislav_KIF', 'Iva_TVZ'],
        members: [
          SquadMember(name: 'Luka_Zagreb (You)', university: 'UniZg FER', role: 'Captain', joinedAt: DateTime.now().subtract(const Duration(days: 30))),
          SquadMember(name: 'Petar_FER', university: 'UniZg FER', role: 'Co-Captain', joinedAt: DateTime.now().subtract(const Duration(days: 25))),
          SquadMember(name: 'Ana_PMF', university: 'UniZg PMF', role: 'Member', joinedAt: DateTime.now().subtract(const Duration(days: 14))),
          SquadMember(name: 'Mislav_KIF', university: 'UniZg KIF', role: 'Member', joinedAt: DateTime.now().subtract(const Duration(days: 8))),
          SquadMember(name: 'Iva_TVZ', university: 'TVZ Zagreb', role: 'Member', joinedAt: DateTime.now().subtract(const Duration(days: 3))),
        ],
      ),
      Squad(
        id: 'sq_split_titans',
        name: 'Split Titans',
        tag: 'SPT',
        avatarIcon: '⚡',
        universityAffiliation: 'University of Split (FESB)',
        membersCount: 4,
        wins: 16,
        losses: 7,
        totalEarnings: 1840.00,
        memberNames: ['Toni_FESB', 'Duje_Split', 'Klara_EFST', 'Borna_PMF'],
        members: [
          SquadMember(name: 'Toni_FESB', university: 'UniSt FESB', role: 'Captain', joinedAt: DateTime.now().subtract(const Duration(days: 20))),
          SquadMember(name: 'Duje_Split', university: 'UniSt FESB', role: 'Member', joinedAt: DateTime.now().subtract(const Duration(days: 18))),
          SquadMember(name: 'Klara_EFST', university: 'UniSt EFST', role: 'Member', joinedAt: DateTime.now().subtract(const Duration(days: 10))),
          SquadMember(name: 'Borna_PMF', university: 'UniSt PMF', role: 'Member', joinedAt: DateTime.now().subtract(const Duration(days: 5))),
        ],
      ),
      Squad(
        id: 'sq_rijeka_eagles',
        name: 'Rijeka Eagles',
        tag: 'RJE',
        avatarIcon: '🦅',
        universityAffiliation: 'University of Rijeka (RITEH)',
        membersCount: 3,
        wins: 14,
        losses: 8,
        totalEarnings: 1290.00,
        memberNames: ['Marko_RITEH', 'Elena_UniRi', 'Leo_FMTU'],
        members: [
          SquadMember(name: 'Marko_RITEH', university: 'UniRi RITEH', role: 'Captain', joinedAt: DateTime.now().subtract(const Duration(days: 22))),
          SquadMember(name: 'Elena_UniRi', university: 'UniRi RITEH', role: 'Member', joinedAt: DateTime.now().subtract(const Duration(days: 15))),
          SquadMember(name: 'Leo_FMTU', university: 'UniRi FMTU', role: 'Member', joinedAt: DateTime.now().subtract(const Duration(days: 7))),
        ],
      ),
      Squad(
        id: 'sq_osijek_cyber',
        name: 'Osijek Cyberpunks',
        tag: 'OSC',
        avatarIcon: '🎮',
        universityAffiliation: 'University of Osijek (FERIT)',
        membersCount: 3,
        wins: 15,
        losses: 6,
        totalEarnings: 1680.00,
        memberNames: ['Filip_FERIT', 'Iva_EFOS', 'Dario_PTF'],
        members: [
          SquadMember(name: 'Filip_FERIT', university: 'UNIOS FERIT', role: 'Captain', joinedAt: DateTime.now().subtract(const Duration(days: 28))),
          SquadMember(name: 'Iva_EFOS', university: 'UNIOS EFOS', role: 'Member', joinedAt: DateTime.now().subtract(const Duration(days: 19))),
          SquadMember(name: 'Dario_PTF', university: 'UNIOS PTF', role: 'Member', joinedAt: DateTime.now().subtract(const Duration(days: 11))),
        ],
      ),
    ];
  }

  void _initDemoData() {
    // Initial Squad Battles
    _squadBattles.add(
      SquadBattle(
        battleId: 'bat_derby_clash_01',
        title: 'HNL Super Derby Prediction Clash ⚽',
        gameMode: 'Sports Prediction Clash',
        teamA: _squads[0], // Zagreb Wolves
        teamB: _squads[1], // Split Titans
        entryStakePerPlayer: 10.00,
        totalPrizePool: 160.00,
        doubleWinPayout: 20.00, // 2x double win
        status: SquadBattleStatus.live,
        teamAScore: 4,
        teamBScore: 3,
        startedAt: DateTime.now().subtract(const Duration(minutes: 35)),
      ),
    );

    _squadBattles.add(
      SquadBattle(
        battleId: 'bat_slot_blitz_02',
        title: 'Vegas Bell Link Tournament Blitz 🎰',
        gameMode: 'Casino Slot Tournament Blitz',
        teamA: _squads[0], // Zagreb Wolves
        teamB: _squads[3], // Osijek Cyberpunks
        entryStakePerPlayer: 15.00,
        totalPrizePool: 240.00,
        doubleWinPayout: 30.00, // 2x double win
        status: SquadBattleStatus.waiting,
        teamAScore: 0,
        teamBScore: 0,
        startedAt: DateTime.now(),
      ),
    );

    // Initial incoming invite from another campus friend
    _incomingInvites.add(
      SquadInvite(
        id: 'inv_in_01',
        squadId: 'sq_split_titans',
        squadName: 'Split Titans',
        squadAvatar: '⚡',
        senderName: 'Toni_FESB',
        receiverName: _user.username,
        receiverUniversity: _user.universityName ?? 'UniZg',
        status: InviteStatus.pending,
        sentAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    );

    // Initial past transactions
    _transactions.add(
      WalletTransaction(
        id: 'tx_init_dep',
        type: TransactionType.deposit,
        amount: 100.00,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        title: 'Account Deposit (Aircash)',
        description: 'Instant student top-up deposit',
      ),
    );

    _transactions.add(
      WalletTransaction(
        id: 'tx_init_refund',
        type: TransactionType.studentRefund,
        amount: 37.50,
        timestamp: DateTime.now().subtract(const Duration(hours: 18)),
        title: '🎓 Student 50% Loss Refund',
        description: 'Auto-refunded 50% of €75.00 combo ticket loss',
        referenceId: 'tick_yesterday_01',
      ),
    );
  }

  // --- Auth & Student Verification ---
  void login({
    required String username,
    required bool isStudent,
    String? universityName,
    String? studentIdNumber,
  }) {
    _user = _user.copyWith(
      username: username,
      isStudent: isStudent,
      universityName: isStudent
          ? (universityName ?? 'University of Zagreb (Sveučilište u Zagrebu)')
          : null,
      studentIdNumber: isStudent ? (studentIdNumber ?? '0036592811') : null,
      studentVerifiedAt: isStudent ? DateTime.now() : null,
      activeSquadName: isStudent ? 'Zagreb Wolves 🐺' : null,
    );
    notifyListeners();
  }

  void updateStudentStatus({
    required bool isStudent,
    String? universityName,
    String? studentIdNumber,
  }) {
    _user = _user.copyWith(
      isStudent: isStudent,
      universityName: isStudent ? (universityName ?? 'University of Zagreb') : null,
      studentIdNumber: isStudent ? (studentIdNumber ?? '0036592811') : null,
      studentVerifiedAt: isStudent ? DateTime.now() : null,
    );
    notifyListeners();
  }

  void deposit(double amount) {
    if (amount <= 0) return;
    _user = _user.copyWith(balance: _user.balance + amount);
    _transactions.insert(
      0,
      WalletTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.deposit,
        amount: amount,
        timestamp: DateTime.now(),
        title: 'Deposit Received',
        description: 'Quick top-up added to balance',
      ),
    );
    notifyListeners();
  }

  // --- Betslip & Sportsbook ---
  void toggleSelection(BetSelection selection) {
    final existingIndex = _betslipSelections.indexWhere(
      (s) => s.fixtureId == selection.fixtureId,
    );

    if (existingIndex >= 0) {
      if (_betslipSelections[existingIndex].selectionName == selection.selectionName) {
        _betslipSelections.removeAt(existingIndex);
      } else {
        _betslipSelections[existingIndex] = selection;
      }
    } else {
      _betslipSelections.add(selection);
    }
    notifyListeners();
  }

  bool isSelected(String fixtureId, String selectionName) {
    return _betslipSelections.any(
      (s) => s.fixtureId == fixtureId && s.selectionName == selectionName,
    );
  }

  void clearBetslip() {
    _betslipSelections.clear();
    notifyListeners();
  }

  double calculateTotalOdds() {
    if (_betslipSelections.isEmpty) return 1.0;
    return _betslipSelections.fold(1.0, (acc, s) => acc * s.odds);
  }

  PlacedTicket? placeTicket(double stake) {
    if (stake <= 0 || _user.balance < stake || _betslipSelections.isEmpty) {
      return null;
    }

    final totalOdds = calculateTotalOdds();
    final potentialWin = stake * totalOdds;

    // Deduct balance
    _user = _user.copyWith(balance: _user.balance - stake);

    final ticket = PlacedTicket(
      ticketId: 'PSK-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      placedAt: DateTime.now(),
      selections: List.from(_betslipSelections),
      stake: stake,
      totalOdds: totalOdds,
      potentialWin: potentialWin,
      isStudentProtected: _user.isStudent,
    );

    _placedTickets.insert(0, ticket);

    _transactions.insert(
      0,
      WalletTransaction(
        id: 'tx_bet_${ticket.ticketId}',
        type: TransactionType.betStake,
        amount: -stake,
        timestamp: DateTime.now(),
        title: 'Sports Bet Placed',
        description: '${ticket.selections.length} selections @ ${totalOdds.toStringAsFixed(2)} odds',
        referenceId: ticket.ticketId,
      ),
    );

    _betslipSelections.clear();
    notifyListeners();
    return ticket;
  }

  /// Resolves a placed ticket as Won or Lost.
  /// If Lost and User is Student: fires 50% refund!
  Map<String, dynamic> resolveTicket(String ticketId, bool won) {
    final ticket = _placedTickets.firstWhere(
      (t) => t.ticketId == ticketId,
      orElse: () => throw Exception('Ticket not found'),
    );

    if (ticket.status != TicketStatus.pending) {
      return {'alreadyResolved': true};
    }

    if (won) {
      ticket.status = TicketStatus.won;
      ticket.payoutAmount = ticket.potentialWin;
      _user = _user.copyWith(balance: _user.balance + ticket.potentialWin);

      _transactions.insert(
        0,
        WalletTransaction(
          id: 'tx_win_${ticket.ticketId}',
          type: TransactionType.betWin,
          amount: ticket.potentialWin,
          timestamp: DateTime.now(),
          title: '🎉 Bet Won!',
          description: 'Payout for ticket ${ticket.ticketId}',
          referenceId: ticket.ticketId,
        ),
      );
      notifyListeners();
      return {
        'won': true,
        'payout': ticket.potentialWin,
        'refundAmount': 0.0,
      };
    } else {
      ticket.status = TicketStatus.lost;
      double refund = 0.0;

      if (_user.isStudent) {
        // 50% STUDENT REFUND GUARANTEE!
        refund = ticket.stake * 0.5;
        ticket.refundAmount = refund;
        _user = _user.copyWith(
          balance: _user.balance + refund,
          totalLossRefunded: _user.totalLossRefunded + refund,
        );

        _transactions.insert(
          0,
          WalletTransaction(
            id: 'tx_refund_${ticket.ticketId}',
            type: TransactionType.studentRefund,
            amount: refund,
            timestamp: DateTime.now(),
            title: '🎓 Student 50% Loss Refund',
            description: '50% of €${ticket.stake.toStringAsFixed(2)} stake refunded automatically!',
            referenceId: ticket.ticketId,
          ),
        );
      }
      notifyListeners();
      return {
        'won': false,
        'payout': 0.0,
        'refundAmount': refund,
      };
    }
  }

  // --- Casino Slot Machine & 50% Loss Refund ---
  Map<String, dynamic> playSlotSpin({
    required double stake,
    required bool isWin,
    required double multiplier,
    required String gameName,
  }) {
    if (stake <= 0 || _user.balance < stake) {
      return {'error': 'Insufficient balance'};
    }

    // Deduct stake
    _user = _user.copyWith(balance: _user.balance - stake);

    if (isWin) {
      final winAmount = stake * multiplier;
      _user = _user.copyWith(balance: _user.balance + winAmount);

      _transactions.insert(
        0,
        WalletTransaction(
          id: 'tx_slot_${DateTime.now().millisecondsSinceEpoch}',
          type: TransactionType.slotSpinWin,
          amount: winAmount - stake,
          timestamp: DateTime.now(),
          title: '🎰 $gameName Win!',
          description: 'Spin hit ${multiplier.toStringAsFixed(1)}x multiplier (€${winAmount.toStringAsFixed(2)})',
        ),
      );
      notifyListeners();
      return {
        'won': true,
        'winAmount': winAmount,
        'refundAmount': 0.0,
      };
    } else {
      double refund = 0.0;
      if (_user.isStudent) {
        // 50% STUDENT REFUND ON CASINO LOSS!
        refund = stake * 0.5;
        _user = _user.copyWith(
          balance: _user.balance + refund,
          totalLossRefunded: _user.totalLossRefunded + refund,
        );

        _transactions.insert(
          0,
          WalletTransaction(
            id: 'tx_slot_ref_${DateTime.now().millisecondsSinceEpoch}',
            type: TransactionType.slotSpinStudentRefund,
            amount: refund,
            timestamp: DateTime.now(),
            title: '🎓 Student Shield: 50% Slot Refund',
            description: '50% of €${stake.toStringAsFixed(2)} spin stake refunded!',
          ),
        );
      }
      notifyListeners();
      return {
        'won': false,
        'winAmount': 0.0,
        'refundAmount': refund,
      };
    }
  }

  // --- Squad Battles & 2x Double Win ---
  Squad get currentSquad {
    return _squads.firstWhere(
      (s) => s.id == (_user.activeSquadId ?? 'sq_zagreb_wolves'),
      orElse: () => _squads.first,
    );
  }

  void selectSquad(String squadId) {
    final squad = _squads.firstWhere((s) => s.id == squadId);
    _user = _user.copyWith(
      activeSquadId: squad.id,
      activeSquadName: '${squad.name} ${squad.avatarIcon}',
    );
    notifyListeners();
  }

  /// Sends an invitation to a campus friend to join the user's squad
  SquadInvite sendSquadInvite({
    required String friendName,
    required String friendUni,
  }) {
    final squad = currentSquad;

    final invite = SquadInvite(
      id: 'inv_out_${DateTime.now().millisecondsSinceEpoch}',
      squadId: squad.id,
      squadName: squad.name,
      squadAvatar: squad.avatarIcon,
      senderName: _user.username,
      receiverName: friendName,
      receiverUniversity: friendUni,
      status: InviteStatus.pending,
      sentAt: DateTime.now(),
    );

    _sentInvites.insert(0, invite);

    // Mark in friends list
    final friendIndex = _campusFriends.indexWhere((f) => f.name == friendName);
    if (friendIndex >= 0) {
      _campusFriends[friendIndex].isInvited = true;
    }

    notifyListeners();
    return invite;
  }

  /// Simulates that the friend receives the request and accepts it!
  /// The friend immediately joins the user's squad!
  bool friendAcceptsInvite(String inviteId) {
    final inviteIndex = _sentInvites.indexWhere((inv) => inv.id == inviteId);
    if (inviteIndex < 0) return false;

    final invite = _sentInvites[inviteIndex];
    invite.status = InviteStatus.accepted;

    final squad = _squads.firstWhere((s) => s.id == invite.squadId);

    // Add friend to squad members
    squad.addMember(
      SquadMember(
        name: invite.receiverName,
        university: invite.receiverUniversity,
        role: 'Member',
        joinedAt: DateTime.now(),
        isOnline: true,
      ),
    );

    notifyListeners();
    return true;
  }

  /// Simulates friend declining invite
  void friendDeclinesInvite(String inviteId) {
    final inviteIndex = _sentInvites.indexWhere((inv) => inv.id == inviteId);
    if (inviteIndex >= 0) {
      _sentInvites[inviteIndex].status = InviteStatus.declined;
      notifyListeners();
    }
  }

  /// Accepts an incoming invite to switch squads
  void acceptIncomingInvite(SquadInvite invite) {
    invite.status = InviteStatus.accepted;
    selectSquad(invite.squadId);
    _incomingInvites.removeWhere((i) => i.id == invite.id);
    notifyListeners();
  }

  /// Declines an incoming invite
  void declineIncomingInvite(SquadInvite invite) {
    invite.status = InviteStatus.declined;
    _incomingInvites.removeWhere((i) => i.id == invite.id);
    notifyListeners();
  }

  bool enterSquadBattle(String battleId) {
    final battle = _squadBattles.firstWhere((b) => b.battleId == battleId);
    if (_user.balance < battle.entryStakePerPlayer) {
      return false;
    }

    _user = _user.copyWith(balance: _user.balance - battle.entryStakePerPlayer);

    _transactions.insert(
      0,
      WalletTransaction(
        id: 'tx_sq_entry_${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.squadBattleEntry,
        amount: -battle.entryStakePerPlayer,
        timestamp: DateTime.now(),
        title: '⚔️ Squad Battle Entry',
        description: '${battle.title} entry stake (€${battle.entryStakePerPlayer.toStringAsFixed(2)})',
        referenceId: battle.battleId,
      ),
    );
    notifyListeners();
    return true;
  }

  /// Simulates a squad battle ending. If User's team wins:
  /// Awards 2x Double Payout!
  /// If User's team loses and User is Student: awards 50% loss refund!
  Map<String, dynamic> claimSquadBattleResult(String battleId, {required bool userTeamWon}) {
    final battle = _squadBattles.firstWhere((b) => b.battleId == battleId);
    battle.status = SquadBattleStatus.completed;

    if (userTeamWon) {
      battle.winnerTeamId = battle.teamA.id;
      battle.teamAScore = 5;
      battle.teamBScore = 3;

      final doublePayout = battle.doubleWinPayout; // 2x entry
      _user = _user.copyWith(balance: _user.balance + doublePayout);

      _transactions.insert(
        0,
        WalletTransaction(
          id: 'tx_sq_win_${DateTime.now().millisecondsSinceEpoch}',
          type: TransactionType.squadBattle2xWin,
          amount: doublePayout,
          timestamp: DateTime.now(),
          title: '🏆 SQUAD 2× DOUBLE WIN!',
          description: 'Team victory in ${battle.title}! Double payout awarded (€${doublePayout.toStringAsFixed(2)})',
          referenceId: battle.battleId,
        ),
      );
      notifyListeners();
      return {
        'won': true,
        'payout': doublePayout,
        'refund': 0.0,
      };
    } else {
      battle.winnerTeamId = battle.teamB.id;
      battle.teamAScore = 2;
      battle.teamBScore = 4;

      double refund = 0.0;
      if (_user.isStudent) {
        refund = battle.entryStakePerPlayer * 0.5;
        _user = _user.copyWith(
          balance: _user.balance + refund,
          totalLossRefunded: _user.totalLossRefunded + refund,
        );

        _transactions.insert(
          0,
          WalletTransaction(
            id: 'tx_sq_ref_${DateTime.now().millisecondsSinceEpoch}',
            type: TransactionType.studentRefund,
            amount: refund,
            timestamp: DateTime.now(),
            title: '🎓 Student Shield: 50% Battle Refund',
            description: '50% of €${battle.entryStakePerPlayer.toStringAsFixed(2)} squad entry refunded!',
            referenceId: battle.battleId,
          ),
        );
      }
      notifyListeners();
      return {
        'won': false,
        'payout': 0.0,
        'refund': refund,
      };
    }
  }
}
