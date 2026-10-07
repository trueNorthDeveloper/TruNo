class UserLocationModel {
  final String id;
  final String name;
  final double lat;
  final double lng;

  UserLocationModel(
      {required this.id,
      required this.name,
      required this.lat,
      required this.lng});

  factory UserLocationModel.fromJson(Map<String, dynamic> json) {
    return UserLocationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      lat: json['lat'] as double,
      lng: json['lng'] as double,
    );
  }

 
}
