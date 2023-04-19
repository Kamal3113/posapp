import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posbillingapp/list/recalllist.dart';
import 'package:posbillingapp/printerformat.dart';

class Recallpage extends StatefulWidget {
  List<Recalllist> recalldata;
  Recallpage({this.recalldata});
  @override
  _RecallpageState createState() => _RecallpageState();
}

class NumberList {
  String number;
  int index;
  NumberList({this.number, this.index});
}

class _RecallpageState extends State<Recallpage> {
  final List<String> values = <String>[
    'Order No.',
    'Employee',
    'Name',
    'phone',
    'Date',
  ];
  String _selectedDate = 'Tap to select date';
  var date = DateTime.now();
  var result;
  String selectedValue = 'Order No.';
  List orderlist = [];
  //   Future<List> fetchAllContact() async {
  //   List contactList = [];
  //   DocumentSnapshot documentSnapshot =
  //       await FirebaseFirestore.instance.collection('my_contact').doc('details').get();
  //   contactList = documentSnapshot.data();
  //   return contactList;
  // }
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

  int selectedrecalist = 0;
  void initState() {
    super.initState();
    usersFiltered = orderlist;
    fetchorderrecall();
  }
 int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }
  List usersFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  String filter;
  TextEditingController _searchcontroller = new TextEditingController();
  var data;

  color() {
    if (selectedrecalist == 1) {
      return Colors.amber;
    } else {
      return Colors.teal;
    }
    //return  selectedrecalist==1?Colors.amber:Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {},
              icon: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ))),
          actions: [
            Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 5),
                child: Row(
                  children: [
                    RaisedButton(
                      color: Color(0xFF1f1338),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => printerDevices(
                                      datalist: data,
                                    )));
                      },
                      child: Text(
                        'Print',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    RaisedButton(
                      color: Color(0xFF1f1338),
                      onPressed: () {},
                      child: Text(
                        'Kitchen Print',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ))
          ],
          backgroundColor: Colors.white,
          title: Text(
            'Order Recall',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          child: Column(
            children: [
              Expanded(
                  flex: 14,
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                            child: Container(
                          child: Row(
                            children: [
                              Padding(padding: EdgeInsets.only(left: 5)),
                              Center(
                                child: Text(
                                  'Search For',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                // height: 60,
                                width: 240,
                                decoration: BoxDecoration(
                                    color: Color(0xFFe9f2f2),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                      value: selectedValue,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedValue = value;
                                        });
                                      },
                                      items: values
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ))),
                              )
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          width: 20,
                          child: TextField(
                              controller: controller,
                              obscureText: false,
                              decoration: new InputDecoration(
                                  hintText: 'Search',),
                              onChanged: (value) {
                                setState(() {
                                  _searchResult = value;
                                  usersFiltered = orderlist
                                      .where((user) =>
                                          user[0]
                                              .paymentstatus
                                              .contains(_searchResult) ||
                                          user.role.contains(_searchResult))
                                      .toList();
                                  print(usersFiltered);
                                });
                              }),
                        )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFFe9f2f2),
                                  borderRadius: BorderRadius.circular(30)),
                              // border: Border.all(width: 1, color: Colors.grey)),
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Select Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      FlatButton(
                                        child: Row(
                                          children: [
                                            Text(DateFormat('yyyy-MM-dd')
                                                .format(date)),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(Icons.calendar_today_outlined)
                                          ],
                                        ),
                                        onPressed: () async {
                                          result = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2040, 1, 1),
                                          );
                                          setState(() {
                                            date = result;
                                          });
                                          print('$result');
                                        },
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFFe9f2f2),
                                  borderRadius: BorderRadius.circular(30)),
                              child: FlatButton(
                                onPressed: () {},
                                child: Text('Search'),
                              ),
                            )
                          ],
                        )),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 85,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                            flex: 79,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                   showCheckboxColumn: false,
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                      (states) {
                                        return Color(0xFF1f1338);
                                      },
                                    ),
                                    columns: <DataColumn>[
                                      DataColumn(
                                        label: Text(
                                          'Order/Table',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Customer',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Status',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Paid',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'PhoneNo.',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Orderdate',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Clerk',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Total',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                    rows: usersFiltered
                                        .map(
                                          ((element) => DataRow(
                                             
            //                                        selected: orderlist.contains(element),
            // onSelectChanged: (isSelected) => setState(() {
            //   final isAdding = isSelected != null && isSelected;

            //   isAdding
            //       ? orderlist.add(element)
            //       : orderlist.remove(element);
            // }),
                                               onSelectChanged:     (bool selected) {
                                                  setState(() {
                                                    selectedrecalist = 1;
                                                    data = element;
                                                  });

                                                  print(
                                                      'row-selected: ${element['paymentstatus']}');
                                                },
                                                color: MaterialStateColor
                                                    .resolveWith(
                                                  (states) {
                                                    if (selectedrecalist == 1) {
                                                      return Colors.blue[50];
                                                    } else {
                                                      return Colors.white;
                                                    }
                                                  },
                                                ),
                                                cells: <DataCell>[
                                                  DataCell(Text(element["id"]),
                                                      onTap: () {
                                                    print(element["price"]);
                                                  }),
                                                  DataCell(
                                                      Text(element["name"])),
                                                  DataCell(Text(element[
                                                      "paymentstatus"])),
                                                  DataCell(
                                                      Text(element["paid"])),
                                                  DataCell(
                                                      Text(element["phnno"])),
                                                  DataCell(Text(
                                                      DateFormat('yMd').format(
                                                          element["orderdate"]
                                                              .toDate()))),
                                                  DataCell(Text(element["price"]
                                                      .toString())),
                                                  DataCell(
                                                      Text(element["total"])),
                                                ],
                                              )),
                                        )
                                        .toList()))),
                        Expanded(
                            flex: 28,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(color: Colors.black))),
                            ))
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
