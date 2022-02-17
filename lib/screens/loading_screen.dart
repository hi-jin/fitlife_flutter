import 'dart:async';

import 'package:fitlife/classes/user.dart';
import 'package:fitlife/data/constatns.dart';
import 'package:fitlife/data/storage_io.dart';
import 'package:fitlife/screens/fit_life_main.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> init() async {
    String data = await Storage(fileName: 'user.txt').readFile();
    if (data != "") {
      // user.txt에 저장된 data가 있을 경우, User.currentUser를 data의 user로 변경
      User.fromJson(data);
    }

    Timer.periodic(const Duration(seconds: 1), (timer) {
      // 1초마다 User.currentUser의 변경여부(User.isChanged)를 확인하고, 변경시 저장
      if (User.isChanged) {
        String jsonData = User.currentUser.toJson();
        Storage(fileName: 'user.txt').writeFile(jsonData);
        User.isChanged = false; // 저장 후, 변경여부 변경
      }
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    init().then((val) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.popAndPushNamed(context, FitLifeMain.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: ThemeData.dark().cardColor,
        child: const Center(child: Text("로딩중입니다...", style: kDefaultTextStyle,)),
      ),
    );
  }
}
