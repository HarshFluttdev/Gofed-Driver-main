// import 'package:flutter/material.dart';
// import 'package:quicksewadriver/Screens/bottomnavbar/googlemaps.dart';
// import 'package:quicksewadriver/widgets/constants.dart';
// import 'package:expandable/expandable.dart';

// class PickAndDropCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.all(defaultPadding),
//         child: Card(
//           elevation: 3.0,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           child: Padding(
//             padding: const EdgeInsets.all(defaultPadding),
//             child: ExpandablePanel(
//               collapsed: null,
//               theme: ExpandableThemeData(
//                   tapHeaderToExpand: true,
//                   tapBodyToCollapse: true,
//                   tapBodyToExpand: true,
//                   hasIcon: false),
//               header: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _richText(
//                           context: context, text1: "Order", text2: "2451654"),
//                       _richText(
//                           context: context, text1: "Time", text2: "9 : 30 AM")
//                     ],
//                   ),
//                   _richText(
//                       context: context,
//                       text1: "Address",
//                       text2: "8th Street, Financial center, Opp to"),
//                 ],
//               ),
//               expanded: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _richText(
//                       context: context,
//                       text1: "Contact Name",
//                       text2: "Mahmood sheikh"),
//                   _richText(
//                       context: context,
//                       text1: "Contact Number",
//                       text2: "+971 XXX XXX XXXX"),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _richText(
//                           context: context, text1: "Payment", text2: "Rs 5000"),
//                       _richText(
//                           context: context, text1: "Weight", text2: "7.5 Kg"),
//                     ],
//                   ),
//                   _richText(
//                       context: context, text1: "Payment mode", text2: "Cash"),
//                   Container(
//                     height: 250,
//                     margin: const EdgeInsets.all(defaultPadding),
//                     padding: const EdgeInsets.all(defaultPadding),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: labelColor,
//                           borderRadius: BorderRadius.circular(15)),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Scan",
//                         style: Theme.of(context).textTheme.headline6.copyWith(
//                             color: primaryColor, fontWeight: FontWeight.bold),
//                       ),
//                       IconButton(onPressed: (){
//                         Navigator.push(context, MaterialPageRoute(builder: (context)=>GoogleMaps()));
//                       }, icon: Icon(Icons.navigation_sharp),iconSize: 30,color: primaryColor,)
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }

// Widget _richText({BuildContext context, String text1 = "", String text2 = ""}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 4.0),
//     child: RichText(
//       maxLines: 3,
//       overflow: TextOverflow.ellipsis,
//       text: TextSpan(
//         text: "$text1 : ",
//         style:
//             Theme.of(context).textTheme.subtitle1.copyWith(color: labelColor),
//         children: <TextSpan>[
//           TextSpan(
//               text: "$text2", style: TextStyle(fontWeight: FontWeight.bold)),
//         ],
//       ),
//     ),
//   );
// }
