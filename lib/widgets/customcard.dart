import 'package:flutter/material.dart';
import 'package:quicksewadriver/widgets/constants.dart';

CustomCard1(){
  return Padding(
    padding: const EdgeInsets.only(left:4.0,right:3.0,bottom: 5.0),
    child: Card(
                child: Container(
              
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'You have missed an order. If you continue to do so...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: primaryColor
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    )),
              ),
  );
}