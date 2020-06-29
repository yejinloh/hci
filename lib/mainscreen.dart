import 'dart:async';
import 'dart:convert';
import 'package:unique/product.dart';
import 'package:flutter/material.dart';
import 'package:unique/user.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainScreen extends StatefulWidget {
  final Product product;
  final User user;

  const MainScreen({Key key, this.product, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String server = "http://yjjmappflutter.com/Unique";
  List productdata;
  double screenHeight, screenWidth;
  bool _visible = false;
  int curnumber = 1;
  String curr = "All";
  String titlecenter = "Loading products...";
  int quantity = 1;
  String cartquantity = "0";
  String size = "S";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = new TextEditingController();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text('Products List'),
            backgroundColor: Colors.blue[800],
            actions: <Widget>[
              IconButton(
                color: Colors.white,
                icon:
                    _visible ? new Icon(Icons.search) : new Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    if (_visible) {
                      _visible = false;
                    } else {
                      _visible = true;
                    }
                  });
                },
              ),
            ],
          ),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                    visible: _visible,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Flexible(
                              child: Container(
                            color: Colors.white,
                            height: 30,
                            child: TextField(
                                autofocus: false,
                                controller: _searchController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.search),
                                    border: OutlineInputBorder())),
                          )),
                          Flexible(
                              child: MaterialButton(
                                  color: Colors.blue[900],
                                  onPressed: () => {
                                        _searchItembyName(
                                            _searchController.text)
                                      },
                                  elevation: 5,
                                  child: Text(
                                    "Search Product",
                                    style: TextStyle(color: Colors.white),
                                  )))
                        ],
                      ),
                    )),
                Visibility(
                    visible: _visible,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Card(
                            color: Colors.grey[200],
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                          width: 50,
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    "Type",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                  SizedBox(
                                                width: 5,
                                              ),
                                  Column(
                                    children: <Widget>[
                                      FlatButton(
                                                  onPressed: () =>
                                                      _sortItem("All"),
                                                  color: Colors.blue[700],
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Icon(
                                                        MdiIcons.update,
                                                        color: Colors.black,
                                                      ),
                                                      Text(
                                                        "All",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  )),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      FlatButton(
                                          onPressed: () => _sortItem("Clothes"),
                                          color: Colors.blue[700],
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Image.asset(
                                                'assets/images/clothes.png',
                                                width: 50,
                                                height: 25,
                                              ),
                                              Text(
                                                "Clothes",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      FlatButton(
                                          onPressed: () => _sortItem("Pants"),
                                          color: Colors.blue[700],
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Image.asset(
                                                'assets/images/pants.png',
                                                width: 50,
                                                height: 25,
                                              ),
                                              Text(
                                                "Pants",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      FlatButton(
                                          onPressed: () => _sortItem("Dress"),
                                          color: Colors.blue[700],
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Image.asset(
                                                'assets/images/dress.png',
                                                width: 50,
                                                height: 25,
                                              ),
                                              Text(
                                                "Dress",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      FlatButton(
                                          onPressed: () => _sortItem("Other"),
                                          color: Colors.blue[700],
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                MdiIcons.more,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                "Others",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                Container(
                  //width: 50,
                  height: 30,
                  //color: Colors.blue[100],
                  child: Center(
                    child: Text(curr,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                ),
                productdata == null
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
                    : Flexible(
                        child: GridView.count(
                            crossAxisCount: 1,
                            childAspectRatio:
                                (screenWidth / screenHeight) / 0.5,
                            children:
                                List.generate(productdata.length, (index) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  //margin: EdgeInsets.all(5),
                                  elevation: 10,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: <Widget>[
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () =>
                                                    _onImageDisplay(index),
                                                child: Container(
                                                    height: screenWidth / 1.8,
                                                    width: screenWidth / 2.5,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        shape:
                                                            BoxShape.rectangle,
                                                        border: Border.all(
                                                            color: Colors
                                                                .lightBlue),
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: NetworkImage(
                                                                "http://yjjmappflutter.com/Unique/productimages/${productdata[index]['code']}.jpg")))),
                                              ),
                                            ]),
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: screenWidth / 2.5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                productdata[index]['name'],
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                "Brand: " +
                                                    productdata[index]['brand'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Type: " +
                                                    productdata[index]['type'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Color: " +
                                                    productdata[index]['color'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Size: " +
                                                    productdata[index]['size'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Quantity: " +
                                                    productdata[index]
                                                        ['quantity'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Price: RM " +
                                                    productdata[index]['price'],
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                height: 50,
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      MdiIcons.cart,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      " Add to cart",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                                color: Colors.blue[900],
                                                textColor: Colors.white,
                                                elevation: 5,
                                                onPressed: () =>
                                                    _addCart(index),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            })))
              ],
            ),
          ),
        ));
  }

  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: new Container(
          height: screenWidth / 1.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: screenWidth / 1.2,
                  width: screenWidth / 1.5,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "http://yjjmappflutter.com/Unique/productimages/${productdata[index]['code']}.jpg")))),
            ],
          ),
        ));
      },
    );
  }

  void _loadData() {
    String urlLoadJobs = server + "/php/loadProducts.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        productdata = extractdata["products"];
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _sortItem(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/loadProducts.php";
      http.post(urlLoadJobs, body: {
        "type": type,
      }).then((res) {
        setState(() {
          curr = type;
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          FocusScope.of(context).requestFocus(new FocusNode());
        //  pr.dismiss();
        });
      }).catchError((err) {
        print(err);
       // pr.dismiss();
      });
     // pr.dismiss();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _searchItembyName(String productname) {
    try {
      print(productname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/loadProducts.php";
      http
          .post(urlLoadJobs, body: {
            "name": productname.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Product not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              //pr.dismiss();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              productdata = extractdata["products"];
              FocusScope.of(context).requestFocus(new FocusNode());
              curr = productname;
             // pr.dismiss();
            });
          })
          .catchError((err) {
           // pr.dismiss();
          });
    //  pr.dismiss();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?',
                style: TextStyle(
                  color: Colors.blue[900],
                )),
            content: new Text('Do you want to exit an App?'),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text("Exit",
                      style: TextStyle(
                        color: Colors.blue,
                      ))),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Cancel",
                      style: TextStyle(
                        color: Colors.blue,
                      ))),
            ],
          ),
        ) ??
        false;
  }

  void _addCart(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              return AlertDialog(
                title: new Text("Add to Cart?",
                    style: TextStyle(
                      color: Colors.blue[900],
                    )),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Select quantity of product",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () => {
                                newSetState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                  }
                                })
                              },
                              child: Icon(MdiIcons.minus, color: Colors.blue),
                            ),
                            Text(
                              quantity.toString(),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            FlatButton(
                              onPressed: () => {
                                newSetState(() {
                                  if (quantity <
                                      (int.parse(
                                          productdata[index]['quantity']))) {
                                    quantity++;
                                  } else {
                                    Toast.show(
                                        "Quantity not available", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  }
                                })
                              },
                              child: Icon(
                                MdiIcons.plus,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                actions: <Widget>[
                  MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        _addtoCart(index);
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      )),
                  MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      )),
                ],
              );
            },
          );
        });
  }

  void _addtoCart(index) {
    try {
      int cquantity = int.parse(productdata[index]["quantity"]);
      print(cquantity);
      print(productdata[index]["code"]);
      print(productdata[index]["size"]);
      print(widget.user.email);
      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Add to cart...");
        pr.show();
        String urlLoadJobs = server + "/php/insertCart.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "procode": productdata[index]["code"],
          "size": productdata[index]["size"],
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
         //   pr.dismiss();
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartquantity = respond[1];
            });
            Toast.show("Success add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
     //     pr.dismiss();
        }).catchError((err) {
          print(err);
        //  pr.dismiss();
        });
      //  pr.dismiss();
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
