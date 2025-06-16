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
    this.stages = const [],
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      billedTo: json['billedTo'] ?? '',
      billedVehicle: json['billedVehicle'] ?? '',
      driverName: json['driverName'] ?? '',
      source: json['source'] ?? '',
      destination: json['destination'] ?? '',
      tripType: json['tripType'] ?? '',
      status: json['status'] ?? '',
      createdBy: json['createdBy'] ?? '',
      currentStage: json['currentStage'],
      tripDate: (json['tripDate'] as Timestamp?)?.toDate(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      stages: (json['stages'] as List<dynamic>?)
          ?.map((e) => TripStageModel.fromMap(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'billedTo': billedTo,
      'billedVehicle': billedVehicle,
      'driverName': driverName,
      'source': source,
      'destination': destination,
      'tripType': tripType,
      'status': status,
      'createdBy': createdBy,
      'tripDate': tripDate != null ? Timestamp.fromDate(tripDate!) : null,
      'createdAt': FieldValue.serverTimestamp(),
      'currentStage': currentStage ?? '',
      'stages': stages.map((s) => s.toMap()).toList(),
    };
  }
}
