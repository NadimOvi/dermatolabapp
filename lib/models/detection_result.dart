import 'package:equatable/equatable.dart';

class DetectionResult extends Equatable {
  final String id;
  final String imagePath;
  final String diseaseName;
  final String diseaseCode;
  final double confidence;
  final DateTime timestamp;
  final String? aiRecommendations;
  final Map<String, double>? allPredictions;

  const DetectionResult({
    required this.id,
    required this.imagePath,
    required this.diseaseName,
    required this.diseaseCode,
    required this.confidence,
    required this.timestamp,
    this.aiRecommendations,
    this.allPredictions,
  });

  DetectionResult copyWith({
    String? id,
    String? imagePath,
    String? diseaseName,
    String? diseaseCode,
    double? confidence,
    DateTime? timestamp,
    String? aiRecommendations,
    Map<String, double>? allPredictions,
  }) {
    return DetectionResult(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      diseaseName: diseaseName ?? this.diseaseName,
      diseaseCode: diseaseCode ?? this.diseaseCode,
      confidence: confidence ?? this.confidence,
      timestamp: timestamp ?? this.timestamp,
      aiRecommendations: aiRecommendations ?? this.aiRecommendations,
      allPredictions: allPredictions ?? this.allPredictions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_path': imagePath,
      'disease_name': diseaseName,
      'disease_code': diseaseCode,
      'confidence': confidence,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'ai_recommendations': aiRecommendations,
    };
  }

  factory DetectionResult.fromMap(Map<String, dynamic> map) {
    return DetectionResult(
      id: map['id'] as String,
      imagePath: map['image_path'] as String,
      diseaseName: map['disease_name'] as String,
      diseaseCode: map['disease_code'] as String,
      confidence: map['confidence'] as double,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      aiRecommendations: map['ai_recommendations'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        imagePath,
        diseaseName,
        diseaseCode,
        confidence,
        timestamp,
        aiRecommendations,
        allPredictions,
      ];
}
