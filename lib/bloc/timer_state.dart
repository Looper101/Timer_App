part of 'timer_bloc.dart';

@immutable
abstract class TimerState extends Equatable {
  final int duration;
  const TimerState({
    this.duration,
  });

  @override
  List<Object> get props => [duration];
}

class TimerInitial extends TimerState {
  final int duration;
  TimerInitial({
    this.duration,
  });
  @override
  List<Object> get props => [duration];

  @override
  String toString() => 'TimerInitial(duration: $duration)';
}

class TimerRunInProgress extends TimerState {
  final int duration;
  TimerRunInProgress({
    this.duration,
  });
  @override
  List<Object> get props => [duration];

  @override
  String toString() => 'TimerRunInProgress(duration: $duration)';
}

class TimerRunPause extends TimerState {
  final int duration;
  TimerRunPause({
    this.duration,
  });
  @override
  List<Object> get props => [duration];

  @override
  String toString() => 'TimerRunPause(duration: $duration)';
}

class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(duration: 0);

  @override
  List<Object> get props => [duration];

  @override
  String toString() => 'TimerRunComplete(duration: $duration)';
}
