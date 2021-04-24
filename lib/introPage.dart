// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:Crushon/loginPage.dart';
// import 'package:Crushon/main.dart';
// import 'package:Crushon/signupPage.dart';

// class IntroPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return IntroductionScreen(
//       pages: listPagesViewModel,
//       onDone: () {
//         // When done button is press
//       },
//       onSkip: () async {
//         String? _jwt = await safeStorage.read(key: 'jwt');
//         if (_jwt != null) {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => HomePage.fromBase64(_jwt)));
//         }
//       },
//       showSkipButton: false,
//       showDoneButton: false,
//       skip: const Text('Skip'),
//       next: const Icon(Icons.navigate_next),
//       // done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
//       dotsDecorator: DotsDecorator(
//           size: const Size.square(10.0),
//           activeSize: const Size(20.0, 10.0),
//           activeColor: Colors.black,
//           color: Colors.black26,
//           spacing: const EdgeInsets.symmetric(horizontal: 3.0),
//           activeShape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(25.0))),
//     );
//   }
// }

// List<PageViewModel> listPagesViewModel = [
//   PageViewModel(
//       title: "歡迎使用 Crushon",
//       bodyWidget: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: const [
//           Text(
//             "在 Crushon 的世界裡\n每個人都有專屬的一顆戀愛鈴",
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//       image: Center(
//           child: Container(
//               padding: EdgeInsets.all(35),
//               child: Image(image: AssetImage('0.png'))))),
//   PageViewModel(
//     title: "當周遭100m內",
//     bodyWidget: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: const [
//         Text(
//           "有人對您滋生情愫時\n戀愛鈴就會被敲響!",
//           textAlign: TextAlign.center,
//         ),
//       ],
//     ),
//     image: Center(
//         child: Container(
//             padding: EdgeInsets.all(35),
//             child: Image(image: AssetImage('1.png')))),
//   ),
//   PageViewModel(
//     title: "如何秘密地敲響對方的鈴呢?",
//     bodyWidget: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: const [
//         Text(
//           "點擊放大鏡關注讓您怦然心動的人",
//           textAlign: TextAlign.center,
//         ),
//       ],
//     ),
//     image: Center(
//         child: Container(
//             padding: EdgeInsets.all(35),
//             child: Image(image: AssetImage('2.png')))),
//   ),
//   PageViewModel(
//     title: "喜歡的話",
//     bodyWidget: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: const [
//         Text(
//           "就請敲響彼此的戀愛鈴吧~",
//           textAlign: TextAlign.center,
//         ),
//       ],
//     ),
//     image: Center(
//         child: Container(
//             padding: EdgeInsets.all(35),
//             child: Image(image: AssetImage('3.png')))),
//   ),
//   PageViewModel(title: '帳號註冊', bodyWidget: SignupPage()),
//   PageViewModel(title: '用戶登入', bodyWidget: LoginPage())
// ];
