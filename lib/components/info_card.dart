import 'package:fitlife/data/constatns.dart';
import 'package:flutter/material.dart';
import 'package:word_break_text/word_break_text.dart';

class InfoCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String subTitle;

  const InfoCard({Key? key, required this.iconData, required this.title, this.subTitle = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(iconData),
        title: WordBreakText(
          title,
          style: kQuotTextStyle,
          wrapAlignment: WrapAlignment.start,
        ),
        subtitle: subTitle == ""
            ? null
            : Text(
                "- $subTitle",
                style: kQuotTextStyle,
              ),
      ),
    );
  }
}
