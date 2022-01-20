import 'package:flutter/material.dart';

class CustomSortButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final bool isDescending;

  const CustomSortButton(
      {Key? key,
      required this.onTap,
      required this.title,
      required this.isDescending})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: onTap(),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(
              width: 6,
            ),
            Icon(
              isDescending
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
