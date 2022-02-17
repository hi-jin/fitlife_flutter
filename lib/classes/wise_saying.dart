class WiseSaying {
  final String saying;
  final String name;

  WiseSaying({required this.saying, required this.name});

  static List<WiseSaying> getList() {
    return [
      WiseSaying(
        saying: "믿음이 부족하기에 사람들은 도전하기를 두려워하지만, 나는 나 자신을 믿는다.",
        name: "무하마드 알리",
      ),
      WiseSaying(
        saying: "재능에 노력을 더하지 않으면 아무런 소용이 없다.",
        name: "팀 노케",
      ),
      WiseSaying(
        saying: "어려운 전투일수록 그 승리는 달콤하다.",
        name: "레스 브라운",
      ),
      WiseSaying(
        saying: "최선을 다하는 자는 후회하지 않는다.",
        name: "조지 할라스",
      ),
      WiseSaying(
        saying:
            "트레이닝은 스트레스로부터 억눌린 에너지를 분출할 수 있게 한다. 그러므로 운동이 몸을 건강하게 하듯이 정신 역시 건강하게 한다.",
        name: "아놀드 슈워제네거",
      ),
      WiseSaying(
        saying: "미래를 예상하는 가장 좋은 방법은 직접 미래를 만드는 것이지",
        name: "에이브러햄 링컨",
      ),
      WiseSaying(
        saying: "노력과 성공의 차이는 매우 작은 비명소리(노력)이지.",
        name: "마빈 필립스",
      ),
    ];
  }
}
