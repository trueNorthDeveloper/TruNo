class UserLeaveLogs {
  final bool? success;
  final String? message;
  final LeaveData? data;

  UserLeaveLogs({this.success, this.message, this.data});

  factory UserLeaveLogs.fromJson(Map<String, dynamic> json) {
    return UserLeaveLogs(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null ? LeaveData.fromJson(json['data']) : null,
    );
  }
}

class LeaveData {
  final AllotedLeaves? alloted;
  final BalancedLeaves? balance;
  final UsedLeaves? used;

  LeaveData({this.alloted, this.balance, this.used});

  factory LeaveData.fromJson(Map<String, dynamic> json) {
    return LeaveData(
      alloted: json['alloted'] != null
          ? AllotedLeaves.fromJson(json['alloted'])
          : null,
      balance: json['balance'] != null
          ? BalancedLeaves.fromJson(json['balance'])
          : null,
      used: json['used'] != null ? UsedLeaves.fromJson(json['used']) : null,
    );
  }
}

class AllotedLeaves {
  final int? allotedCl;
  final int? alllotedMl;

  AllotedLeaves({this.allotedCl, this.alllotedMl});

  factory AllotedLeaves.fromJson(Map<String, dynamic> json) {
    return AllotedLeaves(
      allotedCl: json['allotedCl'] ?? 0,
      alllotedMl: json['alllotedMl'] ?? 0,
    );
  }
}

class BalancedLeaves {
  final int? balancedCl;
  final int? balancedMl;
  final int? balancedLwp;

  BalancedLeaves({this.balancedCl, this.balancedMl, this.balancedLwp});

  factory BalancedLeaves.fromJson(Map<String, dynamic> json) {
    return BalancedLeaves(
      balancedCl: json['balancedCl'] ?? 0,
      balancedMl: json['balancedMl'] ?? 0,
      balancedLwp: json['balancedLwp'] ?? 0,
    );
  }
}

class UsedLeaves {
  final int? usedCl;
  final int? usedMl;
  final int? usedLwp;

  UsedLeaves({this.usedCl, this.usedMl, this.usedLwp});

  factory UsedLeaves.fromJson(Map<String, dynamic> json) {
    return UsedLeaves(
      usedCl: json['usedCl'] ?? 0,
      usedMl: json['usedMl'] ?? 0,
      usedLwp: json['usedLwp'] ?? 0,
    );
  }
}
