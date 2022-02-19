import 'dart:convert';

import 'package:fitlife/classes/daily_workout.dart';
import 'package:fitlife/classes/workout.dart';

class User {
  static User currentUser = User();
  static bool isChanged = false;

  bool isStarted = false;
  bool isSetStarted = false;

  Set<String> kindsOfWorkout = {};
  List<DailyWorkout> myWorkoutRecord = <DailyWorkout>[];
  DailyWorkout dailyWorkout = DailyWorkout();
  Workout? currentWorkout; // 현재 진행중인 workout. nullable.

  User();

  static void init() {
    User.currentUser = User();
    User.isChanged = true;
  }

  Set<String> getKindsOfWorkoutList() {
    for (DailyWorkout dailyWorkout in myWorkoutRecord) {
      for (Workout workout in dailyWorkout.dailyWorkoutList) {
        kindsOfWorkout.add(workout.name);
      }
    }
    return kindsOfWorkout;
  }

  void stopWorkout(String title) {
    if (dailyWorkout.dailyWorkoutList.isNotEmpty) {
      dailyWorkout.title = title;
      myWorkoutRecord.add(dailyWorkout);
    }
    dailyWorkout = DailyWorkout();
    currentWorkout = null;
    isStarted = false;
    isSetStarted = false;
    isChanged = true;
  }

  void startWorkout() {
    dailyWorkout = DailyWorkout();
    currentWorkout = null;
    isStarted = true;
    isChanged = true;
  }

  void addWorkout(Workout workout) {
    dailyWorkout.addWorkout(workout);
    isChanged = true;
  }

  static void fromJson(String jsonData) {
    Map data = jsonDecode(jsonData);

    User user = User();
    DailyWorkout dailyWorkout = DailyWorkout.fromJson(data['dailyWorkout']);
    List<String> myWorkoutRecordList = List<String>.from(data['myWorkoutRecord']);

    for (String strDailyWorkout in myWorkoutRecordList) {
      user.myWorkoutRecord.add(DailyWorkout.fromJson(strDailyWorkout));
    }
    user.dailyWorkout = dailyWorkout;
    user.currentWorkout = data['currentWorkout'] == "" ? null : Workout.fromJson(data['currentWorkout']);
    user.isStarted = data['isStarted'] == "true";
    user.isSetStarted = data['isSetStarted'] == "true";

    currentUser = user;
    isChanged = true;
  }

  String toJson() {
    List<String> jsonMyWorkoutRecord = [];
    for (DailyWorkout dailyWorkout in myWorkoutRecord) {
      jsonMyWorkoutRecord.add(dailyWorkout.toJson());
    }
    return jsonEncode({
      'isStarted': isStarted.toString(),
      'isSetStarted': isSetStarted.toString(),
      'currentWorkout': currentWorkout == null ? "": currentWorkout!.toJson(),
      'dailyWorkout': dailyWorkout.toJson(),
      'myWorkoutRecord': jsonMyWorkoutRecord,
    });
  }
}
