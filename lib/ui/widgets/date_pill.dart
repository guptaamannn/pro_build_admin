import 'package:flutter/material.dart';
import 'package:pro_build_attendance/core/utils/formatter.dart';

class DatePill extends StatelessWidget {
  final DateTime date;
  final DateTime selectedDate;
  final Function onTap;

  const DatePill({
    Key? key,
    required this.date,
    required this.selectedDate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = Formatter.justDate(date) == selectedDate;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? Theme.of(context).colorScheme.inversePrimary
                : null,
          ),
          margin: EdgeInsets.symmetric(horizontal: 12),
          height: 70,
          width: 50,
          child: InkWell(
            onTap: () => onTap(date),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Text(
                  Formatter.toDay(date),
                  style: isSelected
                      ? TextStyle(fontSize: 10)
                      : Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
        isSelected
            ? Text(
                ".",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                ),
              )
            : Container()
      ],
    );
  }
}
