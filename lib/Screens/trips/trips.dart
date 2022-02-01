// import 'package:flutter/material.dart';
// import 'package:quicksewadriver/Screens/trips/components/dropoff_list.dart';
// import 'package:quicksewadriver/Screens/trips/components/pickup_list.dart';
// import 'package:quicksewadriver/widgets/buttons.dart';
// import 'package:quicksewadriver/widgets/constants.dart';

// class PickUpAndDropOff extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           leading: backArrowBtn(context: context),
//           title: appBarTitle(context: context, text: "QuickSewa Partner"),
//           centerTitle: true,
//           actions: [
//             IconButton(icon: Icon(Icons.help_outline_sharp), onPressed: () {})
//           ],
//           bottom: TabBar(
//             labelStyle: Theme.of(context)
//                 .textTheme
//                 .headline6
//                 .copyWith(fontWeight: FontWeight.bold),
//             tabs: [
//               Tab(
//                 text: "Today",
//               ),
//               Tab(
//                 text: "Yesterday",
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             PickUpList(),
//             DropOffList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
