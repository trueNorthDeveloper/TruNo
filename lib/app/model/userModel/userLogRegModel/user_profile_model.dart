class UserProfileModel {
  String empEmail;
  String empName;
  String empRole;
  String imageURL;
  String empPhone;
  String empId;
  String empDesignation;

  UserProfileModel(
      {required this.empEmail,
      required this.empDesignation,
      required this.empId,
      required this.empName,
      required this.empPhone,
      required this.empRole,
      required this.imageURL});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
        empEmail: json["empEmail"] ?? " ",
        empDesignation: json["empDesignation"] ?? " ",
        empId: json["empId"] ?? " ",
        empName: json["empName"] ?? " ",
        empPhone: json["empPhone"] ?? " ",
        empRole: json["empRole"],
        imageURL: json["imageURL"]);
  }
}
