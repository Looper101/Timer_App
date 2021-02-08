part of 'timer_bloc.dart';

@immutable
abstract class TimerState extends Equatable {
  final int duration;
  const TimerState({
    this.duration,
  });
}

class TimerInitial extends TimerState {
  final int duration;
  TimerInitial({
    this.duration,
  });
  @override
  List<Object> get props => [];
}

class TimerRunInProgress extends TimerState {
  final int duration;
  TimerRunInProgress({
    this.duration,
  });
  @override
  List<Object> get props => [];
}

class TimerRunPause extends TimerState {
  final int duration;
  TimerRunPause({
    this.duration,
  });
  @override
  List<Object> get props => [];
}

class TimerRunComplete extends TimerState {
  final int duration;
  TimerRunComplete({
    this.duration,
  });
  @override
  List<Object> get props => [];
}
