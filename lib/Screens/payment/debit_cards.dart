import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class DebitCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpandablePanel(
        expanded: null,
        header: Text(
          "Debit Cards",
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.black),
        ),
        collapsed: Column(
          children: [
            CreditCardWidget(
              cardNumber: "4065811714495144",
              expiryDate: "01/2022",
              cardHolderName: "Chandralekha Unni",
              cvvCode: "602",
              showBackView: false,
              obscureCardNumber: true,
              obscureCardCvv: true,
              height: 175,
              labelCardHolder: " Sharukh K",
              textStyle: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
              width: MediaQuery.of(context).size.width,
              animationDuration: Duration(milliseconds: 1000),
              cardBgColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
