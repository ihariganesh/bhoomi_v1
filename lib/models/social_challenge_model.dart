/// Team and Social Challenges System
/// Group goals with family, campus, office teams

class TeamChallenge {
  final String id;
  final String name;
  final String description;
  final TeamType type;
  final List<String> memberIds;
  final int goalPoints;
  final int currentPoints;
  final double goalCO2;
  final double currentCO2;
  final DateTime startDate;
  final DateTime endDate;
  final String? imageUrl;

  TeamChallenge({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.memberIds,
    required this.goalPoints,
    this.currentPoints = 0,
    required this.goalCO2,
    this.currentCO2 = 0,
    required this.startDate,
    required this.endDate,
    this.imageUrl,
  });

  double get progress => (currentPoints / goalPoints * 100).clamp(0, 100);
  bool get isCompleted => currentPoints >= goalPoints;
  bool get isActive =>
      DateTime.now().isBefore(endDate) && DateTime.now().isAfter(startDate);
}

class Team {
  final String id;
  final String name;
  final TeamType type;
  final List<TeamMember> members;
  final int totalPoints;
  final double totalCO2Saved;
  final int rank;
  final List<TeamChallenge> challenges;

  Team({
    required this.id,
    required this.name,
    required this.type,
    required this.members,
    this.totalPoints = 0,
    this.totalCO2Saved = 0,
    this.rank = 0,
    this.challenges = const [],
  });
}

class TeamMember {
  final String id;
  final String name;
  final String avatarUrl;
  final int points;
  final double co2Saved;
  final bool isLeader;

  TeamMember({
    required this.id,
    required this.name,
    this.avatarUrl = '',
    this.points = 0,
    this.co2Saved = 0,
    this.isLeader = false,
  });
}

enum TeamType { family, friends, office, campus, community }

/// Verified Community Impact
/// Photo upload and GPS validation for events

class VerifiedImpact {
  final String id;
  final String eventId;
  final String userId;
  final ImpactType type;
  final String? photoPath;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final VerificationStatus status;
  final String? notes;
  final int pointsEarned;
  final double co2Impact;

  VerifiedImpact({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.type,
    this.photoPath,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.status = VerificationStatus.pending,
    this.notes,
    this.pointsEarned = 0,
    this.co2Impact = 0,
  });

  bool get isVerified => status == VerificationStatus.verified;
  bool get isPending => status == VerificationStatus.pending;
}

enum ImpactType { cleanup, treePlantation, composting, recycling, awareness }

enum VerificationStatus { pending, verified, rejected }

/// Leaderboard
class Leaderboard {
  final List<LeaderboardEntry> entries;
  final LeaderboardType type;
  final DateTime period;

  Leaderboard({
    required this.entries,
    required this.type,
    required this.period,
  });
}

class LeaderboardEntry {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int rank;
  final int points;
  final double co2Saved;
  final String? teamName;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.rank,
    required this.points,
    required this.co2Saved,
    this.teamName,
  });
}

enum LeaderboardType { individual, team, city, national }
