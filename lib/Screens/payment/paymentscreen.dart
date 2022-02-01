import 'package:flutter/material.dart';
import 'package:quicksewadriver/Screens/payment/credit_cards.dart';
import 'package:quicksewadriver/Screens/payment/debit_cards.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding( 
              padding: EdgeInsets.only(left: 12, bottom: 18, top: 20),
              child: Text(  
                'Payment Methods',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            ListTile(
              title: Text('Credits'),
              subtitle: Text('Balance 0'),
              trailing: ElevatedButton(
                onPressed: (){},
                child: Text(
                  'Add Cash',
                  style: TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  elevation: 0,
                ),
              )
            ),
            Divider(),
            ListTile(
              title: Text('PayTm Wallet'),
              subtitle: Text('New payment account will be created if you donnot have any',
              style: TextStyle(fontSize: 12),),
              trailing: ElevatedButton(
                onPressed: (){},
                child: Text(
                  'Link Wallet',
                  style: TextStyle(fontSize: 12),
                ), 
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  elevation: 0,
                ),
              )
            ),
            Divider(),
            ListTile(
              title: Text('UPI'),
              subtitle: Text('Link Your Payment UPI ',
              style: TextStyle(fontSize: 12),),
              trailing: ElevatedButton(
                onPressed: (){},
                child: Text(
                  'Link UPI',
                  style: TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  elevation: 0,
                ),
              )
            ),
            Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text('Your Cards',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.w500)),
                Divider(),
                SizedBox(
                  height: 30,
                ),
               DebitCards(),
                SizedBox(
                  height: 20,
                ),
                CreditCards(),
              ]),
        ),
          ]
        ),
      ),
    );
  }
}