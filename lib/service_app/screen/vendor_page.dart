// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:html/parser.dart';
// import 'package:intl/intl.dart';
// import 'package:royalmart/service_app/General/AppConstant.dart';
// import 'package:royalmart/service_app/dbhelper/CarrtDbhelper.dart';
// import 'package:royalmart/service_app/model/ListModel.dart';
// import 'package:royalmart/service_app/model/productmodel.dart';

// import 'checkout.dart';

// class VendorPage extends StatefulWidget {
//   final Products plist;
//   final String openTime;
//   final String closeTime;

//   const VendorPage(this.plist, this.openTime, this.closeTime) : super();

//   @override
//   _VendorPageState createState() => _VendorPageState();
// }

// class _VendorPageState extends State<VendorPage> {
//   ScrollController _scrollController = ScrollController();
//   List<String> slots = [];

//   Iterable<TimeOfDay> getTimes(TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
//     var hour = startTime.hour;
//     var minute = startTime.minute;
//     do {
//       yield TimeOfDay(hour: hour, minute: minute);
//       minute += step.inMinutes;
//       while (minute >= 60) {
//         minute -= 60;
//         hour++;
//       }
//     } while (hour < endTime.hour || (hour == endTime.hour && minute <= endTime.minute));
//   }

//   calculate_Slots() {
//     String startTimee = widget.openTime;
//     String endTimee = widget.closeTime;

//     String startTimeHour = startTimee.substring(0, startTimee.indexOf(':'));
//     String startTimeMinuet = startTimee.substring(startTimee.indexOf(':') + 1);

//     String endTimeHour = endTimee.substring(0, endTimee.indexOf(':'));
//     String endTimeMinuet = endTimee.substring(endTimee.indexOf(':') + 1);

//     print("stringggg--> ${startTimeHour}");
//     print("stringggg--> ${startTimeMinuet}");
//     print("stringggg--> ${endTimeHour}");
//     print("stringggg--> ${endTimeMinuet}");

//     final startTime1 = TimeOfDay(hour: int.parse(startTimeHour), minute: int.parse(startTimeMinuet));
//     final endTime1 = TimeOfDay(hour: int.parse(endTimeHour), minute: int.parse(endTimeMinuet));
//     final step = Duration(minutes: 30);

//     slots = getTimes(startTime1, endTime1, step).map((tod) => tod.format(context)).toList();

//     print(slots);
//     // String open= widget.mvlis.open_time;
//     // String close= widget.mvlis.close_time;
//     // double totaltime=double.parse(close)-double.parse(open);
//     // for(var i=0;i<totaltime*2;i++){
//     //
//     //   slots.add(double.parse(open).toString());
//     // }
//   }

//   String dateval;
//   String timeval;
//   DateTime startDate;
//   DateTime endDate;
//   var now;

//   calculate_dateCalender() {
//     setState(() {
//       now = DateTime.now();
//       dateval = now.year.toString() + "-" + now.month.toString() + "-" + now.day.toString();
//       //   dateval=now.toString().substring(0,10);
//       // startDate = now.subtract(Duration(days: 0));
//       //  endDate = now.add(Duration(days: 6));
//       print('startDate = $startDate ; endDate = $dateval');
//     });
//   }

//   @override
//   void initState() {
//     // calculate_dateCalender();

//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     calculate_Slots();
//     calculate_dateCalender();
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: ServiceAppColors.red,
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 color: ServiceAppColors.tela,
//                 padding: EdgeInsets.only(top: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         icon: Icon(
//                           Icons.arrow_back,
//                           color: Colors.white,
//                         )),
//                   ],
//                 ),
//               ),
//               Container(
//                 color: ServiceAppColors.tela,
//                 padding: EdgeInsets.only(left: 5),
//                 height: 200,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(right: 26, top: 20),
//                           child: SizedBox(
//                               width: MediaQuery.of(context).size.width / 2 + 10,
//                               child: Text(
//                                 '${widget.plist.productName}',
//                                 style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                               )),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width / 2 + 10,
//                           padding: const EdgeInsets.only(top: 2.0, bottom: 1, left: 5),
//                           child: Text('\u{20B9} ${calDiscount(widget.plist.buyPrice, widget.plist.discount)}',
//                               style: TextStyle(
//                                 color: ServiceAppColors.sellp,
//                                 fontWeight: FontWeight.w700,
//                               )),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             IconButton(
//                                 onPressed: () {},
//                                 icon: Icon(
//                                   Icons.location_on,
//                                   color: ServiceAppColors.sellp,
//                                 )),
//                             SizedBox(
//                                 width: MediaQuery.of(context).size.width / 3 - 10,
//                                 child: Text(
//                                   '${widget.plist.address + "," + widget.plist.city}',
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(color: Colors.white),
//                                 ))
//                           ],
//                         ),
//                       ],
//                     ),
//                     widget.plist.img.length > 0
//                         ? Container(
//                             margin: EdgeInsets.only(right: 6),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image.network(
//                                 ServiceAppConstant.Product_Imageurl + widget.plist.img,
//                                 width: MediaQuery.of(context).size.width / 3 + 10,
//                                 height: 180,
//                                 fit: BoxFit.fill,
//                               ),
//                             ))
//                         : Image.asset("assets/images/d.png"),
//                   ],
//                 ),
//               ),

