import 'package:astro_twins/models/app_user.dart';
import 'package:flutter/material.dart';

class CallInterfaceDesign extends StatefulWidget {
  final VoidCallback onTapCall;
  final bool isJoined;
  final int duration;
  final VoidCallback switchMicrophone;
  final bool isOnSpeaker;
  final AppUser? otherUser;
  final VoidCallback cancelCall;

  const CallInterfaceDesign({
    super.key,
    required this.onTapCall,
    required this.isJoined,
    required this.duration,
    required this.switchMicrophone,
    required this.isOnSpeaker,
    required this.otherUser,
    required this.cancelCall,
  });

  @override
  State<CallInterfaceDesign> createState() => _CallInterfaceDesignState();
}

class _CallInterfaceDesignState extends State<CallInterfaceDesign> {
  // late Timer _timer;

  // final int _start = 0;

  @override
  void initState() {
    widget.onTapCall();

    super.initState();
  }

  @override
  void dispose() {
    // widget.cancelCall();

    super.dispose();
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
    final size = MediaQuery.of(context).size;
    final otherUser = widget.otherUser;
    print('Is joined ${widget.isJoined}');
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomCenter,
          // stops: [0.1, 0.5, 0.7, 0.9],
          stops: [0.6, 0.9],
          colors: [
            Color(0xffED462F),
            Color(0xffF28931),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                otherUser?.name ?? 'USER',
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),

              const SizedBox(height: 32.0),
              CircleAvatar(
                radius: 70.0,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 68.0,
                  backgroundImage: NetworkImage(otherUser?.profileImg ??
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSlwSKnPw36vUip0PTBT1mmlzif5KJKtqMQw&usqp=CAU'),
                ),
              ),

              const SizedBox(height: 20.0),

              Text(
                widget.isJoined ? 'Connected' : 'Calling...',
                // widget.isJoined ? '50:0' : 'Calling',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),

              // Text(
              //   '50:$_start',
              //   style: const TextStyle(
              //     color: Colors.white,
              //     fontSize: 20.0,
              //   ),
              // ),

              SizedBox(height: size.height * 0.4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.record_voice_over,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      size: 28.0,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.cancelCall();
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      radius: 32.0,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.call,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: widget.switchMicrophone,
                    icon: Icon(
                      widget.isOnSpeaker ? Icons.mic : Icons.volume_up,
                      color: Colors.white,
                      size: 28.0,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // Scaffold(
    //   body: Column(
    //     children: [
    //       const Spacer(),
    //       Text(widget.isCalling ? 'Connected' : ''),
    //       if (widget.isCalling) Text('${widget.duration}'),
    //       const Spacer(),
    //       Center(
    //         child: InkWell(
    //           onTap: widget.onTapCall,
    //           child: const CircleAvatar(
    //             radius: 24.0,
    //             child: Icon(Icons.call),
    //           ),
    //         ),
    //       ),
    //       const SizedBox(height: 24.0),
    //     ],
    //   ),
    // );
  }
}
