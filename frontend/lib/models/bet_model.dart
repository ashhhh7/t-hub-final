enum TicketStatus { pending, won, lost }

class SportFixture {
  final String id;
  final String sport;
  final String league;
  final String homeTeam;
  final String awayTeam;
  final String startTime;
  final bool isLive;
  final String? currentScore;
  final String? minute;
  final double oddsHome;
  final double oddsDraw;
  final double oddsAway;

  const SportFixture({
    required this.id,
    required this.sport,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.startTime,
    this.isLive = false,
    this.currentScore,
    this.minute,
    required this.oddsHome,
    required this.oddsDraw,
    required this.oddsAway,
  });
}

class BetSelection {
  final String fixtureId;
  final String fixtureName;
  final String league;
  final String marketName;
  final String selectionName;
  final double odds;

  const BetSelection({
    required this.fixtureId,
    required this.fixtureName,
    required this.league,
    required this.marketName,
    required this.selectionName,
    required this.odds,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BetSelection &&
          runtimeType == other.runtimeType &&
          fixtureId == other.fixtureId &&
          selectionName == other.selectionName;

  @override
  int get hashCode => fixtureId.hashCode ^ selectionName.hashCode;
}

class PlacedTicket {
  final String ticketId;
  final DateTime placedAt;
  final List<BetSelection> selections;
  final double stake;
  final double totalOdds;
  final double potentialWin;
  final bool isStudentProtected;
  TicketStatus status;
  double payoutAmount;
  double refundAmount;

  PlacedTicket({
    required this.ticketId,
    required this.placedAt,
    required this.selections,
    required this.stake,
    required this.totalOdds,
    required this.potentialWin,
    required this.isStudentProtected,
    this.status = TicketStatus.pending,
    this.payoutAmount = 0.0,
    this.refundAmount = 0.0,
  });
}
