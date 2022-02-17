import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map> alarmType = [
  {
    "name": "none",
    "title": "알람기능 사용 안 함",
    "iconData": FontAwesomeIcons.ban,
    "desc": "\"시끄러운 알람 듣기 싫어요!\"\n휴식시간 알람 기능을 사용하지 않는 모드입니다.",
  },
  {
    "name": "default",
    "title": "알람기능 사용",
    "iconData": FontAwesomeIcons.clock,
    "desc": "타이머를 설정하여, 세트 사이 휴식 중 시간이 되면 알람을 울립니다.\n\n아직 개발중이에요!",
  },
];
