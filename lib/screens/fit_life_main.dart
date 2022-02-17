import 'dart:math';

import 'package:fitlife/classes/user.dart';
import 'package:fitlife/classes/wise_saying.dart';
import 'package:fitlife/components/icon_text_button.dart';
import 'package:fitlife/components/info_card.dart';
import 'package:fitlife/data/constatns.dart';
import 'package:fitlife/screens/statistics_screen.dart';
import 'package:fitlife/screens/workout_ready_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FitLifeMain extends StatefulWidget {
  static String id = 'fitLifeMain';

  const FitLifeMain({Key? key}) : super(key: key);

  @override
  _FitLifeMainState createState() => _FitLifeMainState();
}

class _FitLifeMainState extends State<FitLifeMain> {
  int _wiseSayingIndex = 0; // 명언 리스트의 index

  @override
  void initState() {
    super.initState();
    // 화면 생성시 명언 인덱스를 랜덤으로 설정하여, 다른 명언이 보이도록 함
    _wiseSayingIndex = Random().nextInt(WiseSaying.getList().length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            // 좌측 상단 홈 버튼 (헬생) 클릭시 가장 첫 화면 (fit_life_main.dart)이 보여지도록 함
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
      body: SafeArea(
        child: Column(
          children: [
            // 명언 탭. 클릭 시 새로운 명언 출력
            GestureDetector(
              onTap: () {
                setState(() {
                  int newIndex;
                  do {
                    newIndex = Random().nextInt(WiseSaying.getList().length);
                  } while (_wiseSayingIndex == newIndex);
                  // 기존 명언과 겹치지 않을 때까지 반복
                  _wiseSayingIndex = newIndex;
                });
              },
              child: Hero(
                tag: 'quote',
                child: InfoCard(
                  iconData: FontAwesomeIcons.quoteLeft,
                  title: WiseSaying.getList()[_wiseSayingIndex].saying,
                  subTitle: WiseSaying.getList()[_wiseSayingIndex].name,
                ),
              ),
            ),
            const Hero(
              tag: 'divider',
              child: Divider(
                color: Colors.white,
                thickness: 1.0,
                indent: 10.0,
                endIndent: 10.0,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: IconTextButton(
                    iconData: FontAwesomeIcons.dumbbell,
                    title: '운동하기',
                    onTap: () {
                      Navigator.pushNamed(context, WorkoutReadyScreen.id);
                    },
                  ),
                ),
                Expanded(
                  child: IconTextButton(
                    iconData: FontAwesomeIcons.fileAlt,
                    title: '통계보기',
                    onTap: () {
                      Navigator.pushNamed(context, StatisticsScreen.id);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: IconTextButton(
                    iconData: FontAwesomeIcons.question,
                    title: '도움말',
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: IconTextButton(
                    iconData: Icons.settings,
                    title: '설정',
                    onTap: () {
                      User.init();
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
