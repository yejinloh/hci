import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unique/tabbar.dart';
import 'package:unique/registerscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'dart:async';

void main() => runApp(LoginScreen());
bool rememberMe = false;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight;
  TextEditingController _emailLoginController = new TextEditingController();
  TextEditingController _passwordLoginController = new TextEditingController();
  String urlLogin = "http://yjjmappflutter.com/Unique/php/loginUser.php";
  @override
  void initState() {
    super.initState();
    print("Hello i'm in INITSTATE");
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: Colors.grey[300],
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              firstHalf(context),
              secondHalf(context),
              thirdHalf(context),
              titleName(),
            ],
          )),
    );
  }

  Widget firstHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      //width: screenHeight,
      child: Image.asset(
        'assets/images/login.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget secondHalf(BuildContext context) {
    return Container(
      height: 550,
      margin: EdgeInsets.only(top: screenHeight / 2.5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            //color: Colors.grey[300],
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "User Login",
                      style: TextStyle(
                        color: Colors.yellowAccent[700],
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        fontFamily: "Roboto",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                      controller: _emailLoginController,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.yellow[900],
                          fontWeight: FontWeight.w800,
                          fontFamily: "Roboto"),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                              color: Colors.black,
                              width: 3.0,
                              style: BorderStyle.solid),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _passwordLoginController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.yellow[900],
                        fontWeight: FontWeight.w800,
                        fontFamily: "Roboto"),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 3.0,
                            style: BorderStyle.solid),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: rememberMe,
                        onChanged: (bool value) {
                          _onRememberMe(value);
                        },
                      ),
                      Text('Remember Me',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        minWidth: 125,
        height: 50,
        child: Text(
          'Login',
          style: TextStyle(fontSize: 18),
        ),
        color: Colors.red[900],
        textColor: Colors.white,
        elevation: 10,
        onPressed: _userLogin,
      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 45,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Don't have an account? ",
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
              GestureDetector(
                onTap: _registerUser,
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          // SizedBox(
          //   height: 10,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Text("Forgot your password? ",
          //         style:
          //             TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
          //     GestureDetector(
          //       onTap: _forgotPassword,
          //       child: Text(
          //         "Reset Password",
          //         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }

  Widget thirdHalf(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(145, 500, 50, 130),
      child: MaterialButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        minWidth: 125,
        height: 50,
        child: Text(
          'Login',
          style: TextStyle(fontSize: 18),
        ),
        color: Colors.red[900],
        textColor: Colors.white,
        elevation: 10,
        onPressed: _userLogin,
      ),
    );
  }

  Widget titleName() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.shop,
            size: 40,
            color: Colors.indigo[900],
          ),
          Text(
            " Unique",
            style: TextStyle(
                fontSize: 36,
                color: Colors.indigo[900],
                fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }

  void _userLogin() async {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Log in...");
      pr.show();
      String _email = _emailLoginController.text;
      String _password = _passwordLoginController.text;
      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      })
          //.timeout(const Duration(seconds: 4))
          .then((res) {
        print(res.body);
        var string = res.body;
        List userdata = string.split(",");
        if (userdata[0] == "success") {
          User _user = new User(
            name: userdata[1],
            email: _email,
            password: _password,
            phone: userdata[3],
            credit: userdata[4],
            // datereg: userdata[5],
            // quantity: userdata[6]
          );
          //pr.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => TabBarPage(
                        user: _user,
                      )));
        } else {
          //pr.dismiss();
          Toast.show("Login failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        //pr.dismiss();
      });
    } on Exception catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  // void _forgotPassword() {
  //   TextEditingController phoneController = TextEditingController();
  //   // flutter defined function
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: new Text("Forgot Password?"),
  //         content: new Container(
  //           height: 100,
  //           child: Column(
  //             children: <Widget>[
  //               Text(
  //                 "Enter your recovery email",
  //               ),
  //               TextField(
  //                   decoration: InputDecoration(
  //                 labelText: 'Email',
  //                 icon: Icon(Icons.email),
  //               ))
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           // usually buttons at the bottom of the dialog
  //           new FlatButton(
  //             child: new Text("Yes"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               print(
  //                 _emailLoginController.text,
  //               );
  //             },
  //           ),
  //           new FlatButton(
  //             child: new Text("No"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _onRememberMe(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text("Exit")),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Cancel")),
            ],
          ),
        ) ??
        false;
  }

  void loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailLoginController.text = email;
        _passwordLoginController.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String email = _emailLoginController.text;
    String password = _passwordLoginController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      setState(() {
        _emailLoginController.text = '';
        _passwordLoginController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
