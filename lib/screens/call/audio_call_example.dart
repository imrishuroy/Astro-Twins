// import 'dart:async';
// import 'dart:developer';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:astro_twins/repositories/agora/agora_repository.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '/screens/call/audio_config.dart' as config;

// /// JoinChannelAudio Example
// class JoinChannelAudio extends StatefulWidget {
//   /// Construct the [JoinChannelAudio]
//   const JoinChannelAudio({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _State();
// }

// class _State extends State<JoinChannelAudio> {
//   late final RtcEngine _engine;
//   String channelId = config.channelId;
//   bool isJoined = false,
//       openMicrophone = true,
//       enableSpeakerphone = true,
//       playEffect = false;
//   bool _enableInEarMonitoring = false;
//   double _recordingVolume = 100,
//       _playbackVolume = 100,
//       _inEarMonitoringVolume = 100;
//   late TextEditingController _controller;
//   ChannelProfileType _channelProfileType =
//       ChannelProfileType.channelProfileLiveBroadcasting;

//   Future<void> switchEffect() async {
//     if (playEffect) {
//       _engine.stopEffect(1).then((value) {
//         setState(() {
//           playEffect = false;
//         });
//       }).catchError((error) {
//         debugPrint('stopEffect $error');
//       });
//     } else {
//       _engine
//           .playEffect(
//         soundId: 1,
//         filePath: 'assets/audios/ringtone.mp3',
//         loopCount: 1,
//         pan: 1,
//         pitch: 1,
//         gain: 1,
//         publish: true,
//         startPos: 100,
//       )

//           // _engine
//           //     .playEffect(
//           //   1,
//           //   await RtcEngineExtension.getAssetAbsolutePath(
//           //       'assets/sounds/house_phone_uk.mp3'),
//           //   -1,
//           //   1,
//           //   1,
//           //   100,
//           //   true,
//           // )
//           .then((value) {
//         setState(() {
//           playEffect = true;
//         });
//       }).catchError((err) {
//         debugPrint('playEffect $err');
//       });
//     }
//   }

//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(text: channelId);

//     _initEngine();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//     _timer.cancel();
//     _dispose();
//   }

//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }

