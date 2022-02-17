import 'dart:async';
import 'package:fitlife/classes/user.dart';
import 'package:fitlife/data/constatns.dart';
import 'package:fitlife/data/storage_io.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final String title;
  final int id;
  int currentTime = 0;
  late Function start;
  late Function stop;
  late Function initTimer;
  late bool isStarted = false;

  TimerWidget({Key? key, required this.title, required this.id}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  DateTime? _startTime;
  Timer? _timer;
  late Storage _storage;

  void start() async {
    _startTime ??= DateTime.now();
    widget.isStarted = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        widget.currentTime += 1;
      });
    });
    _storage.writeFile(_startTime.toString());
  }

  void initTimer() {
    setState(() {
      _startTime = DateTime.now();
      widget.currentTime = 0;
    });
  }

  void stop() {
    widget.isStarted = false;
    _storage.writeFile("");
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _storage = Storage(fileName: 'timer${widget.id}.txt');
    _storage.readFile().then((value) {
      if (value != "") {
        if (User.currentUser.isStarted) {
          _startTime = DateTime.parse(value);
          setState(() {
            widget.currentTime = DateTime.now().difference(_startTime!).inSeconds;
          });
          start();
        }
      }
    });
    widget.start = start;
    widget.stop = stop;
    widget.initTimer = initTimer;
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(
            widget.title,
            style: kDefaultTextStyle,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text((widget.currentTime/60).toInt().toString().padLeft(2, '0'), style: kDefaultTextStyle.copyWith(fontSize: 40.0)),
              Text(':', style: kDefaultTextStyle.copyWith(fontSize: 40.0)),
              Text((widget.currentTime%60).toInt().toString().padLeft(2, '0'), style: kDefaultTextStyle.copyWith(fontSize: 40.0)),
            ],
          ),
        ],
      ),
    );
  }
}
