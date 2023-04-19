import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:posbillingapp/list/cart.dart';
import 'package:posbillingapp/list/paymentlist.dart';
import 'package:posbillingapp/list/recalllist.dart';
import 'package:posbillingapp/payment/payment.dart';
import 'package:posbillingapp/printerlist.dart/orderlist.dart';
import 'package:posbillingapp/printerlist.dart/printdata.dart';
import 'package:posbillingapp/printformat.dart';
import 'package:posbillingapp/test.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Paymentmode extends StatefulWidget {
  List<Cartlist> selectedorders;
  var total;
  Paymentmode({this.selectedorders, this.total});
  @override
  _PaymentmodeState createState() => _PaymentmodeState();
}

class Category {
  String name;

  Category({
    this.name,
  });
}

// var arrayOfProduct;
var arrayOfProduct;
List<Cartlist> arrayOfProduct1 = [];
List<Printerlist> df = [];
// var arrayOfProduct1;
List paybuttons = ['Credit', 'Debit', 'Cash', 'Split', 'Pay', 'Pay self'];
List countbuttons = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
int selectdiscountmode = 0;

class _PaymentmodeState extends State<Paymentmode> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidateMode = AutovalidateMode.disabled;

  var _card = new PaymentCard();
  bool changecolor = false;
  String showsubtotal;
  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
    totalamount();
    output = widget.total.toString();
    showsubtotal = widget.total.toString();
    initSavetoPath();
    // testPrint = TestPrint();
  }

  List<Order> orlst = [];
  var orderlist;
  TestPrint testPrint;
  printdata() {
    for (int i = 0; i < widget.selectedorders.length; i++) {
      orderlist = Order(
        ordername: widget.selectedorders[i].name,
        amount: '45',
        qty: widget.selectedorders[i].qty.toString(),
        price: widget.selectedorders[i].price.toString(),
      );
      orlst.add(orderlist);
      print(orlst);
      plist = new Printerlist(
        header: 'CMOON STORE',
        order: orlst,
        address: '23 kamal panckula',
        orderdatetime: DateTime.now(),
        billno: '23',
        gst: '12.0',
        subtotal: '300',
        total: '340',
        amountpaid: '160',
        paymentstatus: paybuttons[i],
        logo: pathImage,
        phoneno: '9887677566',
        thankyouCard: 'Thank you',
        barcode: 'UI',
      );
      df.add(plist);
      print(plist);
    }
  }

  initSavetoPath() async {
    //read and writeassest/chileslogo.jpeg
    //image max 300px X 300pxassest/foglogo.jpeg
    final filename = 'foglogo.jpeg';
    var bytes = await rootBundle.load("assest/foglogo.jpeg");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
    });
    //  printdata();
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  var datad;
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  int percentageDiscountValue = 0;
  int typeDiscountValue = 0;
  int selecteDiscountColor = 0;
  String discountvalue = '0';
  double percent = 0;
  double discountprice = 0;
  TextEditingController num1controller = new TextEditingController();
  TextEditingController num2controller = new TextEditingController();
  TextEditingController totaldiscount = new TextEditingController();
  String resulttext = "0";
  double totalvalue;
  double withDiscountvalue;
  double changevalue;
  double totaldollarvalue = 0;
  double selectedvalue = 0;
  List<Paymentlistlist> paymentdetails = [];
  var orderpayment;
  var recallset;
  List value = [];
  totalamount() {
    setState(() {
      // num1controller = new TextEditingController(text: widget.total.toString());
      totalvalue = widget.total;
    });
    print(totalvalue);
  }

  withDiscount() {
    discountprice = totalvalue - double.parse(output);
    discountprice = double.parse(output);
    setState(() {
      withDiscountvalue = totalvalue - discountprice;
    });
    totalvalue = withDiscountvalue;
    print(totalvalue);
  }

  withPercentageDiscount() {
    discountprice = (totalvalue * double.parse(output)) / 100;
    setState(() {
      totalvalue = totalvalue - discountprice;
    });
    // totalvalue = withDiscountvalue;
    print(totalvalue);
  }

  // calculatevalue() {
  //   setState(() {
  //     output = (totalvalue - discountprice).toString();
  //   });
  //   print(output);
  // }
  var list = [];

  String output = "0";

  String _out = "0";
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";
  buttonPressed(String btnVal) {
    print(btnVal);
    if (btnVal == "C" || btnVal == "D") {
      _out = "0";
      num1 = 0.0;
      num2 = 0.0;
      operand = "";
    } else if (btnVal == "+" ||
        btnVal == "-" ||
        btnVal == "*" ||
        btnVal == "/") {
      num1 = double.parse(output);
      operand = btnVal;
      _out = "0";
      output = output + btnVal;
    } else if (btnVal == ".") {
      if (_out.contains(".")) {
        print("Already exist");
        return;
      } else {
        _out = _out + btnVal;
      }
      num2 = double.parse(output);
      if (operand == "+") {
        _out = (num2 + num1).toString();
      }
      if (operand == "-") {
        _out = (num1 - num2).toString();
      }
      if (operand == "*") {
        _out = (num2 * num1).toString();
      }
      if (operand == "/") {
        _out = (num1 / num2).toString();
      }
      num1 = 0.0;
      num2 = 0.0;
      //_out = "0";
    } else {
      _out = _out + btnVal;
    }

    setState(() {
      output = double.parse(_out).toStringAsFixed(2);
    });
  }

  // dialogbox() {
  //   return showDialog(
  //       context: context,
  //       // barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return SingleChildScrollView(
  //             child: AlertDialog(
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.all(Radius.circular(23.0))),
  //                 title: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.stretch,
  //                   children: [
  //                     Padding(
  //                         padding: EdgeInsets.only(bottom: 20),
  //                         child: Container(
  //                             height: 100,
  //                             width: 420,
  //                             decoration: BoxDecoration(
  //                                 color: Color(0xFF1f1338),
  //                                 borderRadius: BorderRadius.circular(8)),
  //                             child: Row(
  //                               children: [
  //                                 Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Padding(
  //                                         padding: EdgeInsets.only(
  //                                             left: 20, top: 25),
  //                                         child: Text(
  //                                           '\u20B9345',
  //                                           style: TextStyle(
  //                                               fontSize: 22,
  //                                               color: Colors.white),
  //                                         )),
  //                                     Padding(
  //                                         padding:
  //                                             EdgeInsets.only(left: 20, top: 2),
  //                                         child: Text(
  //                                           'Total amount with Discount',
  //                                           style: TextStyle(
  //                                               fontSize: 18,
  //                                               color: Colors.white),
  //                                         ))
  //                                   ],
  //                                 ),
  //                                 SizedBox(
  //                                   width: 50,
  //                                 ),
  //                                 Padding(
  //                                     padding: EdgeInsets.only(top: 10),
  //                                     child: Text(
  //                                       'CREDIT CARD',
  //                                       style: TextStyle(
  //                                           fontSize: 15, color: Colors.white),
  //                                     ))
  //                               ],
  //                             ))),
  //                     new Container(
  //                       height: 440,
  //                       width: 380,
  //                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
  //                       child: new Form(
  //                           key: _formKey,
  //                           autovalidateMode: _autoValidateMode,
  //                           child: new ListView(
  //                             children: <Widget>[
  //                               new SizedBox(
  //                                 height: 20.0,
  //                               ),
  //                               new TextFormField(
  //                                 decoration: const InputDecoration(
  //                                   border: const UnderlineInputBorder(),
  //                                   filled: true,
  //                                   icon: const Icon(
  //                                     Icons.person,
  //                                     size: 40.0,
  //                                   ),
  //                                   hintText: 'What name is written on card?',
  //                                   labelText: 'Card Name',
  //                                 ),
  //                                 onSaved: (String? value) {
  //                                   _card.name = value;
  //                                 },
  //                                 keyboardType: TextInputType.text,
  //                                 validator: (String? value) =>
  //                                     value!.isEmpty ? Strings.fieldReq : null,
  //                               ),
  //                               new SizedBox(
  //                                 height: 30.0,
  //                               ),
  //                               new TextFormField(
  //                                 keyboardType: TextInputType.number,
  //                                 inputFormatters: [
  //                                   FilteringTextInputFormatter.digitsOnly,
  //                                   new LengthLimitingTextInputFormatter(19),
  //                                   new CardNumberInputFormatter()
  //                                 ],
  //                                 controller: numberController,
  //                                 decoration: new InputDecoration(
  //                                   border: const UnderlineInputBorder(),
  //                                   filled: true,
  //                                   icon: CardUtils.getCardIcon(
  //                                       _paymentCard.type),
  //                                   hintText: 'What number is written on card?',
  //                                   labelText: 'Number',
  //                                 ),
  //                                 onSaved: (String? value) {
  //                                   print('onSaved = $value');
  //                                   print(
  //                                       'Num controller has = ${numberController.text}');
  //                                   _paymentCard.number =
  //                                       CardUtils.getCleanedNumber(value!);
  //                                 },
  //                                 validator: CardUtils.validateCardNum,
  //                               ),
  //                               new SizedBox(
  //                                 height: 30.0,
  //                               ),
  //                               new TextFormField(
  //                                 inputFormatters: [
  //                                   FilteringTextInputFormatter.digitsOnly,
  //                                   new LengthLimitingTextInputFormatter(4),
  //                                 ],
  //                                 decoration: new InputDecoration(
  //                                   border: const UnderlineInputBorder(),
  //                                   filled: true,
  //                                   icon: new Image.asset(
  //                                     'assest/visa.jpg',
  //                                     width: 40.0,
  //                                     color: Colors.grey[600],
  //                                   ),
  //                                   hintText: 'Number behind the card',
  //                                   labelText: 'CVV',
  //                                 ),
  //                                 validator: CardUtils.validateCVV,
  //                                 keyboardType: TextInputType.number,
  //                                 onSaved: (value) {
  //                                   _paymentCard.cvv = int.parse(value!);
  //                                 },
  //                               ),
  //                               new SizedBox(
  //                                 height: 30.0,
  //                               ),
  //                               new TextFormField(
  //                                 inputFormatters: [
  //                                   FilteringTextInputFormatter.digitsOnly,
  //                                   new LengthLimitingTextInputFormatter(4),
  //                                   new CardMonthInputFormatter()
  //                                 ],
  //                                 decoration: new InputDecoration(
  //                                   border: const UnderlineInputBorder(),
  //                                   filled: true,
  //                                   icon: new Image.asset(
  //                                     'assest/visa.jpg',
  //                                     width: 40.0,
  //                                     color: Colors.grey[600],
  //                                   ),
  //                                   hintText: 'MM/YY',
  //                                   labelText: 'Expiry Date',
  //                                 ),
  //                                 validator: CardUtils.validateDate,
  //                                 keyboardType: TextInputType.number,
  //                                 onSaved: (value) {
  //                                   List<int> expiryDate =
  //                                       CardUtils.getExpiryDate(value!);
  //                                   _paymentCard.month = expiryDate[0];
  //                                   _paymentCard.year = expiryDate[1];
  //                                 },
  //                               ),
  //                               SizedBox(
  //                                 height: 20.0,
  //                               ),
  //                               Container(
  //                                 height: 50,
  //                                 width: 250,
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(25.0),
  //                                 ),
  //                                 child: RaisedButton(
  //                                   color: Color(0xFF1f1338),
  //                                   onPressed: () {
  //                                     Navigator.pop(context);
  //                                     // Navigator.push(
  //                                     //     context,
  //                                     //     MaterialPageRoute(
  //                                     //         builder: (context) => Tester1()));
  //                                   },
  //                                   child: Text(
  //                                     'Done',
  //                                     style: TextStyle(
  //                                       fontSize: 22,
  //                                       color: Colors.white,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               // new Container(
  //                               //   alignment: Alignment.center,
  //                               //   child: _getPayButton(),
  //                               // )
  //                             ],
  //                           )),
  //                     ),
  //                   ],
  //                 )
  //                 // content:
  //                 ));
  //       });
  // }
  Widget buildButton2(String dc) {
    return new Expanded(
        child: Container(
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: MaterialButton(
        padding: EdgeInsets.all(20.0),
        child: Text(
          dc,
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
        onPressed: () {
          buttonPressed(dc);
        },
      ),
    ));
  }

  Widget deleteAmount(String deletevalue) {
    return buttonPressed(deletevalue);
  }

  Widget buildButton1(String buttonVal) {
    return new Expanded(
        child: Container(
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        // boxShadow: [
        //   BoxShadow(
        //       color: Colors.grey,
        //       offset: Offset(2.0, 2.0),
        //       blurRadius: 8.0,
        //       spreadRadius: 1.0),
        //   BoxShadow(
        //       color: Colors.white,
        //       offset: Offset(-2.0, -2.0),
        //       blurRadius: 8.0,
        //       spreadRadius: 1.0),
        // ],
      ),
      child: MaterialButton(
        padding: EdgeInsets.all(20.0),
        child: Text(
          buttonVal,
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
        onPressed: () {
          buttonPressed(buttonVal);
        },
      ),
    ));
  }

  Widget buildButton(String buttonVal) {
    return new Expanded(
        child: Container(
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        // boxShadow: [
        //   BoxShadow(
        //       color: Colors.grey,
        //       offset: Offset(2.0, 2.0),
        //       blurRadius: 8.0,
        //       spreadRadius: 1.0),
        //   BoxShadow(
        //       color: Colors.white,
        //       offset: Offset(-2.0, -2.0),
        //       blurRadius: 8.0,
        //       spreadRadius: 1.0),
        // ],
      ),
      child: MaterialButton(
        padding: EdgeInsets.all(20.0),
        child: Text(
          buttonVal,
          style: TextStyle(fontSize: 22.0),
        ),
        onPressed: () => buttonPressed(buttonVal),
      ),
    ));
  }

  paymentcolors(Paymentlistlist data) {
    if (data.paymentmode == 'Cash') {
      return Icon(
        Icons.circle,
        color: Colors.red,
      );
    } else if (data.paymentmode == 'Credit') {
      return Icon(
        Icons.circle,
        color: Colors.green,
      );
    } else if (data.paymentmode == 'Debit') {
      return Icon(
        Icons.circle,
        color: Colors.blue,
      );
    } else if (data.paymentmode == 'Split') {
      return Icon(
        Icons.circle,
        color: Colors.purple,
      );
    }
  }

  var modifierlist;
  double changeamount;
  // displayselectvalue() {
  //   return showDialog(
  //       context: context,
  //       builder: (_) => new AlertDialog(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //             content: Builder(
  //               builder: (context) {
  //                 // Get available height and width of the build area of this widget. Make a choice depending on the size.
  //                 var height = MediaQuery.of(context).size.height;
  //                 var width = MediaQuery.of(context).size.width;

  //                 return Container(
  //                   height: height - 600,
  //                   width: width - 600,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Center(
  //                         child: Text(
  //                           'Discount',
  //                           style: TextStyle(
  //                               fontSize: 20,
  //                               color: Colors.black,
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //                       TextField(
  //                         keyboardType: TextInputType.number,
  //                         autofocus: true,
  //                         controller: totaldiscount,
  //                         decoration:
  //                             InputDecoration(hintText: "Type Discount"),
  //                       ),
  //                       RaisedButton(
  //                         onPressed: () {
  //                           discountprice = (totalvalue *
  //                                   double.parse(totaldiscount.text)) /
  //                               100;
  //                           Navigator.pop(context);
  //                           totaldiscount.clear();
  //                           calculatevalue();
  //                         },
  //                         child: Text('SUBMIT'),
  //                       )
  //                     ],
  //                   ),
  //                 );
  //               },
  //             ),
  //           ));
  // }
  void nodataAlert(context, double amount) {
    // Reusable alert style
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.red,
        ),
        constraints: BoxConstraints.expand(width: 300),
        //First to chars "55" represents transparency of color
        overlayColor: Color(0x55000000),
        alertElevation: 0,
        alertAlignment: Alignment.topCenter);

    // Alert dialog using custom alert style
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.success,
      title: "Order placed",
      desc: amount == 0
          ? "Payment Successfull!"
          : "${'Payment Successfull\nChange amount : ' + "\$${amount.toString()}"}",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            widget.selectedorders.clear();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => Firebasedata(
                          recalldata: recalllist,
                        )),
                (route) => false);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;
  List<Recalllist> recalllist = [];
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      print('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(_device).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() async {
            _connected = true;

            final pref = await SharedPreferences.getInstance();
            final key = 'printer';
            final value = _device.name.toString();
            pref.setString(key, value);
            final key1 = 'connected';
            final value1 = _connected;
            pref.setBool(key1, value1);
          });
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = true);
  }

  var plist;
  Future<void> initPlatformState() async {
    bool isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          title: Text(
            'Payment',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Row(
              children: <Widget>[
                Text(
                  'Device:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.amber),
                ),
                SizedBox(
                  width: 30,
                ),
                DropdownButton(
                  items: _getDeviceItems(),
                  onChanged: (value) => setState(() => _device = value),
                  value: _device,
                ),
                RaisedButton(
                  color: Colors.brown,
                  onPressed: () {
                    initPlatformState();
                  },
                  child: Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: _connected ? Colors.red : Colors.green,
                  onPressed: _connected ? _disconnect : _connect,
                  child: Text(
                    _connected ? 'Disconnect' : 'Connect',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height * 1,
                child: Row(
                  children: [
                    Expanded(
                        flex: 22,
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              right: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                    flex: 10,
                                    child: Container(
                                      color: Color(0xFF1f1338),
                                      child: Center(
                                          child: Text(
                                        'Selected Orders',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )),
                                    )),
                                Expanded(
                                    flex: 90,
                                    child: Container(
                                      child: ListView.builder(
                                          itemCount:
                                              widget.selectedorders.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            List selectedcartlist =
                                                widget.selectedorders;
                                            print(selectedcartlist);
                                            return Card(
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        // width: 200,
                                                        height: 50,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              selectedcartlist[
                                                                      index]
                                                                  .qty
                                                                  .toString(),
                                                              // "$_count",
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              selectedcartlist[
                                                                      index]
                                                                  .name,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 17),
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                          selectedcartlist[
                                                                  index]
                                                              .price
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ))
                              ],
                            ))),
                    Expanded(
                        flex: 78,
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 23,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    )),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 32,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                  right: BorderSide(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                  ),
                                                )),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5,
                                                                left: 5,
                                                                top: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                'Total',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        26,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Container(
                                                                child:
                                                                    totalvalue >
                                                                            0
                                                                        ? Text(
                                                                            '${'\$' + (totalvalue).toString()}',
                                                                            //  '${'\$' + (totalvalue - discountprice).toString()}',
                                                                            // '${"\$" + totalvalue - percent}',
                                                                            style: TextStyle(
                                                                                color: Colors.red,
                                                                                fontSize: 26,
                                                                                fontWeight: FontWeight.bold),
                                                                          )
                                                                        : Text(
                                                                            '0.0',
                                                                            style: TextStyle(
                                                                                color: Colors.red,
                                                                                fontSize: 26,
                                                                                fontWeight: FontWeight.bold),
                                                                          ))
                                                          ],
                                                        )),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5,
                                                                left: 5,
                                                                top: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                'Subtotal',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                '${'\$' + showsubtotal} ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5,
                                                                left: 5,
                                                                top: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                'Tax',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                totaldollarvalue
                                                                    .toString(),
                                                                //  '\$10',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5,
                                                                left: 5,
                                                                top: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                'Discount',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                '${"\$" + discountprice.toString()}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                  ],
                                                )
                                                //  Center(
                                                //     child: Row(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.spaceAround,
                                                //   children: [
                                                //     Column(
                                                //       mainAxisAlignment:
                                                //           MainAxisAlignment.center,
                                                //       children: [
                                                //         Text(
                                                //           '${"\$" + percent.toString()}',
                                                //           // '\u20B9345',
                                                //           style: TextStyle(
                                                //               fontSize: 20,
                                                //               fontWeight:
                                                //                   FontWeight.bold),
                                                //         ),
                                                //         SizedBox(
                                                //           height: 10,
                                                //         ),
                                                //         Container(
                                                //             height: 70.0,
                                                //             child: Align(
                                                //               alignment:
                                                //                   Alignment.center,
                                                //               child: Stack(
                                                //                 children: <Widget>[
                                                //                   Container(
                                                //                     height: 60,
                                                //                     width: 60,
                                                //                     child: Container(
                                                //                       margin:
                                                //                           EdgeInsets
                                                //                               .all(
                                                //                                   5.0),
                                                //                       decoration:
                                                //                           BoxDecoration(
                                                //                         color: Colors
                                                //                             .red,
                                                //                         borderRadius: BorderRadius.all(
                                                //                             Radius.elliptical(
                                                //                                 14.0,
                                                //                                 14.0)),
                                                //                       ),
                                                //                       child: Center(
                                                //                           child: Text(
                                                //                         ' ${discountvalue + '%'}',
                                                //                         style:
                                                //                             TextStyle(
                                                //                           fontSize:
                                                //                               18,
                                                //                           color: Colors
                                                //                               .white,
                                                //                         ),
                                                //                         textAlign:
                                                //                             TextAlign
                                                //                                 .center,
                                                //                       )),
                                                //                     ),
                                                //                   ),
                                                //                   Positioned(
                                                //                       right: 1.0,
                                                //                       top: -3.11,
                                                //                       child:
                                                //                           Container(
                                                //                         decoration: BoxDecoration(
                                                //                             color: Colors
                                                //                                 .yellow,
                                                //                             shape: BoxShape
                                                //                                 .circle),
                                                //                         height: 30,
                                                //                         child: Icon(
                                                //                           Icons.close,
                                                //                           color: Colors
                                                //                               .black,
                                                //                         ),
                                                //                       ))
                                                //                 ],
                                                //               ),
                                                //             ))
                                                //         // Stack(
                                                //         //   children: [
                                                //         //     Container(
                                                //         //       height: 40,
                                                //         //       width: 60,
                                                //         //       decoration: BoxDecoration(
                                                //         //           color: Colors.red,
                                                //         //           borderRadius:
                                                //         //               BorderRadius
                                                //         //                   .circular(
                                                //         //                       12)),
                                                //         //       child: Center(
                                                //         //           child: Text(
                                                //         //         ' ${discountvalue + '%'}',
                                                //         //         style: TextStyle(
                                                //         //           fontSize: 18,
                                                //         //           color: Colors.white,
                                                //         //         ),
                                                //         //         textAlign:
                                                //         //             TextAlign.center,
                                                //         //       )),
                                                //         //     ),
                                                //         //     Padding(
                                                //         //       padding:
                                                //         //           EdgeInsets.only(
                                                //         //               left: 40),
                                                //         //       child: CircleAvatar(
                                                //         //         maxRadius: 10,
                                                //         //         backgroundColor:
                                                //         //             Colors.white,
                                                //         //       ),
                                                //         //     ),
                                                //         //   ],
                                                //         // )
                                                //       ],
                                                //     ),
                                                //     VerticalDivider(
                                                //       color: Colors.grey,
                                                //     ),
                                                //     Column(
                                                //       mainAxisAlignment:
                                                //           MainAxisAlignment.center,
                                                //       children: [
                                                //         // TextFormField(
                                                //         //   textAlign: TextAlign.center,
                                                //         //   controller: num1controller,
                                                //         //   style: TextStyle(
                                                //         //       fontSize: 30,
                                                //         //       fontWeight:
                                                //         //           FontWeight.bold),
                                                //         // ),

                                                //         Text(
                                                //           '${"\$" + totalvalue.toString()}',
                                                //           // '\u20B9345',
                                                //           style: TextStyle(
                                                //               fontSize: 22,
                                                //               fontWeight:
                                                //                   FontWeight.bold),
                                                //         ),
                                                //         Text(
                                                //           'Total',
                                                //           style:
                                                //               TextStyle(fontSize: 20),
                                                //         ),
                                                //       ],
                                                //     ),
                                                //   ],
                                                // )),
                                                )),
                                        Expanded(
                                            flex: 68,
                                            child: Container(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Discount',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Center(
                                                        child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        RaisedButton(
                                                          color:
                                                              selecteDiscountColor ==
                                                                      0
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .amber,
                                                          onPressed: () {
                                                            setState(() {
                                                              selecteDiscountColor =
                                                                  1;
                                                              selectdiscountmode =
                                                                  1;
                                                            });
                                                          },
                                                          child: Text(
                                                            '\$',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  selecteDiscountColor ==
                                                                          0
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        RaisedButton(
                                                          color:
                                                              selecteDiscountColor ==
                                                                      1
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .amber,
                                                          onPressed: () {
                                                            setState(() {
                                                              selecteDiscountColor =
                                                                  0;
                                                              selectdiscountmode =
                                                                  0;
                                                            });
                                                          },
                                                          child: Text(
                                                            '%',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  selecteDiscountColor ==
                                                                          1
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    selectdiscountmode == 0
                                                        ? Expanded(
                                                            flex: 0,
                                                            child: Container(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  height: 50,
                                                                  width: 80,
                                                                  decoration: BoxDecoration(
                                                                      color: Color(
                                                                          0xFF1f1338),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child:
                                                                      FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        output =
                                                                            '10';
                                                                        // discountprice =
                                                                        //     (totalvalue * 10) /
                                                                        //         100;

                                                                        // discountvalue =
                                                                        //     '10';
                                                                      });
                                                                      withPercentageDiscount();
                                                                    },
                                                                    color: Colors
                                                                        .transparent,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            12.0),
                                                                    child: Text(
                                                                      '10%',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                  height: 50,
                                                                  width: 80,
                                                                  decoration: BoxDecoration(
                                                                      color: Color(
                                                                          0xFF1f1338),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child:
                                                                      FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        output =
                                                                            '20';
                                                                        // discountprice =
                                                                        //     (totalvalue * 20) /
                                                                        //         100;
                                                                        // // calculatevalue();

                                                                        // discountvalue =
                                                                        //     '20';
                                                                      });
                                                                      withPercentageDiscount();
                                                                    },
                                                                    color: Colors
                                                                        .transparent,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            12.0),
                                                                    child: Text(
                                                                      '20%',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                  height: 50,
                                                                  width: 80,
                                                                  decoration: BoxDecoration(
                                                                      color: Color(
                                                                          0xFF1f1338),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child:
                                                                      FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        output =
                                                                            '50';
                                                                        // discountprice =
                                                                        //     (totalvalue * 50) /
                                                                        //         100;
                                                                        // // calculatevalue();

                                                                        // discountvalue =
                                                                        //     '50';
                                                                      });
                                                                      withPercentageDiscount();
                                                                    },
                                                                    color: Colors
                                                                        .transparent,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            12.0),
                                                                    child: Text(
                                                                      '50%',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      // displayselectvalue();
                                                                      setState(
                                                                          () {
                                                                        percentageDiscountValue =
                                                                            1;
                                                                        typeDiscountValue =
                                                                            0;
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          50,
                                                                      width: 80,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .red,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8)),
                                                                      child:
                                                                          Text(
                                                                        '....',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 35),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    )),
                                                                // Container(
                                                                //     height: 50,
                                                                //     width: 80,
                                                                //     decoration: BoxDecoration(
                                                                //         color: Color(
                                                                //             0xFF1f1338),
                                                                //         borderRadius:
                                                                //             BorderRadius.circular(
                                                                //                 8)),
                                                                //     child:
                                                                //         RaisedButton(
                                                                //       color: Colors
                                                                //           .red,
                                                                //       onPressed:
                                                                //           () {
                                                                //         displayselectvalue();
                                                                //       },
                                                                //       child:
                                                                //           Text(
                                                                //         '....',
                                                                //         style: TextStyle(
                                                                //             color:
                                                                //                 Colors.white,
                                                                //             fontSize: 35),
                                                                //         textAlign:
                                                                //             TextAlign.center,
                                                                //       ),
                                                                //     )),
                                                              ],
                                                            )))
                                                        : Expanded(
                                                            flex: 0,
                                                            child: Container(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  height: 50,
                                                                  width: 80,
                                                                  decoration: BoxDecoration(
                                                                      color: Color(
                                                                          0xFF1f1338),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child:
                                                                      FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        output =
                                                                            '10';
                                                                        // discountprice =
                                                                        //     totalvalue -
                                                                        //         10;
                                                                        // discountprice =
                                                                        //     10;
                                                                      });
                                                                      withDiscount();
                                                                    },
                                                                    color: Colors
                                                                        .transparent,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            12.0),
                                                                    child: Text(
                                                                      '\$10',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                  height: 50,
                                                                  width: 80,
                                                                  decoration: BoxDecoration(
                                                                      color: Color(
                                                                          0xFF1f1338),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child:
                                                                      FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        output =
                                                                            '20';
                                                                        // discountprice =
                                                                        //     totalvalue -
                                                                        //         20;
                                                                        // discountprice =
                                                                        //     20;
                                                                      });
                                                                      withDiscount();
                                                                    },
                                                                    color: Colors
                                                                        .transparent,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            12.0),
                                                                    child: Text(
                                                                      '\$20',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                  height: 50,
                                                                  width: 80,
                                                                  decoration: BoxDecoration(
                                                                      color: Color(
                                                                          0xFF1f1338),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child:
                                                                      FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        output =
                                                                            '50';
                                                                        // discountprice =
                                                                        //     totalvalue -
                                                                        //         50;
                                                                        // discountprice =
                                                                        //     50;
                                                                      });
                                                                      withDiscount();
                                                                    },
                                                                    color: Colors
                                                                        .transparent,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            12.0),
                                                                    child: Text(
                                                                      '\$50',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                // ButtonTheme(
                                                                //   minWidth:
                                                                //       200.0,
                                                                //   height: 100.0,
                                                                //   child:
                                                                //       RaisedButton(
                                                                //     onPressed:
                                                                //         () {},
                                                                //     child: Text(
                                                                //         "test"),
                                                                //   ),
                                                                // )
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      // displayselectvalue();
                                                                      setState(
                                                                          () {
                                                                        percentageDiscountValue =
                                                                            0;
                                                                        typeDiscountValue =
                                                                            1;
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          50,
                                                                      width: 80,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .red,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8)),
                                                                      child:
                                                                          Text(
                                                                        '....',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 35),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      // child:
                                                                      //     RaisedButton(
                                                                      //   color: Colors
                                                                      //       .red,
                                                                      //   onPressed:
                                                                      //       () {
                                                                      //     displayselectvalue();
                                                                      //   },
                                                                      //   child:
                                                                      //       Text(
                                                                      //     '....',
                                                                      //     style: TextStyle(
                                                                      //         color:
                                                                      //             Colors.white,
                                                                      //         fontSize: 35),
                                                                      //     textAlign:
                                                                      //         TextAlign.center,
                                                                      //   ),
                                                                      // )
                                                                    )),
                                                              ],
                                                            )))
                                                  ],
                                                ),
                                              ),
                                            )),
                                        // Expanded(
                                        //     flex: 14,
                                        //     child: Center(
                                        //         // child: RaisedButton(
                                        //         //   color: Colors.red,
                                        //         //   onPressed: () {
                                        //         //     displayselectvalue();
                                        //         //   },
                                        //         //   child: Text(
                                        //         //     '....',
                                        //         //     style: TextStyle(
                                        //         //         color: Colors.white,
                                        //         //         fontSize: 35),
                                        //         //     textAlign: TextAlign.center,
                                        //         //   ),
                                        //         // ),
                                        //         ))
                                      ],
                                    ),
                                  )),
                              Expanded(
                                  flex: 77,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 32,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                right: BorderSide(
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                              )),
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20,
                                                      left: 8,
                                                      right: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Container(
                                                          height: 400,
                                                          child:
                                                              GridView.builder(
                                                                  gridDelegate:
                                                                      new SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount:
                                                                        2,
                                                                    childAspectRatio:
                                                                        1.3,
                                                                    mainAxisSpacing:
                                                                        15,
                                                                    crossAxisSpacing:
                                                                        15,
                                                                  ),
                                                                  itemCount:
                                                                      paybuttons
                                                                          .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    return FractionallySizedBox(
                                                                      widthFactor:
                                                                          1,
                                                                      child:
                                                                          RaisedButton(
                                                                        color: Colors
                                                                            .amber,
                                                                        onPressed:
                                                                            () {
                                                                          // changevalue =
                                                                          //     double.parse(output) - (totalvalue - discountprice);
                                                                          changevalue =
                                                                              double.parse(output) - (totalvalue);
                                                                          print(
                                                                              totalvalue);
                                                                          setState(
                                                                              () {
                                                                            double
                                                                                result =
                                                                                totalvalue - double.parse(output);
                                                                            totalvalue =
                                                                                result;
                                                                            orderpayment =
                                                                                new Paymentlistlist(paymentmode: paybuttons[index], price: double.parse(output));
                                                                            recallset = new Recalllist(
                                                                                id: '1',
                                                                                name: 'abc',
                                                                                price: double.parse(output),
                                                                                total: showsubtotal,
                                                                                paymentstatus: paybuttons[index],
                                                                                orderdate: DateTime.now(),
                                                                                paid: changevalue.toString(),
                                                                                phnno: '98456347856');

                                                                            print(changevalue);
                                                                            if (totalvalue ==
                                                                                0) {
                                                                              return nodataAlert(context, changevalue);
                                                                            } else if (totalvalue >
                                                                                0) {
                                                                              return null;
                                                                            } else if (changevalue !=
                                                                                0) {
                                                                              return nodataAlert(context, changevalue);
                                                                            } else
                                                                              return null;
                                                                          });
                                                                          for (int i = 0;
                                                                              i < widget.selectedorders.length;
                                                                              i++) {
                                                                            arrayOfProduct =
                                                                                ([
                                                                              {
                                                                                "name": widget.selectedorders[i].name,
                                                                                "amount": showsubtotal,
                                                                                "qty": widget.selectedorders[i].qty
                                                                              }
                                                                            ]);
                                                                            //   arrayOfProduct1.add(arrayOfProduct);
                                                                            print(arrayOfProduct1);
//                                                                           arrayOfProduct.add([{
// "name": widget.selectedorders[i].name,
//               "amount": showsubtotal,
//               "qty": widget.selectedorders[i].qty
//                                                                           }]);
//                                                                           arrayOfProduct1 = arrayOfProduct;
                                                                            FirebaseFirestore.instance.collection('dhoni@gmail.com').doc('food_dhoni').collection('orders').add({
                                                                              'items': FieldValue.arrayUnion(arrayOfProduct),
                                                                              //                                                                     'items':FieldValue.arrayUnion([
                                                                              // {
                                                                              //   "name": widget.selectedorders[i].name,
                                                                              //   "amount": showsubtotal,
                                                                              //   "qty": widget.selectedorders[i].qty
                                                                              // }]),
                                                                              'id': '1',
                                                                              'name': 'abc',
                                                                              'price': double.parse(output),
                                                                              'total': showsubtotal,
                                                                              'paymentstatus': paybuttons[index],
                                                                              'orderdate': DateTime.now(),
                                                                              'paid': changevalue.toString(),
                                                                              'phnno': '98456347856'
                                                                            });
                                                                          }
                                                                          recalllist
                                                                              .add(recallset);
//  ||
                                                                          //
                                                                          paymentdetails
                                                                              .add(orderpayment);
                                                                          deleteAmount(
                                                                              "C");

                                                                          print(
                                                                              paymentdetails);
                                                                          print(
                                                                              recalllist);

//  testPrint.sample(pathImage,plist);

                                                                          bluetooth
                                                                              .isConnected
                                                                              .then((isConnected) {
                                                                            if (isConnected) {
                                                                              bluetooth.printImage(pathImage);
                                                                              // bluetooth.printCustom(widget.selectedorders[0].name, 4, 1);

                                                                              bluetooth.printCustom("----------------------------------------------", 1, 1);
                                                                              bluetooth.write("Bill NO:" +
                                                                                  '45'
                                                                                  //  orderlist[0]['id']
                                                                                  +
                                                                                  "".padLeft(30-7, " ") +
                                                                                  "Date:" +
                                                                                  DateFormat('yMd').format(DateTime.now()));
                                                                              bluetooth.printNewLine();
                                                                              bluetooth.write("Time:" + DateFormat('hh:mm').format(DateTime.now()) + "".padLeft(36, " "));
                                                                              bluetooth.printNewLine();
                                                                              bluetooth.printCustom("----------------------------------------------", 1, 1);
                                                                              bluetooth.write("Menu item" + "" + "".padLeft(20, " ") + "Qty".padLeft(3, " ") + "Rate".padLeft(5, " ") + "Amount".padLeft(8, " "));

                                                                              bluetooth.printNewLine();
                                                                              bluetooth.printCustom("----------------------------------------------", 1, 1);
//                  for (int i = 0; i < orderlist.length; i++){
//                    setState(() {
//                      modifierlist = orderlist[i];
//                    });

//                  }
//                 for (int i = 0; i < modifierlist['items'].length; i++){
//                   var totallength = modifierlist['items'][i]['name'].length;
// var totalpaddings = 30 - totallength;
//   bluetooth.write(modifierlist['items'][i]['name'] +
//                ""+
//                 "".padLeft(totalpaddings, " ") +
//                 modifierlist['items'][i]['qty'].padLeft(3, " ") +
//                 modifierlist['items'][i]['price'].padLeft(5, " ")+modifierlist['items'][i]['amount'].padLeft(8, " "));

//                  bluetooth.printNewLine();
//                 }

                                                                              for (int i = 0; i < widget.selectedorders.length; i++) {
                                                                                var totallength = widget.selectedorders[i].name.length;
                                                                                var totalpaddings = 30 - totallength;
                                                                                bluetooth.write(widget.selectedorders[i].name + "" + "".padLeft(totalpaddings, " ") + widget.selectedorders[i].qty.toString().padLeft(3, " ") + widget.selectedorders[i].price.toString().padLeft(5, " ") + '300'.padLeft(8, " "));

                                                                                bluetooth.printNewLine();
                                                                              }
                                                                              bluetooth.printCustom("----------------------------------------------", 1, 1);
                                                                              bluetooth.write("Subtotal:" + "".padLeft(10, " ") + "2000".padLeft(29, " "));
                                                                              bluetooth.printCustom("----------------------------------------------", 1, 1);
                                                                              bluetooth.write("Total:" + "".padLeft(10, " ") + "2000".padLeft(32, " "));
                                                                              bluetooth.write("GST:" + "".padLeft(10, " ") + "2000000".padLeft(34, " "));
                                                                              bluetooth.printCustom("----------------------------------------------", 1, 1);
                                                                              bluetooth.write("Amount Paid:" + "".padLeft(10, " ") + "2000".padLeft(26, " "));
                                                                              bluetooth.write(paybuttons[index] + "".padLeft(10, " ") + "".padLeft(34, " "));
                                                                              bluetooth.printNewLine();
                                                                              bluetooth.printQRcode('UI', 250, 250, 1);
                                                                              bluetooth.printNewLine();
                                                                              bluetooth.printCustom("All price includes of taxes", 1, 1);
                                                                              bluetooth.paperCut();
                                                                              //     for (int i = 0; i < df.length; i++) {
                                                                              // setState(() {
                                                                              //   datad = df[i];
                                                                              // });
                                                                              //     var totallength = df[i].order[i].ordername.length;
                                                                              //     var totalpaddings = 30 - totallength;
                                                                              //     bluetooth.write(df[i].order[i].ordername + "" + "".padLeft(totalpaddings, " ") + df[i].order[i].qty.toString().padLeft(3, " ") + df[i].order[i].price.toString().padLeft(5, " ") + '300'.padLeft(8, " "));

                                                                              //     bluetooth.printNewLine();
                                                                              //   }
                                                                              // bluetooth.printCustom("----------------------------------------------", 1, 1);
                                                                              // bluetooth.write("Subtotal:" + "".padLeft(10, " ") + "2000".padLeft(29, " "));
                                                                              // bluetooth.printCustom("----------------------------------------------", 1, 1);
                                                                              // bluetooth.write("Total:" + "".padLeft(10, " ") + "2000".padLeft(32, " "));
                                                                              // bluetooth.write("GST:" + "".padLeft(10, " ") + "2000000".padLeft(34, " "));
                                                                              // bluetooth.printCustom("----------------------------------------------", 1, 1);
                                                                              // bluetooth.write("Amount Paid:" + "".padLeft(10, " ") + "2000".padLeft(26, " "));
                                                                              // bluetooth.write(datad.paymentstatus + "".padLeft(10, " ") + "".padLeft(34, " "));
                                                                              // bluetooth.printNewLine();
                                                                              // bluetooth.printQRcode('UI', 250, 250, 1);
                                                                              // bluetooth.printNewLine();
                                                                              // bluetooth.printCustom("All price includes of taxes", 1, 1);
                                                                              // bluetooth.paperCut();
                                                                            }
                                                                          });
                                                                        },
                                                                        child: Text(
                                                                            paybuttons[
                                                                                index],
                                                                            style:
                                                                                TextStyle(color: Colors.black, fontSize: 18)),
                                                                      ),
                                                                    );
                                                                  })),
                                                    ],
                                                  ))),
                                        ),
                                        Expanded(
                                            flex: 68,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 34,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                            // left: BorderSide(
                                                            //   color: Colors.black,
                                                            //   width: 1.0,
                                                            // ),
                                                            right: BorderSide(
                                                          color: Colors.black,
                                                          width: 1.0,
                                                        )),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                              // alignment: Alignment
                                                              //     .centerRight,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          12.0,
                                                                      vertical:
                                                                          5.0),
                                                              child: Text(
                                                                output,
                                                                // (double.parse(
                                                                //             output) -
                                                                //         discountprice)
                                                                //     .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30.0),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              )),
                                                          Divider(),
                                                          // Expanded(
                                                          //   child: Divider(),
                                                          // ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            // mainAxisAlignment:
                                                            //     MainAxisAlignment
                                                            //         .start,
                                                            children: <Widget>[
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  buildButton(
                                                                      "."),
                                                                  buildButton1(
                                                                      "C"),
                                                                  // buildButton("<-"),
                                                                  // buildButton("*")
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  buildButton(
                                                                      "7"),
                                                                  buildButton(
                                                                      "8"),
                                                                  buildButton(
                                                                      "9"),
                                                                  // buildButton("/")
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  buildButton(
                                                                      "4"),
                                                                  buildButton(
                                                                      "5"),
                                                                  buildButton(
                                                                      "6"),
                                                                  // buildButton("+")
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  buildButton(
                                                                      "1"),
                                                                  buildButton(
                                                                      "2"),
                                                                  buildButton(
                                                                      "3"),
                                                                  // buildButton("-")
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  buildButton(
                                                                      "0"),
                                                                  // buildButton("="),
                                                                ],
                                                              ),
                                                              percentageDiscountValue ==
                                                                      0
                                                                  ? Container()
                                                                  : Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              5),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            55,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.grey[300],
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(15.0)),
                                                                        ),
                                                                        child:
                                                                            RaisedButton(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                new BorderRadius.circular(18.0),
                                                                          ),
                                                                          // color:
                                                                          //     Colors.grey[300],
                                                                          onPressed:
                                                                              () {
                                                                            withPercentageDiscount();
                                                                            // setState(() {
                                                                            //   discountprice = (totalvalue * double.parse(output)) / 100;
                                                                            //   //   discountprice = totalvalue - double.parse(output);
                                                                            //   // discountprice = double.parse(output);

                                                                            // });
                                                                            deleteAmount("C");
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Enter',
                                                                            style:
                                                                                TextStyle(fontSize: 22, color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      )),
                                                              typeDiscountValue ==
                                                                      0
                                                                  ? Container()
                                                                  : Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              5),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            55,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.grey[300],
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(15.0)),
                                                                        ),
                                                                        child:
                                                                            RaisedButton(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                new BorderRadius.circular(18.0),
                                                                          ),
                                                                          // color:
                                                                          //     Colors.grey[300],
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              withDiscount();
                                                                              //  discountprice = (totalvalue * double.parse(output)) / 100;

                                                                              // output = "0.00";
                                                                              // Navigator.pop(context);
                                                                              // totaldiscount.clear();
                                                                              // calculatevalue();
                                                                            });
                                                                            deleteAmount("C");
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Enter',
                                                                            style:
                                                                                TextStyle(fontSize: 22, color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                Expanded(
                                                  flex: 34,

                                                  // child: Padding(
                                                  //     padding: EdgeInsets.only(
                                                  //         top: 20,
                                                  //         right: 5,
                                                  //         left: 5),
                                                  //     child: Container(
                                                  //       child:
                                                  //           Column(children: <
                                                  //               Widget>[

                                                  //         Row(
                                                  //           children: <Widget>[
                                                  //             Text(
                                                  //                 "Number 2 : "),
                                                  //             new Flexible(
                                                  //               child:
                                                  //                   new TextField(
                                                  //                 keyboardType:
                                                  //                     TextInputType
                                                  //                         .number,
                                                  //                 controller:
                                                  //                     num2controller,
                                                  //               ),
                                                  //             ),
                                                  //           ],
                                                  //         ),

                                                  //       ]),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      TextField(
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelText:
                                                              'Split Amount',
                                                          hintText:
                                                              'Split Amount',
                                                        ),
                                                        autofocus: false,
                                                      ),
                                                      // RaisedButton(
                                                      //   color:
                                                      //       Color(0xFF1f1338),
                                                      //   onPressed: () {},
                                                      //   child: Text(
                                                      //     'Done',
                                                      //     style: TextStyle(
                                                      //         color: Colors
                                                      //             .white),
                                                      //   ),
                                                      // ),
                                                      Container(
                                                          height: 450,
                                                          child:
                                                              ListView.builder(
                                                                  itemCount: paymentdetails
                                                                              .length ==
                                                                          0
                                                                      ? 0
                                                                      : paymentdetails
                                                                          .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    return Card(
                                                                        child: paymentdetails[index].price ==
                                                                                0.0
                                                                            ? Container()
                                                                            : ListTile(
                                                                                title: Text(paymentdetails[index].paymentmode),
                                                                                subtitle: Text(paymentdetails[index].price.toString()),
                                                                                trailing: paymentcolors(paymentdetails[index])
                                                                                //  Icon(
                                                                                //   Icons.circle,
                                                                                //   color:
                                                                                //       Colors.red,
                                                                                // ),
                                                                                ));
                                                                  }))

                                                      // Card(
                                                      //     child: ListTile(
                                                      //   title: Text('Cash'),
                                                      //   subtitle: Text('\$20'),
                                                      //   trailing: Icon(
                                                      //     Icons.circle,
                                                      //     color: Colors.green,
                                                      //   ),
                                                      // )),
                                                      // Card(
                                                      //     child: ListTile(
                                                      //   title: Text('Split'),
                                                      //   subtitle: Text('\$35'),
                                                      //   trailing: Icon(
                                                      //     Icons.circle,
                                                      //     color: Colors.blue,
                                                      //   ),
                                                      // ))
                                                    ],
                                                  ),
                                                  //     ))
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ))
                  ],
                ))));
  }
}
