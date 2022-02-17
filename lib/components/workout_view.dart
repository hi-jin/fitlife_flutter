import 'package:fitlife/classes/user.dart';
import 'package:fitlife/classes/workout.dart';
import 'package:fitlife/data/constatns.dart';
import 'package:flutter/material.dart';

class WorkoutListView extends StatelessWidget {
  final List<Workout> workoutList;
  bool isLive;
  bool reverse;

  WorkoutListView(
      {Key? key,
      required this.workoutList,
      this.isLive = false,
      this.reverse = true})
      : super(key: key);

  List<Widget> getListViewChildren(List<Workout> workoutList) {
    List<Widget> listViewChildren = [];
    for (Workout workout in workoutList) {
      listViewChildren.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
        child: Container(
          color: ThemeData.dark().cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  workout.toString(),
                  style: kDefaultTextStyle.copyWith(fontSize: 22.0),
                ),
                Text(
                  "${workout.reps}회",
                  style: kDefaultTextStyle.copyWith(fontSize: 22.0),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    if (isLive && User.currentUser.currentWorkout != null) {
      listViewChildren.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
        child: Container(
          color: ThemeData.dark().cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  User.currentUser.currentWorkout!.toString(),
                  style: kDefaultTextStyle.copyWith(fontSize: 22.0),
                ),
                Text(
                  User.currentUser.currentWorkout!.reps == null
                      ? ""
                      : "${User.currentUser.currentWorkout!.reps}회",
                  style: kDefaultTextStyle.copyWith(fontSize: 22.0),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return reverse
        ? List<Widget>.from(listViewChildren.reversed)
        : List<Widget>.from(listViewChildren);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: getListViewChildren(workoutList),
    );
  }
}
