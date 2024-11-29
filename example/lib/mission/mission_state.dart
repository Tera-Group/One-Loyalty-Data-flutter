part of 'mission_cubit.dart';

@immutable
abstract class MissionState {}

class MissionInitial extends MissionState {}
class MissionLoading extends MissionState {}
class MissionLoaded extends MissionState {
  final dynamic missions;

  MissionLoaded(this.missions);
}

class MissionError extends MissionState {
  final String message;

  MissionError(this.message);
}

