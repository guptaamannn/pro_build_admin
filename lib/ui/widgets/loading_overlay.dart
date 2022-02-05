import 'package:flutter/material.dart';
import 'package:pro_build_attendance/ui/widgets/dumbbell_spinner.dart';

class ModalProgressIndicator extends StatelessWidget {
  const ModalProgressIndicator({
    required this.child,
    required this.isLoading,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading
            ? Stack(
                children: [
                  Opacity(
                    opacity: 0.6,
                    child: ModalBarrier(
                      dismissible: false,
                      color: Colors.black,
                    ),
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(16)),
                          alignment: Alignment.center,
                          child: DumbbellSpinner(),
                        ),

                        // Container(
                        //   margin: EdgeInsets.only(top: 20),
                        //   child: Text(
                        //     'Loading...',
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
