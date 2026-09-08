enum SquadBattleStatus { waiting, live, completed }
enum InviteStatus { pending, accepted, declined }

class SquadMember {
  final String name;
  final String university;
  final String role; // 'Captain' | 'Co-Captain' | 'Member'
  final DateTime joinedAt;
  final bool isOnline;

  const SquadMember({
    required this.name,
    required this.university,
    this.role = 'Member',
    required this.joinedAt,
    this.isOnline = true,
  });
}

class SquadInvite {
  final String id;
  final String squadId;
  final String squadName;
  final String squadAvatar;
  final String senderName;
  final String receiverName;
  final String receiverUniversity;
  InviteStatus status;
  final DateTime sentAt;

  SquadInvite({
    required this.id,
    required this.squadId,
    required this.squadName,
    required this.squadAvatar,
    required this.senderName,
    required this.receiverName,
    required this.receiverUniversity,
    this.status = InviteStatus.pending,
    required this.sentAt,
  });
}

class CampusFriend {
  final String name;
  final String university;
  final String avatar;
  final bool isOnline;
  bool isInvited;

  CampusFriend({
    required this.name,
    required this.university,
    required this.avatar,
    this.isOnline = true,
    this.isInvited = false,
  });
}

class Squad {
  final String id;
  final String name;
  final String tag;
  final String avatarIcon;
  final String universityAffiliation;
  int membersCount;
  final int wins;
  final int losses;
  final double totalEarnings;
  final List<String> memberNames;
  final List<SquadMember> members;

  Squad({
    required this.id,
    required this.name,
    required this.tag,
    required this.avatarIcon,
    required this.universityAffiliation,
    this.membersCount = 5,
    this.wins = 12,
    this.losses = 4,
    this.totalEarnings = 1420.00,
    required this.memberNames,
    required this.members,
  });

  void addMember(SquadMember member) {
    if (!memberNames.contains(member.name)) {
      memberNames.add(member.name);
      members.add(member);
      membersCount = memberNames.length;
    }
  }
}

class SquadBattle {
  final String battleId;
  final String title;
  final String gameMode; // 'Derby Prediction Clash' or 'Slot Tournament Blitz'
  final Squad teamA;
  final Squad teamB;
  final double entryStakePerPlayer;
  final double totalPrizePool;
  final double doubleWinPayout; // entryStakePerPlayer * 2
  SquadBattleStatus status;
  int teamAScore;
  int teamBScore;
  String? winnerTeamId;
  DateTime startedAt;

  SquadBattle({
    required this.battleId,
    required this.title,
    required this.gameMode,
    required this.teamA,
    required this.teamB,
    required this.entryStakePerPlayer,
    required this.totalPrizePool,
    required this.doubleWinPayout,
    this.status = SquadBattleStatus.waiting,
    this.teamAScore = 0,
    this.teamBScore = 0,
    this.winnerTeamId,
    required this.startedAt,
  });
}
