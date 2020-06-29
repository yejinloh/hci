import 'dart:async';
import 'dart:convert';
import 'package:unique/payment.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:unique/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

void main() => runApp(CartScreen());

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key key, this.user}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartData;
  double screenHeight, screenWidth;
  String titlecenter = "Loading your cart...";
  String curaddress;
  String server = "https://yjjmappflutter.com/Unique";
  double _totalprice = 0.0;
  Position _currentPosition;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController gmcontroller;
  CameraPosition _home;
  MarkerId markerId1 = MarkerId("12");
  Set<Marker> markers = Set();
  double latitude, longitude;
  String label;
  CameraPosition _userpos;
  double deliverycharge;
  double amountpayable;

  @override
  void initState() {
    super.initState();
    _getLocation();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('My Cart'),
            backgroundColor: Colors.blue[800],
          ),
          body: Container(
              child: Column(
            children: <Widget>[
              Text(
                "Content of my Cart",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              cartData == null
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
                          itemCount: cartData == null ? 1 : cartData.length + 2,
                          itemBuilder: (context, index) {
                            if (index == cartData.length) {
                              return Container(
                                  height: screenHeight / 3.5,
                                  width: screenWidth / 2.5,
                                  child: InkWell(
                                    //onLongPress: () => {print("Delete")},
                                    child: Card(
                                      //color: Colors.yellow,
                                      elevation: 5,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text("Delivery Option",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Home Delivery",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text("Current Address:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                          Row(
                                            children: <Widget>[
                                              Text("  "),
                                              Flexible(
                                                child: Text(
                                                  curaddress ??
                                                      "Address not set",
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          FlatButton(
                                            color: Colors.blue[700],
                                            onPressed: () => {_loadMapDialog()},
                                            child: Icon(
                                              MdiIcons.locationEnter,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            }

                            if (index == cartData.length + 1) {
                              return Container(
                                  //height: screenHeight / 3,
                                  child: Card(
                                elevation: 5,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Payment",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    SizedBox(height: 10),
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(50, 0, 50, 0),
                                        //color: Colors.red,
                                        child: Table(
                                            defaultColumnWidth:
                                                FlexColumnWidth(1.0),
                                            columnWidths: {
                                              0: FlexColumnWidth(7),
                                              1: FlexColumnWidth(3),
                                            },
                                            //border: TableBorder.all(color: Colors.black),
                                            children: [
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 20,
                                                      child: Text(
                                                          "Total Item Price ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black))),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                        "RM" +
                                                                _totalprice
                                                                    .toStringAsFixed(
                                                                        2) ??
                                                            "0.0",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 20,
                                                      child: Text(
                                                          "Delivery Charge ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black))),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                        "RM" +
                                                                deliverycharge
                                                                    .toStringAsFixed(
                                                                        2) ??
                                                            "0.0",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 20,
                                                      child: Text(
                                                          "Total Amount ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black))),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                        "RM" +
                                                                amountpayable
                                                                    .toStringAsFixed(
                                                                        2) ??
                                                            "0.0",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ),
                                              ]),
                                            ])),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ));
                            }

                            index -= 0;

                            return Card(
                                elevation: 10,
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              height: screenHeight / 8,
                                              width: screenWidth / 5,
                                              child: ClipOval(
                                                  child: CachedNetworkImage(
                                                fit: BoxFit.scaleDown,
                                                imageUrl: server +
                                                    "/productimages/${cartData[index]['code']}.jpg",
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
                                              )),
                                            ),
                                            Text(
                                              "RM " + cartData[index]['price'],
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                5, 1, 10, 1),
                                            child: SizedBox(
                                                width: 2,
                                                child: Container(
                                                  height: screenWidth / 3.5,
                                                  color: Colors.grey,
                                                ))),
                                        Container(
                                            width: screenWidth / 1.8,
                                            child: Row(
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        cartData[index]['name'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors
                                                                .blue[900]),
                                                        maxLines: 1,
                                                      ),
                                                      Text(
                                                        "Available " +
                                                            cartData[index]
                                                                ['quantity'] +
                                                            " unit",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Your Quantity " +
                                                            cartData[index]
                                                                ['cquantity'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Container(
                                                          height: 20,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    {
                                                                  _updateCart(
                                                                      index,
                                                                      "add")
                                                                },
                                                                child: Icon(
                                                                  MdiIcons.plus,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                              Text(
                                                                cartData[index][
                                                                    'cquantity'],
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    {
                                                                  _updateCart(
                                                                      index,
                                                                      "remove")
                                                                },
                                                                child: Icon(
                                                                  MdiIcons
                                                                      .minus,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                              "Total RM " +
                                                                  cartData[index]
                                                                      [
                                                                      'yourprice'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                5, 1, 10, 1),
                                            child: SizedBox(
                                                width: 2,
                                                child: Container(
                                                  height: screenWidth / 3.5,
                                                  color: Colors.grey,
                                                ))),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              FlatButton(
                                                onPressed: () =>
                                                    {_deleteCart(index)},
                                                child: Icon(
                                                  MdiIcons.delete,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )));
                          })),
            ],
          )),
          bottomNavigationBar: new Container(
              color: Colors.blueGrey[200],
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: new Text("Total Amount:"),
                      subtitle: new Text(
                        "RM" + amountpayable.toStringAsFixed(2) ?? "0.0",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue[900]),
                      ),
                    ),
                  ),
                  Expanded(
                      child: new MaterialButton(
                    onPressed: makePayment,
                    child: new Text("Check Out",
                        style: TextStyle(color: Colors.white)),
                    color: Colors.blue[900],
                  ))
                ],
              )),
        ));
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

  void _loadCart() {
    _totalprice = 0.0;
    amountpayable = 0.0;
    deliverycharge = 0.0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating cart...");
    pr.show();
    String urlLoadJobs = server + "/php/loadCart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "Cart Empty") {
        setState(() {
          cartData = null;
          titlecenter = "Cart Empty";
        });
      }
      setState(() {
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];
        for (int i = 0; i < cartData.length; i++) {
          _totalprice = double.parse(cartData[i]['yourprice']) + _totalprice;
          if (_totalprice > 100) {
            deliverycharge = 6.00;
          } else {
            deliverycharge = 12.00;
          }
          print("Dev Charge:" + deliverycharge.toStringAsFixed(3));
        }
        amountpayable = deliverycharge + _totalprice;
        print(_totalprice);
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
  }

  _updateCart(int index, String op) {
    int curquantity = int.parse(cartData[index]['quantity']);
    int quantity = int.parse(cartData[index]['cquantity']);
    if (op == "add") {
      quantity++;
      if (quantity > (curquantity - 2)) {
        Toast.show("Quantity not available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }
    String urlLoadJobs = server + "/php/updateCart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
      "prodcode": cartData[index]['code'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Cart Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadCart();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${_currentPosition.latitude}');
    final coordinates =
        new Coordinates(_currentPosition.latitude, _currentPosition.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });

    print("${first.featureName} : ${first.addressLine}");
  }

  _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${_currentPosition.latitude}');
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    newSetState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });

    print("${first.featureName} : ${first.addressLine}");
  }

  _loadMapDialog() {
    try {
      if (_currentPosition.latitude == null) {
        Toast.show("Location not available. Please wait...", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _getLocation(); //_getCurrentLocation();
        return;
      }
      _controller = Completer();
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.4746,
      );

      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: 'Delivery Location',
          )));

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text(
                  "Select New Delivery Location",
                  style: TextStyle(
                    color: Colors.blue[900],
                  ),
                ),
                titlePadding: EdgeInsets.all(5),
                //content: Text(curaddress),
                actions: <Widget>[
                  Text(
                    curaddress,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: screenHeight / 2 ?? 600,
                    width: screenWidth ?? 360,
                    child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _userpos,
                        markers: markers.toSet(),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        onTap: (newLatLng) {
                          _loadLoc(newLatLng, newSetState);
                        }),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    //minWidth: 200,
                    height: 30,
                    child: Text('Close'),
                    color: Colors.blue,
                    textColor: Colors.black,
                    elevation: 10,
                    onPressed: () =>
                        {markers.clear(), Navigator.of(context).pop(false)},
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      print("insetstate");
      markers.clear();
      latitude = loc.latitude;
      longitude = loc.longitude;
      _getLocationfromlatlng(latitude, longitude, newSetState);
      _home = CameraPosition(
        target: loc,
        zoom: 14,
      );
      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'New Location',
            snippet: 'New Delivery Location',
          )));
    });
    _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );
    _newhomeLocation();
  }

  Future<void> _newhomeLocation() async {
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_home));
    //Navigator.of(context).pop(false);
    //_loadMapDialog();
  }

  Future<void> makePayment() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyyhhmmss-');
    String orderid = widget.user.email.substring(0, 10) +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(8);
    print(orderid);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentScreen(
                  user: widget.user,
                  val: amountpayable.toStringAsFixed(2),
                  orderid: orderid,
                )));
    _loadCart();
  }

  void deleteAll() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete all items?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "/php/deleteCart.php", body: {
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete item?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "/php/deleteCart.php", body: {
                  "email": widget.user.email,
                  "prodcode": cartData[index]['code'],
                }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
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
      ),
    );
  }
}
