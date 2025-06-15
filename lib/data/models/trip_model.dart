import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  String billedTo;
  String billedVehicle;
  String driverName;
  String source;
  String destination;
  DateTime tripDate;
  String tripType;
  String status;
  String createdBy;

  // Optional field, not part of constructor
  DateTime? createdAt;

  TripModel({
    required this.billedTo,
    required this.billedVehicle,
    required this.driverName,
    required this.source,
    required this.destination,
    required this.tripDate,
    required this.tripType,
    required this.createdBy,
    this.status = 'pending',
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      billedTo: json['billedTo'] ?? '',
      billedVehicle: json['billedVehicle'] ?? '',
      driverName: json['driverName'] ?? '',
      source: json['source'] ?? '',
      destination: json['destination'] ?? '',
      tripDate: (json['tripDate'] as Timestamp).toDate(),
      tripType: json['tripType'] ?? '',
      status: json['status'] ?? '',
      createdBy: json['createdBy'] ?? '',
    )..createdAt = (json['createdAt'] as Timestamp?)?.toDate(); // set after constructor
  }

  Map<String, dynamic> toMap() {
    return {
      'billedTo': billedTo,
      'billedVehicle': billedVehicle,
      'driverName': driverName,
      'source': source,
      'destination': destination,
      'tripDate': Timestamp.fromDate(tripDate),
      'tripType': tripType,
      'status': status,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
