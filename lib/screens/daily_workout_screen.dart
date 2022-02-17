import 'package:fitlife/classes/daily_workout.dart';
import 'package:fitlife/classes/workout.dart';
import 'package:fitlife/data/constatns.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:word_break_text/word_break_text.dart';

class DailyWorkoutScreen extends StatefulWidget {
  static String id = 'dailyWorkoutScreen';
  DailyWorkout dailyWorkout;

  DailyWorkoutScreen({Key? key, required this.dailyWorkout}) : super(key: key);

  @override
  _DailyWorkoutScreenState createState() => _DailyWorkoutScreenState();
}

class _DailyWorkoutScreenState extends State<DailyWorkoutScreen> {
  bool simpleView = true;

  List<Widget> _getWorkoutCardList(List<Workout> workoutList, bool simpleView) {
    List<Widget> workoutCardList = <Widget>[];

    if (simpleView) {
      if (workoutList.isEmpty) return [];

      List<int> repsList = [workoutList.first.reps!];
      for (int i = 0; i < workoutList.length; i++) {
        if (i + 1 < workoutList.length) {
          if (workoutList[i].toString() == workoutList[i + 1].toString()) {
            repsList.add(workoutList[i + 1].reps!);
          } else {
            workoutCardList.add(Card(
              child: ListTile(
                title: Text(
                  workoutList[i].toString(),
                  style: kDefaultTextStyle.copyWith(fontSize: 25.0),
                ),
                subtitle: WordBreakText(
                  repsList.join("회, ") + "회",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                  wrapAlignment: WrapAlignment.start,
                ),
              ),
            ));
            repsList = [workoutList[i + 1].reps!];
          }
        } else {
          workoutCardList.add(Card(
            child: ListTile(
              title: Text(
                workoutList[i].toString(),
                style: kDefaultTextStyle.copyWith(fontSize: 25.0),
              ),
              subtitle: WordBreakText(
                repsList.join("회, ") + "회",
                style: TextStyle(
                  fontSize: 20.0,
                ),
                wrapAlignment: WrapAlignment.start,
              ),
            ),
          ));
        }
      }
    } else {
      for (Workout workout in widget.dailyWorkout.dailyWorkoutList) {
        workoutCardList.add(Card(
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: WordBreakText(
                    workout.toString(),
                    style: kDefaultTextStyle.copyWith(fontSize: 20.0),
                    wrapAlignment: WrapAlignment.start,
                  ),
                ),
                Text(
                  "${workout.reps}회",
                  style: kDefaultTextStyle.copyWith(fontSize: 20.0),
                ),
              ],
            ),
          ),
        ));
        if (workout.restTime == 0) {
          continue;
        }
        workoutCardList.add(ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '휴식 ',
                style: kDefaultTextStyle.copyWith(fontSize: 20.0),
              ),
              WordBreakText(
                "${workout.restTime}초",
                style: kDefaultTextStyle.copyWith(fontSize: 20.0),
                wrapAlignment: WrapAlignment.start,
              ),
            ],
          ),
        ));
      }
    }
    return workoutCardList;
  }

  String _getTimeDifference(DateTime now) {
    Duration diff = now.difference(widget.dailyWorkout.date);
    if (diff.inDays > 0) return "${diff.inDays.toString()}일 전";
    if (diff.inHours > 0) return "${diff.inHours.toString()}시간 전";
    return "${diff.inMinutes.toString()}분 전";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: const Hero(
            tag: 'title',
            child: Text(
              '헬생',
              style: kTitleTextStyle,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.dailyWorkout.title,
                  style: kTitleTextStyle,
                ),
                Text(
                  widget.dailyWorkout.title == "" ? "" : _getTimeDifference(DateTime.now()),
                  style: kDefaultTextStyle,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListView(
                children: _getWorkoutCardList(
                    widget.dailyWorkout.dailyWorkoutList, simpleView),
              ),
            ),
          ),
          SizedBox(
            height: 80.0,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          setState(() {
            simpleView = !simpleView;
          });
        },
        child: Icon(
          simpleView ? Icons.fullscreen : Icons.close_fullscreen,
          size: 35.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
