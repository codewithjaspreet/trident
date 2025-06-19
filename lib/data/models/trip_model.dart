import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trident/data/models/trip_stage_model.dart';

class TripModel {
  String billedTo;
  String billedVehicle;
  String driverName;
  String source;
  String destination;
  String tripType;
  String status;
  String createdBy;
  String? currentStage;
  DateTime? tripDate;
  DateTime? createdAt;
  DateTime? completedAt;
  List<TripStageModel> stages;

  TripModel({
    required this.billedTo,
    required this.billedVehicle,
    required this.driverName,
    required this.source,
    required this.destination,
    required this.tripType,
    required this.createdBy,
    this.status = 'pending',
    this.currentStage,
    this.tripDate,
    this.createdAt,
    this.completedAt,
    this.stages = const [],
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      billedTo: json['billed_to'] ?? '',
      billedVehicle: json['billed_vehicle'] ?? '',
      driverName: json['driver_name'] ?? '',
      source: json['sources'] ?? '',
      destination: json['destination'] ?? '',
      tripType: json['trip_type'] ?? '',
      status: json['trip_status'] ?? '',
      createdBy: json['created_by'] ?? '',
      createdAt: (json['created_at'] as Timestamp?)?.toDate(),
      stages: (json['stages'] as List<dynamic>?)
          ?.map((e) => TripStageModel.fromMap(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'billed_to': billedTo,
      'billed_vehicle': billedVehicle,
      'driver_name': driverName,
      'sources': source,
      'destination': destination,
      'trip_type': tripType,
      'trip_status': status,
      'created_by': createdBy,
      'created_at': FieldValue.serverTimestamp(),
      'stages': stages.map((s) => s.toMap()).toList(),
    };
  }
}
