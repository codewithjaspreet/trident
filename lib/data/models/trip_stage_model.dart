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
      isCompleted: map['isCompleted'] ?? false,
      completedAt: map['completedAt'] != null
          ? (map['completedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isCompleted': isCompleted,
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }
}
