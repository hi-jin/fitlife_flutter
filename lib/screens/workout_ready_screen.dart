import 'package:fitlife/components/info_card.dart';
import 'package:fitlife/data/constatns.dart';
import 'package:fitlife/data/alarm_type.dart';
import 'package:fitlife/screens/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:word_break_text/word_break_text.dart';

class WorkoutReadyScreen extends StatefulWidget {
  static String id = 'workoutReadyScreen';

  const WorkoutReadyScreen({Key? key}) : super(key: key);

  @override
  _WorkoutReadyScreenState createState() => _WorkoutReadyScreenState();
}

class _WorkoutReadyScreenState extends State<WorkoutReadyScreen> {
  int currentTimerIndex =
      0; // 알람기능 사용 여부를 담은 변수. 추후에 타이머 종류가 추가될 것을 대비하여 bool 말고 int로 종류를 표기

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
                '헬생 - [모드 선택]',
                style: kTitleTextStyle,
              )),
        ),
      ),
      body: Column(
        children: [
          Hero(
            tag: 'quote',
            child: InfoCard(
              iconData: FontAwesomeIcons.lightbulb,
              title: "가장 어려운 건 시작하는 것입니다. 당신은 방금 그걸 해냈습니다.",
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1.0,
            indent: 10.0,
            endIndent: 10.0,
          ),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // 알람 종류 변경
                        setState(() {
                          if (currentTimerIndex == 0) {
                            currentTimerIndex = alarmType.length - 1;
                          } else {
                            currentTimerIndex -= 1;
                          }
                        });
                      },
                      child: const Icon(FontAwesomeIcons.arrowLeft),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            alarmType[currentTimerIndex]["title"],
                            style: kDefaultTextStyle,
                          ),
                          const SizedBox(height: 10.0),
                          Icon(
                            alarmType[currentTimerIndex]["iconData"],
                            size: MediaQuery.of(context).size.width * 0.3,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // 알람 종류 변경
                        setState(() {
                          if (currentTimerIndex >= alarmType.length - 1) {
                            currentTimerIndex = 0;
                          } else {
                            currentTimerIndex += 1;
                          }
                        });
                      },
                      child: const Icon(FontAwesomeIcons.arrowRight),
                    ),
                  ],
                ),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                alarmType[currentTimerIndex]["desc"], // 선택한 알람에 대한 설명
                style: kDefaultTextStyle,
              ),
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1.0,
            indent: 10.0,
            endIndent: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 5.0),
                child: TextButton(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          FontAwesomeIcons.running,
                          color: Colors.white,
                        ),
                        Text(
                          " 운동시작",
                          style: kDefaultTextStyle,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    if (alarmType[currentTimerIndex]["name"] == "default") {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("잠시만요!"),
                              content: Text(
                                "아직 개발중인 기능입니다 ㅠㅠ\n빠른 시일 내에 추가 예정입니다.",
                              ),
                            );
                          });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutScreen(
                            alarmType: alarmType[currentTimerIndex]
                                ["name"], // 선택한 알람의 종류를 인자로 넘기며 다음 페이지 호출
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
