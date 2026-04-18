

class UserRegistration {
  final int uuid;
  final String empId;
  final String empName;
  final DateTime? empDob;
  final String? empEmail;
  final DateTime? joinDate;
  final String? empDesignation;
  final String? empSystemName;
  final String? empSystemType;
  final String? empWorkingType;
  final int empCl;
  final int empMl;
  final String? empPassword;
  final String? empMobile;
  final String? empWorkingLocation;
  final DateTime? createdDate;
  final String? role;
  final int curcl;
  final int cuml;
  final int curlwp;
  final int nextcl;
  final int nextml;
  final String? userInterface;
  final String? workStatus;
  // //final ImageMaster? profileImage;
 // final ImageMaster? signImage;

  UserRegistration({
    required this.uuid,
    required this.empId,
    required this.empName,
   required this.empDob,
   required this.empEmail,
  required  this.joinDate,
  required  this.empDesignation,
 required   this.empSystemName,
  required  this.empSystemType,
 required   this.empWorkingType,
    required this.empCl,
    required this.empMl,
   required this.empPassword,
 required   this.empMobile,
required    this.empWorkingLocation,
  required  this.createdDate,
  required  this.role,
    required this.curcl,
    required this.cuml,
    required this.curlwp,
    required this.nextcl,
    required this.nextml,
  required  this.userInterface,
  required  this.workStatus,
   // this.profileImage,
    //this.signImage,
  });

  // factory UserRegistration.fromJson(Map<String, dynamic> json, [Map<String, Object>? map]) {
  //   return UserRegistration(
  //     uuid: json['uuid'],
  //     empId: json['empId'],
  //     empName: json['empName'],
      
  //     empDob: json['empDob'] != null ? DateTime.parse(json['empDob']) : null,
  //     empEmail: json['empEmail'],
  //     joinDate: json['joinDate'] != null ? DateTime.parse(json['joinDate']) : null,
  //     empDesignation: json['empDesignation'],
  //     empSystemName: json['empSystemName'],
  //     empSystemType: json['empSystemType'],
  //     empWorkingType: json['empWorkingType'],
  //     empCl: json['empCl'] ?? 0,
  //     empMl: json['empMl'] ?? 0,
  //     empPassword: json['empPassword'],
  //     empMobile: json['empMobile'],
  //     empWorkingLocation: json['empWorkingLocation'],
  //     createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : null,
  //     role: json['role'],
  //     curcl: json['curcl'] ?? 0,
  //     cuml: json['cuml'] ?? 0,
  //     curlwp: json['curlwp'] ?? 0,
  //     nextcl: json['nextcl'] ?? 0,
  //     nextml: json['nextml'] ?? 0,
  //     userInterface: json['userInterface'],
  //     workStatus: json['workStatus'],
  //    // profileImage: json['profileImage'] != null
  //     //     ? ImageMaster.fromJson(json['profileImage'])
  //     //     : null,
  //     // signImage: json['signImage'] != null
  //     //     ? ImageMaster.fromJson(json['signImage'])
  //     //     : null,
  //   );
  // }
}

// class ImageMaster {
//   final int id;
//   final String imageUrl;

//   ImageMaster({required this.id, required this.imageUrl});

//   factory ImageMaster.fromJson(Map<String, dynamic> json) {
//     return ImageMaster(
//       id: json['id'],
//       imageUrl: json['imageUrl'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'imageUrl': imageUrl,
//     };
//   }
// }
