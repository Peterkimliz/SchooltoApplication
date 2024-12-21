class VehicleModel {
  String? id;
  String? vehicleType;
  String? vehiclePlate;

  VehicleModel({this.id, this.vehiclePlate, this.vehicleType});

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json["id"],
        vehicleType: json["vehicleType"],
        vehiclePlate: json["vehiclePlate"],
      );
}
