import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:timer/bloc/timer_bloc.dart';
import 'package:timer/ticker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: BlocProvider(
        create: (context) => TimerBloc(ticker: Ticker()),
        child: TimerUI(),
      ),
    );
  }
}

class TimerUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Timer'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: BlocBuilder<TimerBloc, TimerState>(
              builder: (context, state) {
                final String minutesStr =
                    ((state.duration)).floor().toString().padLeft(2, '0');

                final String secondsStr = (state.duration / 60 % 60)
                    .floor()
                    .toString()
                    .padLeft(2, '0');

                return Text(
                  '$minutesStr:$secondsStr',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                );
              },
            ),
          ),
          BlocBuilder<TimerBloc, TimerState>(
            // buildWhen: (previousState, state) =>
            //     state.runtimeType != previousState.runtimeType,
            builder: (context, state) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Actions(),
            ),
          )
        ],
      ),
    );
  }
}

class Actions extends StatefulWidget {
  @override
  _ActionsState createState() => _ActionsState();
}

class _ActionsState extends State<Actions> {
  TextEditingController _hourController = TextEditingController();
  TextEditingController _minuteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTimeEnter(label: 'Hours', controller: _hourController),
            _buildTimeEnter(label: 'Minute', controller: _minuteController),
          ],
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _mapStateToActionButton(
                timerBloc: BlocProvider.of<TimerBloc>(context),
                context: context)),
      ],
    );
  }

  Container _buildTimeEnter({String label, TextEditingController controller}) {
    return Container(
      alignment: Alignment.center,
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black12)],
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          maxLength: 2,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              counterText: '',
              hintText: label,
              hintStyle: TextStyle(fontSize: 20, color: Colors.grey.shade500)),
        ),
      ),
    );
  }

  List<Widget> _mapStateToActionButton(
      {TimerBloc timerBloc,
      BuildContext context,
      TextEditingController hourController,
      TextEditingController minuteController}) {
    final TimerState currentState = timerBloc.state;

    if (currentState is TimerInitial) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow_sharp),
          onPressed: () => timerBloc.add(TimerStarted(duration: 60)),
        ) //add the timerstarted Event,
      ];
    }

    if (currentState is TimerRunInProgress) {
      return [
        FloatingActionButton(
            child: Icon(Icons.pause),
            onPressed: () => timerBloc.add(TimerPaused())),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.add(TimerReset()),
        )
      ];
    }
    if (currentState is TimerRunPause) {
      return [
        FloatingActionButton(
          child: Icon(
            Icons.play_arrow,
          ),
          onPressed: () => BlocProvider.of<TimerBloc>(context)
              .add(TimerStarted(duration: currentState.duration)),
        ),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () =>
              BlocProvider.of<TimerBloc>(context).add(TimerReset()),
        )
      ];
    }

    if (currentState is TimerRunComplete) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () {},
        )
      ];
    }

    return [];
  }
}
