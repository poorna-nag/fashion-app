// import 'package:flutter/material.dart';
// import 'package:royalmart/screen/home_page.dart';
// import 'package:royalmart/service_app/General/Home.dart';

// class ShowInVoiceId extends StatefulWidget {
//   final String invoice;
//   const ShowInVoiceId(this.invoice) : super();

//   @override
//   _ShowInVoiceIdState createState() => _ShowInVoiceIdState();
// }

// class _ShowInVoiceIdState extends State<ShowInVoiceId> {
//   Future<bool> _onBackPressed() {
//     return showDialog(
//           context: context,
//           builder: (context) => new AlertDialog(
//             title: new Text(''),
//             content: new Text('Do you want to continue Booking?'),
//             actions: <Widget>[
//               new GestureDetector(
//                 onTap: () => Navigator.of(context).pop(false),
//                 child: Text(""),
//               ),
//               SizedBox(height: 16),
//               new GestureDetector(
//                 onTap: () =>Navigator.pushAndRemoveUntil(context,   MaterialPageRoute(builder: (context) => HomePage()), (route) => false),
//                 child: Text("YES"),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onBackPressed,
//       child: Container(
//         child: AspectRatio(
//           aspectRatio: 100 / 100,
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.rectangle,
//               color: Colors.teal[50],
//             ),
//             child: Center(
//               child: Container(
//                 child: Card(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Center(
//                         child: Container(
//                           margin: EdgeInsets.only(top: 150),
//                           child: SizedBox(
//                             height: 300,
//                             width: double.infinity,
//                             child: Image.asset('assets/images/orderdone1.png'),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 0.0),
//                         child: ListTile(
//                           title: Center(
//                             child: Text(
//                               "Service Booked",
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 0.0, bottom: 1),
//                                     child: Container(
//                                       margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
//                                       height: 30,
//                                       width: 90,
//                                       decoration: BoxDecoration(
//                                         border: Border.all(
//                                           color: Colors.grey,
//                                         ),
// //                                    borderRadius: BorderRadius.(10.0),
//                                       ),
//                                       child: Center(
//                                         child: Text('Service ID',
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 2,
//                                             style: TextStyle(
//                                               color: Colors.green,
//                                               fontWeight: FontWeight.w700,
//                                             )),
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
//                                     height: 30,
//                                     width: 140,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: Colors.grey,
//                                       ),
// //                                    borderRadius: BorderRadius.(10.0),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         widget.invoice,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w700,
//                                           fontStyle: FontStyle.normal,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   InkWell(
//                                     onTap: () {
//                                     Navigator.pushAndRemoveUntil(context,   MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
//                                     },
//                                     child: Center(
//                                       child: Text(
//                                         "Continue Booking ?",
//                                         overflow: TextOverflow.ellipsis,
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.blue,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
