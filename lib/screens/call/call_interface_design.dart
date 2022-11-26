import 'dart:async';

import 'package:flutter/material.dart';

class CallInterfaceDesign extends StatefulWidget {
  final VoidCallback onTapCall;
  final bool isCalling;
  final int duration;

  const CallInterfaceDesign({
    super.key,
    required this.onTapCall,
    required this.isCalling,
    required this.duration,
  });

  @override
  State<CallInterfaceDesign> createState() => _CallInterfaceDesignState();
}

class _CallInterfaceDesignState extends State<CallInterfaceDesign> {
  late Timer _timer;

  final int _start = 0;

  @override
  void initState() {
    super.initState();
  }

  // void manageCall() {
  //   widget.onTapCall();
  //   if (widget.isCalling) {
  //     _timer.cancel();
  //   } else {
  //     _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
  //       setState(() {
  //         _start++;
  //       });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print('Is joined ${widget.isCalling}');
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Text(widget.isCalling ? 'Connected' : ''),
          if (widget.isCalling) Text('${widget.duration}'),
          const Spacer(),
          Center(
            child: InkWell(
              onTap: widget.onTapCall,
              child: const CircleAvatar(
                radius: 24.0,
                child: Icon(Icons.call),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
