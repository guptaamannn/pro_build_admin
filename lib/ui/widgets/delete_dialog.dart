import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final void Function()? onPressed;

  const DeleteDialog({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
      content: const Text("Are you sure you want to delete this item?"),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.errorContainer),
          child: Text(
            "Delete",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer),
          ),
          onPressed: onPressed,
        )
      ],
    );
  }
}
