import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/detection_result.dart';

// Events
abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistoryEvent extends HistoryEvent {}

class AddToHistoryEvent extends HistoryEvent {
  final DetectionResult result;

  const AddToHistoryEvent(this.result);

  @override
  List<Object?> get props => [result];
}

class DeleteFromHistoryEvent extends HistoryEvent {
  final String id;

  const DeleteFromHistoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ClearHistoryEvent extends HistoryEvent {}

// States
abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<DetectionResult> history;

  const HistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class HistoryEmpty extends HistoryState {}

class HistoryError extends HistoryState {
  final String error;

  const HistoryError(this.error);

  @override
  List<Object?> get props => [error];
}

// BLoC
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  Database? _database;

  HistoryBloc() : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<AddToHistoryEvent>(_onAddToHistory);
    on<DeleteFromHistoryEvent>(_onDeleteFromHistory);
    on<ClearHistoryEvent>(_onClearHistory);
    
    // Initialize database
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'dermatolab.db');

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          return db.execute(
            '''
            CREATE TABLE history(
              id TEXT PRIMARY KEY,
              image_path TEXT,
              disease_name TEXT,
              disease_code TEXT,
              confidence REAL,
              timestamp INTEGER,
              ai_recommendations TEXT
            )
            ''',
          );
        },
      );
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<void> _onLoadHistory(
    LoadHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());

    try {
      if (_database == null) {
        await _initDatabase();
      }

      final List<Map<String, dynamic>> maps = await _database!.query(
        'history',
        orderBy: 'timestamp DESC',
      );

      if (maps.isEmpty) {
        emit(HistoryEmpty());
      } else {
        final history = maps.map((map) => DetectionResult.fromMap(map)).toList();
        emit(HistoryLoaded(history));
      }
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> _onAddToHistory(
    AddToHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      if (_database == null) {
        await _initDatabase();
      }

      await _database!.insert(
        'history',
        event.result.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      add(LoadHistoryEvent());
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> _onDeleteFromHistory(
    DeleteFromHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      if (_database == null) {
        await _initDatabase();
      }

      await _database!.delete(
        'history',
        where: 'id = ?',
        whereArgs: [event.id],
      );

      add(LoadHistoryEvent());
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> _onClearHistory(
    ClearHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      if (_database == null) {
        await _initDatabase();
      }

      await _database!.delete('history');
      emit(HistoryEmpty());
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _database?.close();
    return super.close();
  }
}
