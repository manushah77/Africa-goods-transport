import 'dart:convert';
import 'package:http/http.dart' as http;

class VehicleRequest {
  final int userId;
  final String name;
  final String address;
  final String personStatus;
  final String vehicle;
  final String vehicleType;
  final String pickUp;
  final String dropOff;
  final int requestStatus;
  final String phone;
  final int vOwnerId;
  final int phoneOpt;
  final String note;

  VehicleRequest({
    required this.userId,
    required this.name,
    required this.address,
    required this.personStatus,
    required this.vehicle,
    required this.vehicleType,
    required this.pickUp,
    required this.dropOff,
    required this.requestStatus,
    required this.phone,
    required this.vOwnerId,
    required this.phoneOpt,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'address': address,
      'personStatus': personStatus,
      'vehicle': vehicle,
      'vehicleType': vehicleType,
      'pickUp': pickUp,
      'dropOff': dropOff,
      'requestStatus': requestStatus,
      'phone': phone,
      'vOwnerId': vOwnerId,
      'phoneOpt': phoneOpt,
      'note': note,
    };
  }
}