//               /* Container(alignment: Alignment.topLeft,
//             padding: EdgeInsets.only(left: 18,top: 15),
//               child: Text('Appointment',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,),),
//             ),*/
//               /*Container(alignment: Alignment.topLeft,
//             padding: EdgeInsets.only(left: 18,top: 13),
//               child: Text('Select Date',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,))),
//         */

//               /* Container(
//             padding: EdgeInsets.only(top: 8),
//             alignment: Alignment.center,
//               child: HorizontalDatePickerWidget(

//             startDate: startDate,
//             endDate: endDate,
//             selectedDate: DateTime.now(),
//             selectedColor: Colors.blue,
//             widgetWidth: MediaQuery.of(context).size.width,
//             datePickerController: DatePickerController(),
//             onValueSelected: (date1) {
//               dateval=date1.year.toString()+"-"+date1.month.toString()+"-"+date1.day.toString();
//               // print('selected = ${date1.year}  ${dateval}');
//             },
//           ),
//            ),*/

//               Container(
//                 alignment: Alignment.topLeft,
//                 padding: EdgeInsets.only(left: 18, top: 14),
//                 child: Text(
//                   'Choose Time Slot',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               slots != null
//                   ? Container(
//                       child: GridView.builder(
//                         controller: _scrollController,
//                         shrinkWrap: true,
//                         physics: ClampingScrollPhysics(),
//                         itemCount: slots.length,
//                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           childAspectRatio: 3,
//                           crossAxisSpacing: 1,
//                           mainAxisSpacing: 1,
//                         ),
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 8),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 50,
//                                   width: 200,
//                                   child: new Card(
//                                     color: colorIndex == index ? Colors.blue : Colors.white,
//                                     child: TextButton(
//                                       onPressed: () {
//                                         changeColor(index);
//                                         timeval = slots[index];
//                                       },
//                                       child: Text(
//                                         '${DateFormat("hh:mm a").format(DateFormat("hh:mm a").parseLoose(slots[index].toString()))}',
//                                         style: TextStyle(color: Colors.black, fontSize: 12),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     )
//                   : Row(),
//               Padding(
//                 padding: const EdgeInsets.only(top: 10, bottom: 10, left: 24, right: 24),
//                 child: Container(
//                   height: 45,
//                   width: 345,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(60), border: Border.all(color: ServiceAppColors.tela), color: ServiceAppColors.tela),
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       primary: Colors.yellow,
//                     ),
//                     onPressed: () {
//                       if (timeval != null && timeval.length > 0) {
//                         _addToproducts(context);
//                       } else {
//                         showLongToast("Please select the time slots");
//                       }

//                       // Navigator.push(context, MaterialPageRoute(builder: (context) =>BookScreen()));
//                       // UserFilterDemo("0")));
//                     },
//                     child: Text(
//                       'Continue Booking',
//                       style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget discription1(String Discription) {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16.0, top: 8.0),
//               child: Text(
//                 '${_parseHtmlString(Discription ?? "")}',
//                 overflow: TextOverflow.fade,
//                 style: new TextStyle(
//                   color: Colors.black,
//                   fontSize: 14.0,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _parseHtmlString(String htmlString) {
//     final document = parse(htmlString);
//     final String parsedString = parse(document.body.text).documentElement.text;

//     return parsedString;
//   }

//   int colorIndex = -1;

//   changeColor(int index) {
//     setState(() {
//       colorIndex = index;
//     });
//   }

//   String checkam_pm(dynamic value) {
//     print('${DateFormat("hh:mm a").format(DateFormat("hh:mm a").parseLoose(value.toString()))}');
//     var val1 = value.replaceAll(":", ".").toString().trim();
//     print(val1);
//     if (value < 12)
//       return "AM";
//     else {
//       return "PM";
//     }
//   }

//   String calDiscount(String byprice, String discount2) {
//     String returnStr;
//     double discount = 0.0;
//     returnStr = discount.toString();
//     double byprice1 = double.parse(byprice);
//     double discount1 = double.parse(discount2);

//     discount = (byprice1 - (byprice1 * discount1) / 100.0);

//     returnStr = discount.toStringAsFixed(ServiceAppConstant.val);
//     print(returnStr);
//     return returnStr;
//   }

//   final DbProductManager dbmanager = new DbProductManager();
//   ProductsCart products;

//   void _addToproducts(BuildContext context) {
//     if (products == null) {
//       print(widget.plist.img);
//       dbmanager.deleteallProducts();
//       String amount = calDiscount(widget.plist.buyPrice, widget.plist.discount);
//       ServiceAppConstant.totalAmount = double.parse(amount);
//       ProductsCart st = new ProductsCart(
//           pid: widget.plist.productIs,
//           pname: widget.plist.productName,
//           pimage: widget.plist.img,
//           pprice: calDiscount(widget.plist.buyPrice, widget.plist.discount),
//           pQuantity: 1,
//           pcolor: "",
//           psize: "",
//           pdiscription: widget.plist.productDescription,
//           sgst: "0",
//           cgst: "0",
//           discount: widget.plist.discount,
//           discountValue: "0",
//           adminper: widget.plist.msrp,
//           adminpricevalue: "",
//           costPrice: widget.plist.buyPrice,
//           shipping: widget.plist.shipping,
//           totalQuantity: widget.plist.quantityInStock,
//           varient: "",
//           mv: int.parse(widget.plist.mv));
//       dbmanager.insertStudent(st).then((id) => {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => CheckOutPage(dateval, timeval)),
//             ),
//             print('Student Added to Db ${id}')
//           });
//     }
//   }
// }
