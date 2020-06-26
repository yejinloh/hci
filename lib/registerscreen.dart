import 'package:flutter/material.dart';
import 'package:unique/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double screenHeight;
  bool _isChecked = false;
  String urlRegister = "http://yjjmappflutter.com/Unique/php/registerUser.php";
  TextEditingController _nameRegisterController = new TextEditingController();
  TextEditingController _emailRegisterController = new TextEditingController();
  TextEditingController _phoneRegisterController = new TextEditingController();
  TextEditingController _passwordRegisterController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.yellow,
      ),
      title: 'Cool Sun Application',
      home: Scaffold(
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
      height: screenHeight,
      width: screenHeight,
      child: Image.asset(
        'assets/images/register.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget secondHalf(BuildContext context) {
    return Container(
      height: 550,
      margin: EdgeInsets.only(top: screenHeight / 6.5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "User Register",
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
                      controller: _nameRegisterController,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.yellow[900],
                          fontWeight: FontWeight.w800,
                          fontFamily: "Roboto"),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
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
                      controller: _emailRegisterController,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16.0,
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
                      controller: _phoneRegisterController,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.yellow[900],
                          fontWeight: FontWeight.w800,
                          fontFamily: "Roboto"),
                      decoration: InputDecoration(
                        labelText: 'Phone Num (more than 5 charater)',
                        prefixIcon: Icon(Icons.phone),
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
                    controller: _passwordRegisterController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.yellow[900],
                        fontWeight: FontWeight.w800,
                        fontFamily: "Roboto"),
                    decoration: InputDecoration(
                      labelText: 'Password (more than 4 charater)',
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
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool value) {
                          _onChange(value);
                        },
                      ),
                      GestureDetector(
                        onTap: _showEULA,
                        child: Text('I Agree to Terms  ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Already register? ",
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
              GestureDetector(
                onTap: _loginScreen,
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget thirdHalf(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(145, 435, 50, 150),
      child: MaterialButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        minWidth: 125,
        height: 50,
        child: Text(
          'Register',
          style: TextStyle(fontSize: 18),
        ),
        color: Colors.red[900],
        textColor: Colors.white,
        elevation: 10,
        onPressed: _onRegister,
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

  void _onRegister() {
    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Register Confirmation"),
            content: new Container(
              height: 50,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: _showEULA,
                    child: Text('Do you confirm your registration information?',
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Yes"),
                onPressed: uploadData,
              ),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("EULA"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and yjjmappflutter This EULA agreement governs your acquisition and use of our Unique software (Software) directly from yjjmappflutter or indirectly through a yjjmappflutter authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the Unique software. It provides a license to use the Unique software and contains warranty information and liability disclaimers. If you register for a free trial of the Cool Sun software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the Unique software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by yjjmappflutter herewith regardless of whether other software is referred to or described herein. The terms also apply to any yjjmappflutter updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for Unique. yjjmappflutter shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of yjjmappflutter. yjjmappflutter reserves the right to grant licences to use the Software to third parties"
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void uploadData() {
    String name = _nameRegisterController.text;
    String email = _emailRegisterController.text;
    String password = _passwordRegisterController.text;
    String phone = _phoneRegisterController.text;

    if ((_isEmailValid(email)) && (password.length > 4) && (phone.length > 5)) {
      http.post(urlRegister, body: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
      }).then((res) {
        if (res.body == "success") {
          Navigator.of(context).pop();
          Navigator.pop(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()));
          Toast.show("Registration success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else {
          Toast.show("Registration failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      //Navigator.of(context).pop();
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}
