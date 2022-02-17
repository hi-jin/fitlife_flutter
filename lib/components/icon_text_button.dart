import 'package:fitlife/data/constatns.dart';
import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function onTap;

  const IconTextButton({
    Key? key,
    required this.iconData,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          child: Center(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData),
              const SizedBox(width: 15.0),
              Text(
                title,
                style: kDefaultTextStyle,
              )
            ],
          )),
          color: ThemeData.dark().cardColor,
          height: 100.0,
        ),
      ),
    );
  }
}
