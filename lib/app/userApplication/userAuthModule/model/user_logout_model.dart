class LogoutModel {
  int? userId;
  String logoutAddress;
  String logoutLatitude;
  String logoutLongitude;
  String logoutDeviceId;
  String logoutDeviceModel;
  String logoutDeviceBrand;
  String logoutModel;
  String? logOutExcuse;
  String? empEid;

   LogoutImage? logoutimage;

  LogoutModel(
      {this.userId,
      required this.logoutAddress,
      required this.logoutLatitude,
      required this.logoutLongitude,
      required this.logoutDeviceBrand,
      required this.logoutDeviceId,
      required this.logoutDeviceModel,
      required this.logoutModel,
       this.logoutimage,
       this.logOutExcuse,
       this.empEid});

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "logoutAddress": logoutAddress,
        "logoutLatitude": logoutLatitude,
        "logoutLongitude": logoutLongitude,
        "logoutDeviceId": logoutDeviceId,
        "logoutDeviceModel": logoutDeviceModel,
        "logoutModel": logoutDeviceModel,
         "logoutImage": logoutimage!.toJson(),
        "logOutExcuse": logOutExcuse,
        "empEid": empEid
      };
}

class LogoutImage {
  int? imageId;

  LogoutImage({this.imageId});
  Map<String, dynamic> toJson() => {
        "imageId": imageId,
      };
}
