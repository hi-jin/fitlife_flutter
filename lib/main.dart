import 'dart:async';
import 'package:fitlife/classes/user.dart';
import 'package:fitlife/data/storage_io.dart';
import 'package:fitlife/screens/daily_workout_screen.dart';
import 'package:fitlife/screens/loading_screen.dart';
import 'package:fitlife/screens/statistics_screen.dart';
import 'package:fitlife/screens/workout_ready_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitlife/screens/fit_life_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: LoadingScreen(),
      routes: {
        FitLifeMain.id: (context) => FitLifeMain(),
        WorkoutReadyScreen.id: (context) => WorkoutReadyScreen(),
        StatisticsScreen.id: (context) => StatisticsScreen(),
      },
    );
  }
}
