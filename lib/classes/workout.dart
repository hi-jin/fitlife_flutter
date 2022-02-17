import 'dart:convert';

class Workout {
  final String name;
  int? reps;
  double weight;
  int? restTime; // rest time (sec) after doing this

  Workout({required this.name, this.weight = 0, this.reps, this.restTime});

  void setReps(int reps) {
    this.reps = reps;
  }

  void setRestTime(int sec) {
    restTime = sec;
  }

  static Workout fromJson(String jsonData) {
    Map data = jsonDecode(jsonData);
    return Workout(name: data['name'], weight: data['weight'], reps: data['reps'], restTime: data['restTime']);
  }

  String toJson() {
    return jsonEncode({
      'name': name,
      'weight': weight,
      'reps': reps,
      'restTime': restTime,
    });
  }

  @override
  String toString() {
    if (weight > 0) {
      if (weight % 1 == 0) {
        return "$name (${weight.toStringAsFixed(0)}kg)";
      } else {
        return "$name (${weight.toStringAsFixed(1)}kg)";
      }
    } else {
      return name;
    }
  }
}
