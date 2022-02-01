import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quicksewadriver/Screens/login/shared_pref.dart';
import 'package:quicksewadriver/services/shared.dart';
import 'package:quicksewadriver/services/url.dart';
import 'package:quicksewadriver/widgets/CustomElevatedButton.dart';
import 'package:quicksewadriver/widgets/CustomMessage.dart';
import 'package:http/http.dart' as http;
import 'package:quicksewadriver/widgets/CustomTextField.dart';
import 'package:quicksewadriver/widgets/customwallet.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  var loading = false;
  var rdate = "", amount = "";
  var length = 0;
  var pickLocation = "";
  var rDate = "";
  var totalAmount = "";
  var withdraw = "";
  var addAmount = '';
  var walletData = [];
  var userDetails = {};
  bool isApiCallInprogress = false;
  var userId, phoneNo;
  Razorpay pay;

  getWalletData() async {
    setState(() {
      loading = true;
    });
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(walletUrl), body: {
        'id': id,
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          setState(() {
            walletData = data['data'];
          });
        } else {}
      }

      response = await http.post(Uri.parse(profileVehicleUrl), body: {
        'id': id,
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          userDetails = data['data'][0];
          withdraw = (double.parse(userDetails['wallet_balance'].toString()) >
                      500
                  ? double.parse(userDetails['wallet_balance'].toString()) - 500
                  : 0)
              .toString();
          amount = userDetails['wallet_balance'].toString();
        } else {}
      }

      getRideHistory();
    } catch (e) {
      print(e);
    }
  }

  getRideHistory() async {
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(rideHistoryUrl), body: {
        'id': id,
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);

        if (data['status'] == 200) {
          pickLocation = data['data'][0]['pick_location'];
          rDate = data['data'][0]['rdate'];
          totalAmount = data['data'][0]['total_amount'];
        } else {}
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  withdrawRequest() async {
    TextEditingController _addAmount = TextEditingController();
    AlertDialog dialog = AlertDialog(
      title: Text(
        'Withdraw Amount',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            context: context,
            controller: _addAmount,
            labelText: 'Amount',
            keyboard: TextInputType.number,
          ),
          SizedBox(height: 20),
          CustomElevatedButton(
            context: context,
            buttonClicked: false,
            child: Text('Withdraw Request'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
    await showDialog(context: context, builder: (context) => dialog);
    if (_addAmount.text == '') {
      CustomMessage.toast('Please Enter Amount');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(withdrawRequestUrl), body: {
        'id': id,
        'amount': _addAmount.text,
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);
        CustomMessage.toast(data['message']);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  addmoney() async {
    try {
      var id = await SharedData().getUser();
      var response = await http.post(Uri.parse(addMoneyUrl), body: {
        'id': id,
        'amount': addAmount,
      });

      if (response.statusCode != 200) {
        CustomMessage.toast('Internal Server Error');
      } else if (response.body != '') {
        var data = jsonDecode(response.body);
        CustomMessage.toast(data['message']);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
    getWalletData();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (response != null) {
      addmoney();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CustomMessage.toast("Payment failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(
        'You have chosen to pay via : ${response.walletName}. It will take some time to reflect your payment.');
  }

  void openCheckOut(var cost) async {
    TextEditingController _addAmount = TextEditingController();
    AlertDialog dialog = AlertDialog(
      title: Text(
        'Add Amount',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            context: context,
            controller: _addAmount,
            labelText: 'Amount',
            keyboard: TextInputType.number,
          ),
          SizedBox(height: 20),
          CustomElevatedButton(
            context: context,
            buttonClicked: false,
            child: Text('Add Money'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
    await showDialog(context: context, builder: (context) => dialog);
    if (_addAmount.text == '') {
      CustomMessage.toast('Please Enter Amount');
      return;
    }
    addAmount = _addAmount.text;
    var options = {
      "key": "rzp_test_Fi1BvOwJJZomaI",
      "amount": (double.parse(_addAmount.text) * 100).toString(),
      "name": "Transport",
      "description": "Payment for add amount",
      "prefill": {
        "contact": phoneNo,
        "email": "",
      },
    };

    try {
      pay.open(options);
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    pay = Razorpay();
    pay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    pay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    pay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getWalletData();
  }

  @override
  void dispose() {
    pay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        elevation: 0,
        backgroundColor: Color(0xffF5F5F5),
        title: Text(
          'WALLET',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      body: (loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: height * 0.14,
                    width: width * 0.9999,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment(-1.0, 2.0),
                          end: Alignment(-1.0, -2.0),
                          colors: [Color(0xFF6D5DF6), Color(0xFF83B9FF)]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    child: Text(
                                  'Balance',
                                  style: TextStyle(color: Colors.white),
                                )),
                                Container(
                                    child: Text(
                                  amount,
                                  style: TextStyle(color: Colors.white),
                                )),
                                Container(
                                  height: height * 0.04,
                                  width: width * 0.35,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xff706BF7)),
                                  child: FlatButton(
                                    onPressed: () {
                                      withdrawRequest();
                                    },
                                    child: Center(
                                      child: Text(
                                        'Withdraw ₹' +
                                            double.parse(withdraw == ''
                                                    ? '0'
                                                    : withdraw)
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 8.0),
                              //   child: Container(
                              //       child: Text(
                              //     'Minimum Balance',
                              //     style: TextStyle(color: Colors.white),
                              //   )),
                              // ),
                              // Container(
                              //     child: Text(
                              //   '₹ 500',
                              //   style: TextStyle(color: Colors.white),
                              // )),
                              Container(
                                height: height * 0.04,
                                width: width * 0.35,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xff706BF7)),
                                child: TextButton(
                                  onPressed: () {
                                    openCheckOut(amount);
                                  },
                                  child: Center(
                                    child: Text(
                                      'Recharge',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: height * 0.70,
                      child: ListView.builder(
                          itemCount: walletData.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    child: CustomWallet(
                                      walletData[index]['amount'].toString(),
                                      walletData[index]['rdate'].toString(),
                                      (walletData[index]['pay_type'] ??
                                              'Ride Payment')
                                          .toString(),
                                      height,
                                      walletData[index]['commission']
                                          .toString(),
                                    ),
                                  ),
                                ),
                                Divider()
                              ],
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
