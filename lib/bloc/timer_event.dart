part of 'timer_bloc.dart';

@immutable
abstract class TimerEvent extends Equatable {}

//tell the bloc start counting
class TimerStarted extends TimerEvent {
  final int duration;
  TimerStarted({this.duration});
  @override
  List<Object> get props => [];
}

//informs the TimerBloc that the timer should be paused
class TimerPaused extends TimerEvent {
  @override
  List<Object> get props => [];
}

//informs the  TimerBloc that the timer should resume
class TimerResumed extends TimerEvent {
  @override
  List<Object> get props => [];
}

//informs the timer to reset the timer to original state
class TimerReset extends TimerEvent {
  @override
  List<Object> get props => [];
}

class TimerTicked extends TimerEvent {
  final int duration;
  TimerTicked({
    @required this.duration,
  });
  @override
  List<Object> get props => [];
}
