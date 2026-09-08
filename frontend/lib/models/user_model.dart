class UserProfile {
  final String id;
  final String username;
  final String email;
  final bool isStudent;
  final String? universityName;
  final String? studentIdNumber;
  final DateTime? studentVerifiedAt;
  final bool is18PlusVerified;
  final double balance;
  final double totalLossRefunded;
  final String? activeSquadId;
  final String? activeSquadName;

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.isStudent = false,
    this.universityName,
    this.studentIdNumber,
    this.studentVerifiedAt,
    this.is18PlusVerified = true,
    this.balance = 150.00,
    this.totalLossRefunded = 0.0,
    this.activeSquadId,
    this.activeSquadName,
  });

  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
    bool? isStudent,
    String? universityName,
    String? studentIdNumber,
    DateTime? studentVerifiedAt,
    bool? is18PlusVerified,
    double? balance,
    double? totalLossRefunded,
    String? activeSquadId,
    String? activeSquadName,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      isStudent: isStudent ?? this.isStudent,
      universityName: universityName ?? this.universityName,
      studentIdNumber: studentIdNumber ?? this.studentIdNumber,
      studentVerifiedAt: studentVerifiedAt ?? this.studentVerifiedAt,
      is18PlusVerified: is18PlusVerified ?? this.is18PlusVerified,
      balance: balance ?? this.balance,
      totalLossRefunded: totalLossRefunded ?? this.totalLossRefunded,
      activeSquadId: activeSquadId ?? this.activeSquadId,
      activeSquadName: activeSquadName ?? this.activeSquadName,
    );
  }
}
