import 'dart:convert';

import 'package:fitlife/classes/workout.dart';

/// class DailyWorkout
/// 하루(한 회차)의 운동을 의미하는 클래스입니다.
/// 세트종료/운동종료시 각 Workout들을 저장합니다.
/// 통계보기 탭에서 단계별로 클릭할 수 있습니다.
/// 직렬화 메소드도 제공합니다.
/// User.currentUser 객체에도 저장됩니다.
class DailyWorkout {
  late String title;
  late DateTime date;
  late List<Workout> dailyWorkoutList; // 생성자 실행 시 non-null이 되므로, late 키워드 사용함

  // User.currentUsers에 기존 저장된 dailyworkout이 없는 경우, 새로운 List 생성
  DailyWorkout({List<Workout>? dailyWorkoutList, String? title, DateTime? date}) {
    if (dailyWorkoutList == null) {
      this.dailyWorkoutList = <Workout>[];
      this.title = "";
      this.date = DateTime.now();
    } else {
      this.dailyWorkoutList = dailyWorkoutList;
      this.title = title!;
      this.date = date!;
    }
  }

  // getter
  List<Workout> getDailyWorkoutList() {
    return dailyWorkoutList;
  }

  void addWorkout(Workout workout) {
    dailyWorkoutList.add(workout);
    date = DateTime.now();
  }

  static DailyWorkout fromJson(String jsonData) {
    Map data = jsonDecode(jsonData);
    List<Workout> workoutList = [];
    for (var jsonWorkout in data['dailyWorkoutList']) {
      workoutList.add(Workout.fromJson(jsonWorkout));
    }
    return DailyWorkout(dailyWorkoutList: workoutList, title: data['title'], date: DateTime.parse(data['date']));
  }

  String toJson() {
    List<String> jsonList = [];
    for (Workout workout in dailyWorkoutList) {
      jsonList.add(workout.toJson());
    }
    return jsonEncode({
      'title': title,
      'dailyWorkoutList': jsonList,
      'date': date.toString(),
    });
  }
}
