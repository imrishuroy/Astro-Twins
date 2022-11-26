import '/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class RequestSentDialog extends StatelessWidget {
  final String? name;
  const RequestSentDialog({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isIOS
        ? _showIOSDialog(context)
        : _showAndroidDialog(context);
    // Platform.isIOS ? _showIOSDialog(context) : _showAndroidDialog(context);
  }

  CupertinoAlertDialog _showIOSDialog(BuildContext context) {
    return CupertinoAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20.0),
          const CircleAvatar(
            radius: 45.0,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 40.0,
            ),
          ),
          const SizedBox(height: 35.0),
          const Text(
            'Friend Request',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Request has been placed to\n${name ?? ''} ',
            style: const TextStyle(
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50.0),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 40.0,
              width: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Contants.primaryColor,
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Text(
                  'OKAY',
                  style: TextStyle(
                    color: Contants.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
      // actions: [
      //   CupertinoDialogAction(
      //     child: const Text(
      //       'OK',
      //       style: TextStyle(color: Colors.blue),
      //     ),
      //     onPressed: () => Navigator.of(context).pop(),
      //   )
      // ],
    );
  }

  AlertDialog _showAndroidDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20.0),
          const CircleAvatar(
            radius: 45.0,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 40.0,
            ),
          ),
          const SizedBox(height: 35.0),
          const Text(
            'Friend Request',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Request has been placed to\n${name ?? ''} ',
            style: const TextStyle(
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60.0),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 40.0,
              width: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Contants.primaryColor,
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Text(
                  'OKAY',
                  style: TextStyle(
                    color: Contants.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),

      // actions: [
      //   TextButton(
      //     onPressed: () => Navigator.of(context).pop(),
      //     child: const Text(
      //       'OK',
      //       style: TextStyle(
      //         color: Colors.blue,
      //       ),
      //     ),
      //   ),
      // ],
    );
  }
}
