import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/disease_info.dart';
import '../../repositories/disease_info_repository.dart';

// Events
abstract class InfoEvent extends Equatable {
  const InfoEvent();

  @override
  List<Object?> get props => [];
}

class LoadDiseaseInfo extends InfoEvent {}

class RefreshDiseaseInfo extends InfoEvent {}

class LoadDiseaseDetails extends InfoEvent {
  final String diseaseCode;

  const LoadDiseaseDetails(this.diseaseCode);

  @override
  List<Object?> get props => [diseaseCode];
}

// States
abstract class InfoState extends Equatable {
  const InfoState();

  @override
  List<Object?> get props => [];
}

class InfoInitial extends InfoState {}

class InfoLoading extends InfoState {}

class InfoLoaded extends InfoState {
  final List<DiseaseInfo> diseases;

  const InfoLoaded(this.diseases);

  @override
  List<Object?> get props => [diseases];
}

class InfoDetailsLoaded extends InfoState {
  final DiseaseInfo diseaseInfo;

  const InfoDetailsLoaded(this.diseaseInfo);

  @override
  List<Object?> get props => [diseaseInfo];
}

class InfoError extends InfoState {
  final String error;

  const InfoError(this.error);

  @override
  List<Object?> get props => [error];
}

// BLoC
class InfoBloc extends Bloc<InfoEvent, InfoState> {
  final DiseaseInfoRepository diseaseInfoRepository;

  InfoBloc({required this.diseaseInfoRepository}) : super(InfoInitial()) {
    on<LoadDiseaseInfo>(_onLoadDiseaseInfo);
    on<RefreshDiseaseInfo>(_onRefreshDiseaseInfo);
    on<LoadDiseaseDetails>(_onLoadDiseaseDetails);
  }

  Future<void> _onLoadDiseaseInfo(
    LoadDiseaseInfo event,
    Emitter<InfoState> emit,
  ) async {
    emit(InfoLoading());

    try {
      final diseases = await diseaseInfoRepository.getRecentDiseaseInfo();
      emit(InfoLoaded(diseases));
    } catch (e) {
      emit(InfoError(e.toString()));
    }
  }

  Future<void> _onRefreshDiseaseInfo(
    RefreshDiseaseInfo event,
    Emitter<InfoState> emit,
  ) async {
    try {
      final diseases = await diseaseInfoRepository.getRecentDiseaseInfo();
      emit(InfoLoaded(diseases));
    } catch (e) {
      emit(InfoError(e.toString()));
    }
  }

  Future<void> _onLoadDiseaseDetails(
    LoadDiseaseDetails event,
    Emitter<InfoState> emit,
  ) async {
    emit(InfoLoading());

    try {
      final diseaseInfo = await diseaseInfoRepository.getDiseaseInfoByCode(
        event.diseaseCode,
      );
      emit(InfoDetailsLoaded(diseaseInfo));
    } catch (e) {
      emit(InfoError(e.toString()));
    }
  }
}
