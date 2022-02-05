import 'package:flutter/material.dart';

class DumbbellSpinner extends StatefulWidget {
  const DumbbellSpinner({Key? key}) : super(key: key);

  @override
  State<DumbbellSpinner> createState() => _DumbbellSpinnerState();
}

class _DumbbellSpinnerState extends State<DumbbellSpinner>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: false);

  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: Transform.rotate(
          angle: -44.8,
          child: Icon(
            Icons.fitness_center_sharp,
            size: 35,
            color: Theme.of(context).colorScheme.primary,
          )),
    );
  }
}
