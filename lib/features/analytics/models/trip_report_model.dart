// lib/features/analytics/models/trip_report_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class TripReport {
  final String id;
  final String driverName;
  final String billedVehicle;
  final String source;
  final String destination;
  final String consignor;
  final String consignee;
  final String tripStatus;
  final String tripType;
  final DateTime tripDate;
  final DateTime createdAt;
  final bool inReview;
  final int distance;
  final String remarks;

  TripReport({
    required this.id,
    required this.driverName,
    required this.billedVehicle,
    required this.source,
    required this.destination,
    required this.consignor,
    required this.consignee,
    required this.tripStatus,
    required this.tripType,
    required this.tripDate,
    required this.createdAt,
    required this.inReview,
    required this.distance,
    required this.remarks,
  });

  factory TripReport.fromFirestore(String id, Map<String, dynamic> data) {
    return TripReport(
      id: id,
      driverName: (data['driver_name'] ?? '').toString(),
      billedVehicle: (data['billed_vehicle'] ?? '').toString(),
      source: (data['source'] ?? '').toString(),
      destination: (data['destination'] ?? '').toString(),
      consignor: (data['consignor'] ?? '').toString(),
      consignee: (data['consignee'] ?? '').toString(),
      tripStatus: (data['trip_status'] ?? 'open').toString(),
      tripType: (data['trip_type'] ?? '').toString(),
      tripDate: (data['trip_date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      inReview: data['in_review'] == true,
      distance: (data['distance'] as num?)?.toInt() ?? 0,
      remarks: (data['remarks'] ?? '').toString(),
    );
  }

  bool get isCompleted => tripStatus.toLowerCase() == 'completed';
  bool get isPending => tripStatus.toLowerCase() == 'open';
  String get route => '$source → $destination';
}

class VehicleStats {
  final String vehicle;
  final int trips;
  VehicleStats(this.vehicle, this.trips);
}

class DriverPerformance {
  final String name;
  final int totalTrips;
  final int completedTrips;

  DriverPerformance(this.name, this.totalTrips, this.completedTrips);

  int get completionRate => totalTrips > 0 ? ((completedTrips / totalTrips) * 100).round() : 0;
}