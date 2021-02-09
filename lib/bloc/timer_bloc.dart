import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:timer/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
//depend on the ticker class we created to generate stream<int>
  final Ticker _ticker;
  static final int _duration = 60;

  StreamSubscription<int> _tickerSubscription;

  TimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker,
        super(TimerInitial(duration: _duration));

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is TimerStarted) {
      yield* _mapTimerStartedToState(event);
    }
    if (event is TimerTicked) {
      yield* _mapTimerTickedToState(event);
    }
    if (event is TimerPaused) {
      yield* _mapTimerPausedToState();
    }
    if (event is TimerResumed) {
      yield* _mapTimerResumedToState();
    }
    if (event is TimerReset) {
      yield* _mapTimerResetToState();
    }
  }

  Stream<TimerState> _mapTimerStartedToState(TimerStarted start) async* {
    yield TimerRunInProgress(duration: start.duration);

    //if there was an already opened _tickerSubscription ..we need to cancel it
    _tickerSubscription?.cancel(); //Cancel it to allocate memory
    _tickerSubscription = _ticker
        .tick(tick: start.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  Stream<TimerState> _mapTimerTickedToState(TimerTicked event) async* {
    yield event.duration > 0
        ? TimerRunInProgress(duration: event.duration)
        : TimerRunComplete();
  }

  Stream<TimerState> _mapTimerPausedToState() async* {
    if (state is TimerRunInProgress) {
      _tickerSubscription.pause();
      yield TimerRunPause(duration: state.duration);
    }
  }

  Stream<TimerState> _mapTimerResumedToState() async* {
    if (state is TimerRunInProgress) {
      _tickerSubscription.resume();

      yield TimerRunInProgress(duration: state.duration);
    }
  }

  Stream<TimerState> _mapTimerResetToState() async* {
    _tickerSubscription.cancel();
    yield TimerInitial(duration: _duration);
  }

//override the close method inorder to manually close the streamsubscription
  @override
  Future<void> close() {
    _tickerSubscription.cancel();
    return super.close();
  }
}
