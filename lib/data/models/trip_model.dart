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

  TripModel({
    required this.billedTo,
    required this.billedVehicle,
    required this.driverName,
    required this.source,
    required this.destination,
    required this.tripDate,
    required this.tripType,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'billedTo': billedTo,
      'billedVehicle': billedVehicle,
      'driverName': driverName,
      'source': source,
      'destination': destination,
      'tripDate': Timestamp.fromDate(tripDate),
      'status': status,
      'tripType' : tripType
    };
  }
}