//   Future<void> _initEngine() async {
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(
//       appId: config.appId,
//     ));

//     _engine.registerEventHandler(
//         RtcEngineEventHandler(onError: (ErrorCodeType err, String msg) {
//       log('[onError] err: $err, msg: $msg');
//     }, onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//       log('[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');

//       _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
//         setState(() {
//           _callTimer++;
//           isJoined = true;
//         });
//       });

//       // setState(() {
//       //   isJoined = true;
//       // });
//     }, onLeaveChannel: (RtcConnection connection, RtcStats stats) {
//       log('[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
//       setState(() {
//         isJoined = false;
//         _callTimer = 0;
//       });
//     }, onUserJoined: (connection, remoteUid, elapsed) {
//       debugPrint('userJoined $remoteUid');
//       remoteUid = remoteUid;
//       if (playEffect) switchEffect();
//       //if (!canIncrement) canIncrement = true;
//     }));

//     await _engine.enableAudio();
//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.setAudioProfile(
//       profile: AudioProfileType.audioProfileDefault,
//       scenario: AudioScenarioType.audioScenarioGameStreaming,
//     );
//   }

//   _joinChannel() async {
//     // final agoraRepo = context.read<AgoraRepository>();
//     final agoraRepo = AgoraRepository();
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       await Permission.microphone.request();
//     }

//     const String channelName = 'TestChannel';

//     final token = await agoraRepo.getToken(channelName: channelName);

//     print('Token from rtc server $token');

//     if (token != null) {
//       await _engine.joinChannel(
//           token: token,
//           channelId: channelName,
//           uid: config.uid,
//           options: ChannelMediaOptions(
//             channelProfile: _channelProfileType,
//             clientRoleType: ClientRoleType.clientRoleBroadcaster,
//           ));
//       switchEffect();
//     }
//   }

//   _leaveChannel() async {
//     await _engine.leaveChannel();
//     setState(() {
//       isJoined = false;
//       openMicrophone = true;
//       enableSpeakerphone = true;
//       playEffect = false;
//       _enableInEarMonitoring = false;
//       _recordingVolume = 100;
//       _playbackVolume = 100;
//       _inEarMonitoringVolume = 100;
//     });
//   }

//   _switchMicrophone() async {
//     // await await _engine.muteLocalAudioStream(!openMicrophone);
//     await _engine.enableLocalAudio(!openMicrophone);
//     setState(() {
//       openMicrophone = !openMicrophone;
//     });
//   }

//   _switchSpeakerphone() async {
//     await _engine.setEnableSpeakerphone(!enableSpeakerphone);
//     setState(() {
//       enableSpeakerphone = !enableSpeakerphone;
//     });
//   }

//   _switchEffect() async {
//     if (playEffect) {
//       await _engine.stopEffect(1);
//       setState(() {
//         playEffect = false;
//       });
//     } else {
//       final path =
//           (await _engine.getAssetAbsolutePath('assets/Sound_Horizon.mp3'))!;
//       await _engine.playEffect(
//           soundId: 1,
//           filePath: path,
//           loopCount: 0,
//           pitch: 1,
//           pan: 1,
//           gain: 100,
//           publish: true);
//       // .then((value) {
//       setState(() {
//         playEffect = true;
//       });
//     }
//   }

//   _onChangeInEarMonitoringVolume(double value) async {
//     _inEarMonitoringVolume = value;
//     await _engine.setInEarMonitoringVolume(_inEarMonitoringVolume.toInt());
//     setState(() {});
//   }

//   _toggleInEarMonitoring(value) async {
//     try {
//       await _engine.enableInEarMonitoring(
//           enabled: value,
//           includeAudioFilters: EarMonitoringFilterType.earMonitoringFilterNone);
//       _enableInEarMonitoring = value;
//       setState(() {});
//     } catch (e) {
//       // Do nothing
//     }
//   }

//   int _callTimer = 0;

//   @override
//   Widget build(BuildContext context) {
//     ///return

//     // CallInterfaceDesign(
//     //   onTapCall: isJoined ? _leaveChannel : _joinChannel,
//     //   duration: _callTimer,
//     //   isCalling: isJoined,
//     // );

//     final channelProfileType = [
//       ChannelProfileType.channelProfileLiveBroadcasting,
//       ChannelProfileType.channelProfileCommunication,
//     ];
//     final items = channelProfileType
//         .map((e) => DropdownMenuItem(
//               value: e,
//               child: Text(
//                 e.toString().split('.')[1],
//               ),
//             ))
//         .toList();

//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(14.0),
//           child: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(hintText: 'Channel ID'),
//                   ),
//                   const Text('Channel Profile: '),
//                   DropdownButton<ChannelProfileType>(
//                       items: items,
//                       value: _channelProfileType,
//                       onChanged: isJoined
//                           ? null
//                           : (v) async {
//                               setState(() {
//                                 _channelProfileType = v!;
//                               });
//                             }),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: ElevatedButton(
//                           onPressed: isJoined ? _leaveChannel : _joinChannel,
//                           child: Text('${isJoined ? 'Leave' : 'Join'} channel'),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//               Align(
//                   alignment: Alignment.bottomRight,
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         ElevatedButton(
//                           onPressed: _switchMicrophone,
//                           child: Text(
//                               'Microphone ${openMicrophone ? 'on' : 'off'}'),
//                         ),
//                         ElevatedButton(
//                           onPressed: isJoined ? _switchSpeakerphone : null,
//                           child: Text(
//                               enableSpeakerphone ? 'Speakerphone' : 'Earpiece'),
//                         ),
//                         if (!kIsWeb)
//                           ElevatedButton(
//                             onPressed: isJoined ? _switchEffect : null,
//                             child:
//                                 Text('${playEffect ? 'Stop' : 'Play'} effect'),
//                           ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             const Text('RecordingVolume:'),
//                             Slider(
//                               value: _recordingVolume,
//                               min: 0,
//                               max: 400,
//                               divisions: 5,
//                               label: 'RecordingVolume',
//                               onChanged: isJoined
//                                   ? (double value) async {
//                                       setState(() {
//                                         _recordingVolume = value;
//                                       });
//                                       await _engine.adjustRecordingSignalVolume(
//                                           value.toInt());
//                                     }
//                                   : null,
//                             )
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             const Text('PlaybackVolume:'),
//                             Slider(
//                               value: _playbackVolume,
//                               min: 0,
//                               max: 400,
//                               divisions: 5,
//                               label: 'PlaybackVolume',
//                               onChanged: isJoined
//                                   ? (double value) async {
//                                       setState(() {
//                                         _playbackVolume = value;
//                                       });
//                                       await _engine.adjustPlaybackSignalVolume(
//                                           value.toInt());
//                                     }
//                                   : null,
//                             )
//                           ],
//                         ),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Row(mainAxisSize: MainAxisSize.min, children: [
//                               const Text('InEar Monitoring Volume:'),
//                               Switch(
//                                 value: _enableInEarMonitoring,
//                                 onChanged:
//                                     isJoined ? _toggleInEarMonitoring : null,
//                                 activeTrackColor: Colors.grey[350],
//                                 activeColor: Colors.white,
//                               )
//                             ]),
//                             if (_enableInEarMonitoring)
//                               SizedBox(
//                                   width: 300,
//                                   child: Slider(
//                                     value: _inEarMonitoringVolume,
//                                     min: 0,
//                                     max: 100,
//                                     divisions: 5,
//                                     label:
//                                         'InEar Monitoring Volume $_inEarMonitoringVolume',
//                                     onChanged: isJoined
//                                         ? _onChangeInEarMonitoringVolume
//                                         : null,
//                                   ))
//                           ],
//                         ),
//                       ],
//                     ),
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
