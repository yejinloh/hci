import 'package:unique/paymenthistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unique/user.dart';
import 'package:unique/mainscreen.dart';
import 'package:unique/cartscreen.dart';
import 'package:unique/profilescreen.dart';

void main() => runApp(TabBarPage());

class TabBarPage extends StatefulWidget {
  final User user;

  const TabBarPage({Key key,this.user}) : super(key: key);
  _TabBarState createState() => _TabBarState();
}

class _TabBarState extends State<TabBarPage> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      MainScreen(user: widget.user),
      CartScreen(user: widget.user),
      PaymentHistoryScreen(user: widget.user),
      ProfileScreen(user: widget.user), 
    ];
  }

  //String $pagetitle = "My Helper";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue[900]));
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Products"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, ),
            title: Text("Cart"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment, ),
            title: Text("History"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, ),
            title: Text("Profile"),
           )
        ],
      ),
    );
  }
}
