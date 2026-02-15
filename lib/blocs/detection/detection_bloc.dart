import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/detection_result.dart';
import '../../repositories/ml_repository.dart';
import '../../utils/ai_helper.dart';

// Events
abstract class DetectionEvent extends Equatable {
  const DetectionEvent();

  @override
  List<Object?> get props => [];
}

class DetectDiseaseEvent extends DetectionEvent {
  final File imageFile;

  const DetectDiseaseEvent(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

class GetAIRecommendationsEvent extends DetectionEvent {
  final DetectionResult result;

  const GetAIRecommendationsEvent(this.result);

  @override
  List<Object?> get props => [result];
}

class ResetDetectionEvent extends DetectionEvent {}

// States
abstract class DetectionState extends Equatable {
  const DetectionState();

  @override
  List<Object?> get props => [];
}

class DetectionInitial extends DetectionState {}

class DetectionLoading extends DetectionState {}

class DetectionSuccess extends DetectionState {
  final DetectionResult result;

  const DetectionSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class DetectionWithAIRecommendations extends DetectionState {
  final DetectionResult result;

  const DetectionWithAIRecommendations(this.result);

  @override
  List<Object?> get props => [result];
}

class DetectionFailure extends DetectionState {
  final String error;

  const DetectionFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class AIRecommendationsLoading extends DetectionState {
  final DetectionResult result;

  const AIRecommendationsLoading(this.result);

  @override
  List<Object?> get props => [result];
}

// BLoC
class DetectionBloc extends Bloc<DetectionEvent, DetectionState> {
  final MLRepository mlRepository;

  DetectionBloc({required this.mlRepository}) : super(DetectionInitial()) {
    on<DetectDiseaseEvent>(_onDetectDisease);
    on<GetAIRecommendationsEvent>(_onGetAIRecommendations);
    on<ResetDetectionEvent>(_onResetDetection);
  }

  Future<void> _onDetectDisease(
    DetectDiseaseEvent event,
    Emitter<DetectionState> emit,
  ) async {
    emit(DetectionLoading());

    try {
      final result = await mlRepository.detectDisease(event.imageFile);
      emit(DetectionSuccess(result));
    } catch (e) {
      emit(DetectionFailure(e.toString()));
    }
  }

  Future<void> _onGetAIRecommendations(
    GetAIRecommendationsEvent event,
    Emitter<DetectionState> emit,
  ) async {
    emit(AIRecommendationsLoading(event.result));

    try {
      final recommendations = await AIHelper.getTreatmentRecommendations(
        diseaseName: event.result.diseaseName,
        diseaseDescription: event.result.diseaseCode,
        confidence: event.result.confidence,
      );

      final updatedResult = event.result.copyWith(
        aiRecommendations: recommendations,
      );

      emit(DetectionWithAIRecommendations(updatedResult));
    } catch (e) {
      // Even if AI recommendations fail, we still have the detection result
      emit(DetectionSuccess(event.result));
    }
  }

  void _onResetDetection(
    ResetDetectionEvent event,
    Emitter<DetectionState> emit,
  ) {
    emit(DetectionInitial());
  }
}
