import 'package:flutter/material.dart';

class NoDataSign extends StatelessWidget {
  const NoDataSign({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset(
        'no_data.png',
        height: 200,
      ),
    ]);
  }
}
