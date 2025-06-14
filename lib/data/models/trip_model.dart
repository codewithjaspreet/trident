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
      destination: json['destination'] ?? '',
      driverName: json['driverName'] ?? '',
      source: json['source'] ?? '',
      status: json['status'] ?? '',
      tripDate: (json['tripDate'] as Timestamp).toDate(),
      tripType: json['tripType'] ?? '',
      createdBy: json['createdBy'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'billedTo': billedTo,
      'billedVehicle': billedVehicle,
      'driverName': driverName,
      'source': source,
      'destination': destination,
      'tripDate': Timestamp.fromDate(tripDate),
      'status': status,
      'tripType' : tripType,
      'createdBy' : createdBy
    };
  }
}
