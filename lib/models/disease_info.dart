import 'package:equatable/equatable.dart';

class DiseaseInfo extends Equatable {
  final String id;
  final String name;
  final String code;
  final String shortDescription;
  final String fullDescription;
  final String imageUrl;
  final List<String> symptoms;
  final List<String> causes;
  final List<String> riskFactors;
  final String severity;
  final DateTime lastUpdated;

  const DiseaseInfo({
    required this.id,
    required this.name,
    required this.code,
    required this.shortDescription,
    required this.fullDescription,
    required this.imageUrl,
    required this.symptoms,
    required this.causes,
    required this.riskFactors,
    required this.severity,
    required this.lastUpdated,
  });

  factory DiseaseInfo.fromJson(Map<String, dynamic> json) {
    return DiseaseInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      shortDescription: json['short_description'] as String,
      fullDescription: json['full_description'] as String,
      imageUrl: json['image_url'] as String,
      symptoms: List<String>.from(json['symptoms'] as List),
      causes: List<String>.from(json['causes'] as List),
      riskFactors: List<String>.from(json['risk_factors'] as List),
      severity: json['severity'] as String,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'short_description': shortDescription,
      'full_description': fullDescription,
      'image_url': imageUrl,
      'symptoms': symptoms,
      'causes': causes,
      'risk_factors': riskFactors,
      'severity': severity,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    shortDescription,
    fullDescription,
    imageUrl,
    symptoms,
    causes,
    riskFactors,
    severity,
    lastUpdated,
  ];
}
