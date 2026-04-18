class LogoutRequestModel {
  String logoutAddress;
  String logoutLatitude;
  String logoutLongitude;
  String logoutDeviceId;
  String logoutDeviceModel;
  String logoutDeviceBrand;
  String logoutModel;
  String? logOutExcuse;
  String? empEid;

  LogoutRequestModel({
    required this.logoutAddress,
    required this.logoutLatitude,
    required this.logoutLongitude,
    required this.logoutDeviceId,
    required this.logoutDeviceModel,
    required this.logoutDeviceBrand,
    required this.logoutModel,
    this.logOutExcuse,
    this.empEid,
  });

  Map<String, dynamic> toJson() => {
        "logoutAddress": logoutAddress,
        "logoutLatitude": logoutLatitude,
        "logoutLongitude": logoutLongitude,
        "logoutDeviceId": logoutDeviceId,
        "logoutDeviceModel": logoutDeviceModel,
        "logoutDeviceBrand": logoutDeviceBrand,
        "logoutModel": logoutModel,
        "logOutExcuse": logOutExcuse,
        "empEid": empEid,
      };
}
