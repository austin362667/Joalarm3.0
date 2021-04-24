// import 'package:amplitude_flutter/amplitude.dart';
// import 'package:amplitude_flutter/identify.dart';

// class Growth {
//   Future<void> exampleForAmplitude() async {
//     // Create the instance
//     final Amplitude analytics = Amplitude.getInstance(instanceName: "project");

//     // Initialize SDK
//     analytics.init('99ccad6608a4b02c2e373cb65a19058a');

//     // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
//     analytics.enableCoppaControl();

//     // Set user Id
//     analytics.setUserId("test_user");

//     // Turn on automatic session events
//     analytics.trackingSessionEvents(true);

//     // Log an event
//     analytics.logEvent('MyApp startup', eventProperties: {
//       'friend_num': 10,
//       'is_heavy_user': true
//     });

//     // Identify
//     final Identify identify1 = Identify()
//       ..set('identify_test',
//           'identify sent at ${DateTime.now().millisecondsSinceEpoch}')
//       ..add('identify_count', 1);
//     analytics.identify(identify1);

//     // Set group
//     analytics.setGroup('orgId', 15);

//     // Group identify
//     final Identify identify2 = Identify()
//       ..set('identify_count', 1);
//     analytics.groupIdentify('orgId', '15', identify2);
//   }



//   Future<void> setUserEmail(String email) async {

//     final Amplitude analytics = Amplitude.getInstance(instanceName: "project");
//     analytics.init('99ccad6608a4b02c2e373cb65a19058a');
//     analytics.enableCoppaControl();
//     analytics.setUserId(email);

//   }

//   Future<void> setTarget() async {

//     final Amplitude analytics = Amplitude.getInstance(instanceName: "project");
//     analytics.init('99ccad6608a4b02c2e373cb65a19058a');
//     analytics.enableCoppaControl();
//     analytics.logEvent('Set Target');
    
//   }

//     Future<void> socialShare() async {

//     final Amplitude analytics = Amplitude.getInstance(instanceName: "project");
//     analytics.init('99ccad6608a4b02c2e373cb65a19058a');
//     analytics.enableCoppaControl();
//     analytics.logEvent('Social Share');
    
//   }
// }