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
      contentPadding: EdgeInsets.all(10),
      semanticLabel: message,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 70,
          ),
          SizedBox(
            height: 20,
          ),
          message == null ? Container() : Text(message.toString()),
        ],
      ),
      actions: [TextButton(onPressed: onTap, child: Text("Ok"))],
    );
  }
}
