import 'dart:convert';
import 'package:unique/order.dart';
import 'package:unique/orderdetailscreen.dart';
import 'package:http/http.dart' as http;
import 'package:unique/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() => runApp(PaymentHistoryScreen());

class PaymentHistoryScreen extends StatefulWidget {
  final User user;

  const PaymentHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List paymentdata;
  double screenHeight, screenWidth;
  String titlecenter = "Loading your cart...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;

  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.yellow[100],
          appBar: AppBar(
            title: Text('Payment History'),
            backgroundColor: Colors.yellow[800],
          ),
          body: Center(
            child: Column(children: <Widget>[
              Text(
                "Payment History",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              paymentdata == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                              child: Text(
                      titlecenter,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ))))
                  : Expanded(
                      child: ListView.builder(
                          //Step 6: Count the data
                          itemCount:
                              paymentdata == null ? 0 : paymentdata.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                                child: InkWell(
                                    onTap: () => loadOrderDetails(index),
                                    child: Card(
                                      elevation: 10,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                (index + 1).toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "RM ",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      paymentdata[index]
                                                          ['total'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ])),
                                          Expanded(
                                              flex: 5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Order ID:",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    paymentdata[index]
                                                        ['orderid'],
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    "Bill ID:",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    paymentdata[index]
                                                        ['billid'],
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              )),
                                          Expanded(
                                            child: Text(
                                              f.format(DateTime.parse(
                                                  paymentdata[index]['date'])),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            flex: 2,
                                          ),
                                        ],
                                      ),
                                    )));
                          }))
            ]),
          ),
        ));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?',
                style: TextStyle(
                  color: Colors.yellow[900],
                )),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text("Exit",
                      style: TextStyle(
                        color: Colors.yellow,
                      ))),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Cancel",
                      style: TextStyle(
                        color: Colors.yellow,
                      ))),
            ],
          ),
        ) ??
        false;
  }

  void _loadPaymentHistory() {
    String urlLoadJobs =
        "http://yjjmappflutter.com/Unique/php/loadPaymentHistory.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      //pr.dismiss();
      if (res.body == "nodata") {
        setState(() {
        paymentdata = null;
        titlecenter = "No Payment History";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadOrderDetails(int index) {
    Order order = new Order(
        billid: paymentdata[index]['billid'],
        orderid: paymentdata[index]['orderid'],
        total: paymentdata[index]['total'],
        dateorder: paymentdata[index]['date']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderDetailScreen(
                  order: order,
                )));
  }
}
