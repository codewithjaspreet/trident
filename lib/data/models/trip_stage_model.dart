import 'package:cloud_firestore/cloud_firestore.dart';

class TripStageModel {
  final String name;
  final bool isCompleted;
  final DateTime? completedAt;

  TripStageModel({
    required this.name,
    this.isCompleted = false,
    this.completedAt,
  });

  factory TripStageModel.fromMap(Map<String, dynamic> map) {
    return TripStageModel(
      name: map['name'] ?? '',
      isCompleted: map['is_completed'] ?? false,
      completedAt: map['completed_at'] != null
          ? (map['completed_at'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'is_completed': isCompleted,
      'completed_at':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }
}
