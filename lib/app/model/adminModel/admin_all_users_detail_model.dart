class User {
  final int uuid;
  final String empId;
  final String empName;
  final String empDob;
  final String empEmail;
  final String joinDate;
  final String empDesignation;
  final String empSystemName;
  final String empSystemType;
  final String empWorkingType;
  final int empCl;
  final int empMl;
  final String empPassword;
  final String empMobile;
  final String empWorkingLocation;
  final String createdDate;
  final String role;
  final int curcl;
  final int cuml;
  final int curlwp;
  final int nextcl;
  final int nextml;
  final String? userInterface;
  final String workStatus;
 // final ImageData? profileImage;
  //final ImageData? signImage;

  User({
    required this.uuid,
    required this.empId,
    required this.empName,
    required this.empDob,
    required this.empEmail,
    required this.joinDate,
    required this.empDesignation,
    required this.empSystemName,
    required this.empSystemType,
    required this.empWorkingType,
    required this.empCl,
    required this.empMl,
    required this.empPassword,
    required this.empMobile,
    required this.empWorkingLocation,
    required this.createdDate,
    required this.role,
    required this.curcl,
    required this.cuml,
    required this.curlwp,
    required this.nextcl,
    required this.nextml,
    this.userInterface,
    required this.workStatus,
   // this.profileImage,
    //this.signImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['uuid'],
      empId: json['empId'],
      empName: json['empName'],
      empDob: json['empDob'],
      empEmail: json['empEmail'],
      joinDate: json['joinDate'],
      empDesignation: json['empDesignation'],
      empSystemName: json['empSystemName'],
      empSystemType: json['empSystemType'],
      empWorkingType: json['empWorkingType'],
      empCl: json['empCl'],
      empMl: json['empMl'],
      empPassword: json['empPassword'],
      empMobile: json['empMobile'],
      empWorkingLocation: json['empWorkingLocation'],
      createdDate: json['createdDate'],
      role: json['role'],
      curcl: json['curcl'],
      cuml: json['cuml'],
      curlwp: json['curlwp'],
      nextcl: json['nextcl'],
      nextml: json['nextml'],
      userInterface: json['userInterface'],
      workStatus: json['workStatus'],
      // profileImage: json['profileImage'] != null
      //     ? ImageData.fromJson(json['profileImage'])
      //     : null,
      // signImage: json['signImage'] != null
      //     ? ImageData.fromJson(json['signImage'])
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'empId': empId,
      'empName': empName,
      'empDob': empDob,
      'empEmail': empEmail,
      'joinDate': joinDate,
      'empDesignation': empDesignation,
      'empSystemName': empSystemName,
      'empSystemType': empSystemType,
      'empWorkingType': empWorkingType,
      'empCl': empCl,
      'empMl': empMl,
      'empPassword': empPassword,
      'empMobile': empMobile,
      'empWorkingLocation': empWorkingLocation,
      'createdDate': createdDate,
      'role': role,
      'curcl': curcl,
      'cuml': cuml,
      'curlwp': curlwp,
      'nextcl': nextcl,
      'nextml': nextml,
      'userInterface': userInterface,
      'workStatus': workStatus,
      // 'profileImage': profileImage?.toJson(),
      // 'signImage': signImage?.toJson(),
    };
  }
}

class ImageData {
  final int imageId;
  final String? imageName;
  final String linkId;
  final String rootFolderId;
  final String folderId;
  final String driveImageId;
  final String imageUrl;
  final String? directImageUrl;
  final String entityType;
  final String uploadedAt;

  ImageData({
    required this.imageId,
    this.imageName,
    required this.linkId,
    required this.rootFolderId,
    required this.folderId,
    required this.driveImageId,
    required this.imageUrl,
    this.directImageUrl,
    required this.entityType,
    required this.uploadedAt,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      imageId: json['imageId'],
      imageName: json['imageName'],
      linkId: json['linkId'],
      rootFolderId: json['rootFolderId'],
      folderId: json['folderId'],
      driveImageId: json['driveImageId'],
      imageUrl: json['imageUrl'],
      directImageUrl: json['directImageUrl'],
      entityType: json['entityType'],
      uploadedAt: json['uploadedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageId': imageId,
      'imageName': imageName,
      'linkId': linkId,
      'rootFolderId': rootFolderId,
      'folderId': folderId,
      'driveImageId': driveImageId,
      'imageUrl': imageUrl,
      'directImageUrl': directImageUrl,
      'entityType': entityType,
      'uploadedAt': uploadedAt,
    };
  }
}
//  void main() {
//   String jsonStr = '''[ ...your JSON string here... ]''';
//   List<dynamic> data = jsonDecode(jsonStr);
//   List<User> users = data.map((e) => User.fromJson(e)).toList();

//   print(users.first.empName); // Output: Navendra
// }