import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:fitlife/classes/daily_workout.dart';
import 'package:fitlife/classes/user.dart';
import 'package:fitlife/classes/workout.dart';
import 'package:fitlife/components/timer_widget.dart';
import 'package:fitlife/components/workout_view.dart';
import 'package:fitlife/data/constatns.dart';
import 'package:fitlife/screens/daily_workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkoutScreen extends StatefulWidget {
  static String id = 'workoutScreen';

  final String alarmType;

  const WorkoutScreen({Key? key, required this.alarmType}) : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final Set<String> _strWorkoutList =
      User.currentUser.getKindsOfWorkoutList(); // User에 저장된 정보, 지금까지 추가한 운동종목들을 불러온다.
  TextEditingController? _textController; // 운동종목 입력 TextField에 연결된 controller
  TextEditingController? _weightController;
  bool _isTextFieldClicked = false;

  late TimerWidget timer0; // 총 운동시간이 기록된 timer widget
  late TimerWidget timer1; // 휴식시간이 기록된 timer widget

  /*
  운동 시작 함수
    1. Timer0 초기화 및 시작
    2. User isStarted 변경 및 적용
   */
  void _start() {
    setState(() {
      timer0.initTimer();
      timer1.initTimer();
      timer0.start();
      User.currentUser.startWorkout();
    });
  }

  /*
  운동 종료 함수
    1. Timer0 종료
    2. Timer1 종료
    3. User isStarted 변경 및 적용
    4. User isSetStarted 변경 및 적용
   */
  void _stop() async {
    String title = "";
    setState(() {
      timer0.stop();
      timer1.stop();
    });
    if (User.currentUser.isSetStarted) {
      int reps = await _callRepsTextField();
      User.currentUser.currentWorkout!.reps = reps;
    }
    if (User.currentUser.currentWorkout != null) {
      User.currentUser.currentWorkout!.restTime = 0;

      title = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('오늘 운동의 주제를 입력해주세요!'),
            content: TextField(
              onSubmitted: (value) {
                if (value == "") {
                  value = "제목없음";
                }
                Navigator.pop(context, value);
              },
              decoration: InputDecoration(
                hintText: "하체 Day, 가슴 Day, ..."
              ),
            ),
          );
        },
      );

      User.currentUser.addWorkout(User.currentUser.currentWorkout!);
    }
    setState(() {
      User.currentUser.stopWorkout(title);
    });
  }

  /*
  세트 시작 함수
    아무것도 입력 안했거나, 새로운 종목 입력을 대비한 Dialog 출력
    1. 운동을 시작하지 않은 상태
      세트 시작과 운동 시작 이벤트를 함께 실행한다.
    2. 공통
      휴식시간을 의미하는 timer1을 정지시킴
      setStarted 변수 변경 및 저장
   */
  void _startSet() {
    // 아무것도 입력하지 않은 경우
    if (_textController!.text == "") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                '잠시만요!',
              ),
              content: Text('운동 종목을 먼저 입력해주세요!'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "네!",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            );
          });
    } else {
      // 입력한 경우
      // User가 기존에 운동을 시작하지 않았다면 새로운 운동 시작 + 세트 시작
      if (!User.currentUser.isStarted) {
        _start();
      }
      setState(() {
        // 이 전에 진행하던 운동이 있는 경우
        if (User.currentUser.currentWorkout != null) {
          User.currentUser.currentWorkout!.restTime =
              timer1.currentTime; // 휴식시간 타이머의 currentTime (휴식시간) 저장
          User.currentUser
              .addWorkout(User.currentUser.currentWorkout!); // 기록된 정보 저장
        }
        User.currentUser.currentWorkout = Workout(
            name: _textController!.text,
            weight: (double.tryParse(_weightController!.text) == null
                ? 0
                : double.parse(
                    _weightController!.text))); // User의 현재 진행중 workout에 반영
        timer1.stop(); // 세트를 시작했으므로, 세트 휴식시간을 표시하는 timer1는 멈춘다. (세트를 시작했다는 의미)
        User.currentUser.kindsOfWorkout.add(_textController!.text);
        User.currentUser.isSetStarted = true;
        User.isChanged = true;
      });
    }
  }

  /*
  세트 종료 함수
    세트 후 휴식시간 기록을 위해 timer1 시작 (이 전의 휴식 시간은 지워야 하므로 clear : true)
    setStarted 여부 반영
   */
  void _stopSet() async {
    setState(() {
      timer1.initTimer();
      timer1.start();
      User.currentUser.isSetStarted = false;
    });
    int reps = await _callRepsTextField();
    setState(() {
      User.currentUser.currentWorkout!.reps = reps;
      User.isChanged = true;
    });
  }

  Future<int> _callRepsTextField() async {
    int reps = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          TextEditingController _numController = TextEditingController();
          return AlertDialog(
            title: Text(
              '${User.currentUser.currentWorkout!.name} 몇 회 하셨나요?',
            ),
            content: TextField(
              controller: _numController,
              autofocus: true,
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                if (value == "") {
                  value = "0";
                  _numController.text = "0";
                }
                int? reps = int.tryParse(value);
                if (reps == null) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('잠시만요!'),
                          content: Text('숫자만 입력해주세요!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _numController.text = "";
                                });
                                Navigator.pop(context);
                              },
                              child: Text('네!'),
                            ),
                          ],
                        );
                      });
                } else {
                  Navigator.pop(context, reps);
                }
              },
            ),
          );
        });
    return reps;
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _weightController = TextEditingController();
    if (User.currentUser.isSetStarted) {
      _textController!.text = User.currentUser.currentWorkout!.name;
      _weightController!.text =
          User.currentUser.currentWorkout!.weight.toStringAsFixed(1);
    }
    timer0 = TimerWidget(title: "총 운동 시간", id: 0); // timer 위젯 생성
    timer1 = TimerWidget(title: "휴식 시간", id: 1); // timer 위젯 생성
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(15.0),
                      width: double.infinity,
                      color: ThemeData.dark().cardColor,
                      child: Column(
                        children: [
                          timer0,
                          timer1,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: Focus(
                          onFocusChange: (focus) => _isTextFieldClicked = focus,
                          child: EasyAutocomplete(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: "벤치프레스, ...",
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelText: '운동 종목 입력',
                              labelStyle:
                                  kDefaultTextStyle.copyWith(fontSize: 20.0),
                            ),
                            suggestions: _strWorkoutList.toList(),
                            onSubmitted: (value) {
                              if (value == "") return;
                              if (!_strWorkoutList.contains(value)) {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("잠시만요!"),
                                        content:
                                            Text('처음 보는 운동 종목이에요!\n추가하시겠어요?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                User.currentUser.kindsOfWorkout.add(value);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text('네!',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _textController!.text = "";
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text('아니요!',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            },
                          ),
                        ),
                      ), // 운동 종목 입력 TextField
                      SizedBox(height: 20.0),
                      Container(
                        child: Focus(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _weightController,
                            decoration: InputDecoration(
                              hintText: "생략 가능해요!",
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelText: '무게 입력 (kg)',
                              labelStyle:
                                  kDefaultTextStyle.copyWith(fontSize: 20.0),
                            ),
                            onSubmitted: (value) {
                              if (value == "") return;
                            },
                          ),
                        ),
                      ), // 운동 종목 입력 TextField
                      SizedBox(height: 20.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _isTextFieldClicked
                                ? ""
                                : User.currentUser.isSetStarted
                                    ? _stopSet()
                                    : _startSet();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                User.currentUser.isSetStarted
                                    ? FontAwesomeIcons.stop
                                    : FontAwesomeIcons.play,
                                color: Colors.white,
                              ),
                              Text(
                                User.currentUser.isSetStarted
                                    ? '세트 종료'
                                    : '세트 시작',
                                style: kDefaultTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ) // 세트 시작 버튼
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: WorkoutListView(
              workoutList: User.currentUser.dailyWorkout.dailyWorkoutList,
              isLive: true,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DailyWorkoutScreen(
                                dailyWorkout:
                                    User.currentUser.myWorkoutRecord.isNotEmpty
                                        ? User.currentUser.myWorkoutRecord.last
                                        : DailyWorkout())));
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: ThemeData.dark().cardColor,
                        border: Border.all(color: Colors.white)),
                    child: Center(
                      child: Text(
                        '최근 운동 기록',
                        style: kDefaultTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    User.currentUser.isStarted ? _stop() : _start();
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        border: Border.all(color: Colors.white)),
                    child: Center(
                      child: Text(
                        User.currentUser.isStarted ? '운동 종료 및 기록' : '운동 시작',
                        style: kDefaultTextStyle,
                      ),
                    ),
                  ),
                ),
              ), // 운동 시작 버튼
            ],
          ), // 하단
        ],
      ),
    );
  }
}
