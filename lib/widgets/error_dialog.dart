import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String? content;

  const ErrorDialog({
    Key? key,
    this.title = 'Error !',
    @required this.content,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isIOS
        ? _showIOSDialog(context)
        : _showAndroidDialog(context);
    // Platform.isIOS ? _showIOSDialog(context) : _showAndroidDialog(context);
  }

  CupertinoAlertDialog _showIOSDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      content: Text(
        content ?? '',
        style: const TextStyle(color: Colors.black),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  AlertDialog _showAndroidDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      //   backgroundColor: Colors.grey.shade700,
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      content: Text(
        content ?? '',
        style: const TextStyle(color: Colors.black),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'OK',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
