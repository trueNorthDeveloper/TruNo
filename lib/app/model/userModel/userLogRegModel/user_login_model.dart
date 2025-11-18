class LoginRequestModel {
  String empLoginId;
  String empPassword;
  
  String device;
  String deviceId;
  String deviceBrand;
  String model;
  String latitude;
  String longitude;
  String address;
  LoginImage loginImage;

  LoginRequestModel({
    required this.empLoginId,
    required this.empPassword,
    
    required this.device,
    required this.deviceId,
    required this.deviceBrand,
    required this.model,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.loginImage,
  });
  Map<String, dynamic> toJson() => {
        "empLoginId": empLoginId,
        "empPassword": empPassword,
        
        "device": device,
        "deviceId": deviceId,
        "deviceBrand": deviceBrand,
        "model": model,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "loginImage": loginImage.toJson(),
      };
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      LoginRequestModel(
        empLoginId: json["empLoginId"],
        empPassword: json["empPassword"],

        device: json["device"],
        deviceId: json["deviceId"],
        deviceBrand: json["deviceBrand"],
        model: json["model"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        address: json["address"],
        loginImage: LoginImage.fromJson(json["loginImage"]),
      );
      
}

class LoginImage {
  int imageId;

  LoginImage({required this.imageId});

  Map<String, dynamic> toJson() => {
        "imageId": imageId,
      };

  factory LoginImage.fromJson(Map<String, dynamic> json) => LoginImage(
        imageId: json["imageId"],
      );
}

class LoginResponseModel {
  bool success;
  String message;
  LoginData data;
  DateTime date;
  LoginResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.date,
  });
 factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
  return LoginResponseModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: json["data"] != null && json["data"] is Map<String, dynamic>
        ? LoginData.fromJson(json["data"])
        : LoginData(empId: "", uuid: 0, empName: "", role: "", sessionId: ""),
    date: DateTime.tryParse(json["date"] ?? "") ?? DateTime.now(),
  );
}


  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
        "date": date.toIso8601String(),
      };
}

class LoginData {
  String empId;
  int uuid;
  String empName;
  String role;
  String sessionId;

  LoginData({
    required this.empId,
    required this.uuid,
    required this.empName,
    required this.role,
    required this.sessionId,
  });

 factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
      empId: json["EmpID"] ?? "", // Case-sensitive!
      uuid: json["uuid"] ?? 0,
      empName: json["empName"] ?? "",
      role: json["empRole"] ?? "", // Handle mismatch
      sessionId: json["sessionId"] ?? "",
    );

  Map<String, dynamic> toJson() => {
        "empId": empId,
        "uuid": uuid,
        "empName": empName,
        "role": role,
        "sessionId": sessionId,
      };
}
