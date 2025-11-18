class LogoutModel {
  int userId;
  String logoutAddress;
  String logoutLatitude;
  String logoutLongitude;
  String logoutDeviceId;
  String logoutDeviceModel;
  String logoutDeviceBrand;
  String logoutModel;
  LogoutImage logoutimage;
  LogoutModel({
    required this.userId,
    required this.logoutAddress,
    required this.logoutLatitude,
    required this.logoutLongitude,
    required this.logoutDeviceBrand,
    required this.logoutDeviceId,
    required this.logoutDeviceModel,
    required this.logoutModel,
    required this.logoutimage,
  });
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "logoutAddress": logoutAddress,
        "logoutLatitude": logoutLatitude,
        "logoutLongitude": logoutLongitude,
        "logoutDeviceId": logoutDeviceId,
        "logoutDeviceModel": logoutDeviceModel,
        "logoutModel": logoutDeviceModel,
        "logoutImage": logoutimage.toJson()
      };
}

class LogoutImage {
  int imageId;

  LogoutImage({required this.imageId});
  Map<String, dynamic> toJson() => {
        "imageId": imageId,
      };
}
