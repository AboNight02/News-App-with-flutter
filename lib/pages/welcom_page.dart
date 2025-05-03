// import 'package:flutter/material.dart';

// class NewsIntroScreen extends StatelessWidget {
//   const NewsIntroScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: [
//               const SizedBox(height: 24),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Stay Updated",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Latest News at Your Fingertips",
//                     style: TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1F2937),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(32),
//                   child: Image.asset(
//                     'assets/news_illustration.png', // Replace with your own image
//                     fit: BoxFit.cover,
//                     height: 280,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 32),
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Navigate to login or home
//                     },
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       padding: EdgeInsets.zero,
//                       elevation: 4,
//                     ),
//                     child: Ink(
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFFF857A6), Color(0xFFFF5858)],
//                         ),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: Container(
//                         alignment: Alignment.center,
//                         child: const Text(
//                           "GET STARTED",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Terms of service",
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
