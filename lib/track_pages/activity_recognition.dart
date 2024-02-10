// import 'dart:async';
// import 'dart:io';

// import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ActivityRecognitionUtil {
//   static Future<void> startActivityRecognition(BuildContext context) async {
//     // ignore: unused_local_variable
//     StreamSubscription<ActivityEvent>? activityStreamSubscription;
//     List<ActivityEvent> events = [];
//     ActivityRecognition activityRecognition = ActivityRecognition();

//     void onData(ActivityEvent activityEvent) {
//       print(activityEvent);
//       events.add(activityEvent);
//     }

//     void onError(Object error) {
//       print('ERROR - $error');
//     }

//     void _startTracking() {
//       activityStreamSubscription = activityRecognition
//           .activityStream(runForegroundService: true)
//           .listen(onData, onError: onError);
//     }

//     void _init() async {
//       // Android requires explicitly asking permission
//       if (Platform.isAndroid) {
//         if (await Permission.activityRecognition.request().isGranted) {
//           _startTracking();
//         }
//       }
//       // iOS does not
//       else {
//         _startTracking();
//       }
//     }

//     _init();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             height: 300,
//             child: Scaffold(
//               appBar: AppBar(
//                 title: Text('Activity Recognition'),
//               ),
//               body: ListView.builder(
//                 itemCount: events.length,
//                 itemBuilder: (_, int idx) {
//                   final activity = events[idx];
//                   return ListTile(
//                     leading: _activityIcon(activity.type),
//                     title: Text(
//                         '${activity.type.toString().split('.').last} (${activity.confidence}%)'),
//                     trailing: Text(activity.timeStamp
//                         .toString()
//                         .split(' ')
//                         .last
//                         .split('.')
//                         .first),
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   static Icon _activityIcon(ActivityType type) {
//     switch (type) {
//       case ActivityType.WALKING:
//         return Icon(Icons.directions_walk);
//       case ActivityType.IN_VEHICLE:
//         return Icon(Icons.car_rental);
//       case ActivityType.ON_BICYCLE:
//         return Icon(Icons.pedal_bike);
//       case ActivityType.ON_FOOT:
//         return Icon(Icons.directions_walk);
//       case ActivityType.RUNNING:
//         return Icon(Icons.run_circle);
//       case ActivityType.STILL:
//         return Icon(Icons.cancel_outlined);
//       case ActivityType.TILTING:
//         return Icon(Icons.redo);
//       default:
//         return Icon(Icons.device_unknown);
//     }
//   }
// }
