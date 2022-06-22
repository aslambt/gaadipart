// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
//
// class Lottie extends StatefulWidget {
//   const Lottie({Key key}) : super(key: key);
//
//   @override
//   State<Lottie> createState() => _LottieState();
// }
//
// class _LottieState extends State<Lottie>
// with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//
//   @override
//   void initState(){
//   super.initState();
//
//   controller = AnimationController(
//     vsync:this,
//   );
//   controller.addStatusListner((status) async{
//  if(status == AnimationStatus.completed){
//    Navigator.pop(context);
//    controller.reset();
//  }
//   });
//   }
//   @override
//   void dispose(){
//     controller.dispose();
//     super.dispose();
// }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Center(
//             child: Text("Lottie Animation")
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//               onPressed: (){
//     ShowDoneDialog();
//     },
//               child: Text("Click"),)
//         ],
//       ),
//     );
//   }
// }
//
// void ShowDoneDialog() => showDialog(
//   barrierDismissible : false,
//   context : context,
//   builder: (context) => Dialog(
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Lottie.asset('assets/order.json',
//         repeat:false,
//           controller : controller,
//           onLoaded : (composition){
//             controller.duration = composition.duration;
//             controller.forward();
//           }
//         ),
//         Text(
//             "Your order has been placed successfully ")
//       ],
//     ),
//   )
//
// );