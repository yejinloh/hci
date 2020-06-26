import 'dart:async';
import 'package:unique/tabbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:unique/user.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final String orderid, val;
  PaymentScreen({this.user, this.orderid, this.val});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
            backgroundColor: Colors.blueGrey[100],
            appBar: AppBar(
              title: Text('PAYMENT'),
              backgroundColor: Colors.blue[900],
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: WebView(
                    initialUrl:
                        'http://yjjmappflutter.com/Unique/php/payment.php?email=' +
                            widget.user.email +
                            '&mobile=' +
                            widget.user.phone +
                            '&name=' +
                            widget.user.name +
                            '&amount=' +
                            widget.val +
                            '&orderid=' +
                            widget.orderid,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                  ),
                )
              ],
            )));
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => TabBarPage(user: widget.user),
        ));
    return Future.value(false);
  }
}
