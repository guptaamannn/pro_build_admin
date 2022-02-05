import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  final IconData icon;
  final void Function()? onTap;

  const ErrorDialog(
      {Key? key, this.message, required this.icon, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      semanticLabel: message,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 30,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(
            height: 20,
          ),
          message == null
              ? Container()
              : Text(
                  message.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
        ],
      ),
      actions: [TextButton(onPressed: onTap, child: Text("Ok"))],
    );
  }
}
