import 'dart:io';
import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class printerDevices extends StatefulWidget {
  var datalist;
  printerDevices({this.datalist});
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<printerDevices> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;

  fetchorderrecall() async {
    FirebaseFirestore.instance
        .collection('dhoni@gmail.com')
        .doc('food_dhoni')
        .collection('orders')
        .get()
        .then((orderrecval) {
      orderrecval.docs.forEach((pdt) {
        setState(() {
          orderlist.add(pdt.data());
        });
        print(orderlist);
      });
      return orderlist;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchorderrecall();
    initPlatformState();
    // initSavetoPath();

    _read();
    _readconnection();
    // getData();
    // _getImage();
  }

  List orderlist = [];
  initSavetoPath() async {
    //read and write
    //image max 300px X 300px
    final filename = 'yourlogo.png';
    var bytes = await rootBundle.load("assets/images/yourlogo.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    // writeToFile(bytes,'$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
    });
  }

  //  _getImage()async{
  //     var response = await http.get("http://52.37.166.43:3000/bell.png");
  //     Directory documentDirectory = await getApplicationDocumentsDirectory();
  //     File file = new File(join(documentDirectory.path, 'bell.png'));
  //     file.writeAsBytesSync(response.bodyBytes);
  //     setState(() {
  //       pathImage='${file.path}';
  //     });
  //  }
  //  /data/data/com.example.mobileprintutility/app_flutter/imagetest.png
// data/user/0/com.example.mobileprintutility/app_flutter/imagetest.png
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

  _getspltit(String x, int length) {
    String result = "";
    if (x.length <= length) {
      return x;
    } else {
      var sub = x.substring(0, length);
      result += sub + "\n" + _getspltit(x.replaceAll(sub, ""), length);
    }
    return result;
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'printer';
    final value = prefs.getString(key) ?? 0;

    return value.toString();
  }

  _readconnection() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'connected';
    final value = prefs.getBool(key) ?? 0;

    return value;
  }

  // final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('Printer').snapshots();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Printer',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (value) => setState(() => _device = value),
                        value: _device,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
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
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                  child: RaisedButton(
                    color: Colors.brown,
                    onPressed: () {
                      // _timer = new Timer.periodic(new Duration(seconds: 5), (time) {
                      // testPrint.sample(pathImage);
                      getData();
                      // });
                      // timer();
                    },
                    child: Text('PRINT TEST',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  var modifierlist;
  List<Offset> pointList = <Offset>[];
  Timer _timer;
  String documentId = "W0bxpBQYQOJU4yqAvLJa";
  getData() {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printImage(pathImage);
        // bluetooth.printCustom(widget.selectedorders[0].name, 4, 1);

        bluetooth.printCustom(
            "----------------------------------------------", 1, 1);
        bluetooth.write("Bill NO:" +
            '45'
            //  orderlist[0]['id']
            +
            "".padLeft(30 - 7, " ") +
            "Date:" +
            DateFormat('yMd').format(widget.datalist['orderdate'].toDate()));
        bluetooth.printNewLine();
        bluetooth.write("Time:" +
            DateFormat('hh:mm').format(widget.datalist['orderdate'].toDate()) +
            "".padLeft(36, " "));
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "----------------------------------------------", 1, 1);
        bluetooth.write("Menu item" +
            "" +
            "".padLeft(20, " ") +
            "Qty".padLeft(3, " ") +
            "Rate".padLeft(5, " ") +
            "Amount".padLeft(8, " "));

        bluetooth.printNewLine();
        bluetooth.printCustom(
            "----------------------------------------------", 1, 1);

        for (int i = 0; i < widget.datalist.length; i++) {
          var totallength = widget.datalist['items'][0]['name'].length;
          var totalpaddings = 30 - totallength;
          bluetooth.write(widget.datalist['items'][0]['name'] +
              "" +
              "".padLeft(totalpaddings, " ") +
              widget.datalist['items'][0]['qty'].toString().padLeft(3, " ") +
              widget.datalist['items'][0]['amount'].padLeft(5, " ") +
              '300'.padLeft(8, " "));

          bluetooth.printNewLine();
        }
        bluetooth.printCustom(
            "----------------------------------------------", 1, 1);
        bluetooth
            .write("Subtotal:" + "".padLeft(10, " ") + "2000".padLeft(29, " "));
        bluetooth.printCustom(
            "----------------------------------------------", 1, 1);
        bluetooth
            .write("Total:" + "".padLeft(10, " ") + "2000".padLeft(32, " "));
        bluetooth
            .write("GST:" + "".padLeft(10, " ") + "2000000".padLeft(34, " "));
        bluetooth.printCustom(
            "----------------------------------------------", 1, 1);
        bluetooth.write(
            "Amount Paid:" + "".padLeft(10, " ") + "2000".padLeft(26, " "));
        bluetooth.write(widget.datalist['paymentstatus'] +
            "".padLeft(10, " ") +
            "".padLeft(34, " "));
        bluetooth.printNewLine();
        bluetooth.printQRcode('UI', 250, 250, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("All price includes of taxes", 1, 1);
        bluetooth.paperCut();
      }
// if (isConnected){

//             bluetooth.printCustom(orderlist[0]['name'], 4, 1);

//             bluetooth.printCustom(
//                 "----------------------------------------------", 1, 1);
//             bluetooth.write("Bill NO:" +
//                orderlist[0]['id']+
//                 "".padLeft(20, " ") +
//                 "Date:" +
//                 DateFormat('yMd').format(orderlist[0]['orderdate'].toDate()));
//             bluetooth.printNewLine();
//             bluetooth.write("Time:" + DateFormat('hh:mm').format(orderlist[0]['orderdate'].toDate()) + "".padLeft(36, " "));
//             bluetooth.printNewLine();
//             bluetooth.printCustom(
//                 "----------------------------------------------", 1, 1);
//            bluetooth.write("Menu item" +
//                ""+
//                 "".padLeft(20, " ") +
//                 "Qty".padLeft(3, " ") +
//                 "Rate".padLeft(5, " ")+"Amount".padLeft(8, " "));

//                   bluetooth.printNewLine();
//            bluetooth.printCustom(
//                 "----------------------------------------------", 1, 1);
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

//            bluetooth.printCustom(
//                 "----------------------------------------------", 1, 1);
//          bluetooth.write("Subtotal:" +"".padLeft(10, " ")+"2000".padLeft(29, " "));
//            bluetooth.printCustom(
//                 "----------------------------------------------", 1, 1);
//          bluetooth.write("Total:" +"".padLeft(10, " ")+"2000".padLeft(32, " "));
//          bluetooth.write("GST:" +"".padLeft(10, " ")+"2000000".padLeft(34, " "));
//            bluetooth.printCustom(
//                 "----------------------------------------------", 1, 1);

//          bluetooth.write("Amount Paid:" +"".padLeft(10, " ")+"156546357".padLeft(25, " "));

//            bluetooth.printNewLine();
//            bluetooth.printQRcode('UI', 200, 200, 1);
//            bluetooth.printNewLine();
//            bluetooth.printCustom("All price includes of taxes", 1, 1);
//            bluetooth.paperCut();
// }
    });
  }

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

  String _printerBluetooth;
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

//write to app path
  // Future<void> writeToFile(ByteData data, String path) {
  //   final buffer = data.buffer;
  //   return new File(path).writeAsBytes(
  //       buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  // }

  // Future show(
  //   String message, {
  //   Duration duration: const Duration(seconds: 3),
  // }) async {
  //   await new Future.delayed(new Duration(milliseconds: 100));
  //   Scaffold.of(context).showSnackBar(
  //     new SnackBar(
  //       content: new Text(
  //         message,
  //         style: new TextStyle(
  //           color: Colors.white,
  //         ),
  //       ),
  //       duration: duration,
  //     ),
  //   );
  // }
}
