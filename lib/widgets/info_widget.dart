import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final String type;
  final String data;

  const Info({Key? key, required this.type, required this.data})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(type, style: Theme.of(context).textTheme.caption),
          SizedBox(height: 5),
          SelectableText(data),
        ],
      ),
    );
  }
}
