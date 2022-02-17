import 'package:fitlife/classes/daily_workout.dart';
import 'package:fitlife/classes/user.dart';
import 'package:fitlife/classes/workout.dart';
import 'package:fitlife/data/constatns.dart';
import 'package:fitlife/screens/daily_workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:word_break_text/word_break_text.dart';

class StatisticsScreen extends StatefulWidget {
  static String id = 'statisticsScreen';

  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Tab> tabs = <Tab>[
    Tab(text: '기록별 통계'),
    Tab(text: '종목별 통계'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> _getWorkoutStatistics() {
    Map<String, int> statistics = {};
    for (DailyWorkout dailyWorkout in User.currentUser.myWorkoutRecord) {
      for (Workout workout in dailyWorkout.dailyWorkoutList) {
        if (statistics[workout.name] == null) {
          statistics[workout.name] = 0;
        }
        statistics[workout.name] = statistics[workout.name]! + workout.reps!;
      }
    }

    List<Widget> statisticWidgets = [];

    for (String key in statistics.keys) {
      statisticWidgets.add(Card(
        child: ListTile(
          title: WordBreakText(
            key,
            style: kTitleTextStyle,
            wrapAlignment: WrapAlignment.start,
          ),
          subtitle: Text('총 ${statistics[key].toString()}회!',
              style: TextStyle(fontSize: 20.0)),
        ),
      ));
    }

    return statisticWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs,
            labelStyle: kQuotTextStyle.copyWith(fontSize: 25.0),
          ),
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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        List<DailyWorkout> list = List<DailyWorkout>.from(
                            User.currentUser.myWorkoutRecord.reversed);
                        return Dismissible(
                          confirmDismiss: (direction) async {
                            switch (direction) {
                              case DismissDirection.startToEnd:
                                bool delete = await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('잠시만요!'),
                                      content: Text('정말 삭제하시겠어요?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: Text(
                                            "네!",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: Text(
                                            "아니요!",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return delete;
                              case DismissDirection.endToStart:
                                String? newTitle = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("제목을 수정할 수 있습니다."),
                                        content: TextField(
                                          autofocus: true,
                                          onSubmitted: (value) {
                                            if (value == "") {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('잠시만요!'),
                                                      content: Text(
                                                          '제목은 비워둘 수 없습니다!'),
                                                    );
                                                  });
                                            } else {
                                              Navigator.pop(context, value);
                                            }
                                          },
                                        ),
                                      );
                                    });
                                if (newTitle != null) {
                                  setState(() {
                                    User.currentUser.myWorkoutRecord[list.length-1 - index].title = newTitle;
                                    User.isChanged = true;
                                  });
                                }
                                return false;
                              default:
                                return false;
                            }
                          },
                          background: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: double.infinity,
                              color: Colors.redAccent,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      child: Icon(FontAwesomeIcons.trash),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          secondaryBackground: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: double.infinity,
                              color: Colors.grey,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      child: Icon(FontAwesomeIcons.pencilAlt),
                                    ),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.end,
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              setState(() {
                                User.currentUser.myWorkoutRecord.removeAt(list.length-1 - index);
                                User.isChanged = true;
                              });
                            }
                          },
                          key: UniqueKey(),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DailyWorkoutScreen(
                                    dailyWorkout: list[index]);
                              }));
                            },
                            child: Card(
                              child: ListTile(
                                leading: Text(
                                  (list.length - index).toString(),
                                  style: kTitleTextStyle,
                                ),
                                title: Text(
                                  list[index].title,
                                  style: kTitleTextStyle,
                                ),
                                subtitle: Text(
                                  "${list[index].date.year}년 ${list[index].date.month}월 ${list[index].date.day}일"
                                      .toString(),
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: User.currentUser.myWorkoutRecord.length,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GridView.count(
                  childAspectRatio: 11 / 6,
                  crossAxisCount: 2,
                  children: _getWorkoutStatistics(),
                ),
              )
            ],
          ),
        ));
  }
}
