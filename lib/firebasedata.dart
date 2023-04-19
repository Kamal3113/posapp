// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:posbillingapp/list/cart.dart';
// import 'package:posbillingapp/login.dart';
// import 'package:posbillingapp/payment/paymentscreen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Firebasedata extends StatefulWidget {
//   const Firebasedata({Key? key}) : super(key: key);

//   @override
//   _FirebasedataState createState() => _FirebasedataState();
// }

// class _FirebasedataState extends State<Firebasedata> {
//   void initState() {
//     super.initState();
//     getappid();
//   }

//   var modifierlist;
//   late String email;
//   getappid() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       email = preferences.getString("email").toString();
//     });
//     fetchAllCategory();
//   }

//   var cartproduct;
//   List categorylist = [];
//   List productlist = [];
//   List openappproductlist = [];
//   List productmodifierlist = [];
//   var userdatalist;
//   fetchAllCategory() async {
//     var documentSnapshot = await FirebaseFirestore.instance
//         .collection('dhoni@gmail.com')
//         .get()
//         .then((vl) {
//       vl.docs.forEach((f) {
//         print(f.data()['name']);
//         setState(() {
//           userdatalist = f;
//         });
//         print(userdatalist);
//         FirebaseFirestore.instance
//             .collection('dhoni@gmail.com')
//             .doc(f.id)
//             .collection('category')
//             .get()
//             //     .then((dd) {
//             //   categorylist = dd.data();l
//             // });
//             .then((vl) {
//           vl.docs.forEach((ff) {
//             setState(() {
//               categorylist.add(ff.data());
//               pointlist.add(ff.data()['modifier']);
//             });
//             // print(categorylist);
//             //     // for (int i = 1; i < vl.docs.length; i++) {
//             //     // setState(() {
//             //     //   categorylist = vl.docs[i].data()['name'];
//             //     // });
//           });
//           return categorylist;
//         });
//       });
//     });
//     openappshowproducts();
//     // return categorylist;
//   }

//   fetchcategory(var pdtdata) async {
//     FirebaseFirestore.instance
//         .collection('dhoni@gmail.com')
//         .doc(userdatalist.id)
//         .collection('category')
//         .doc(pdtdata['id'])
//         .collection('product')
//         .get()
//         .then((pdtval) {
//       pdtval.docs.forEach((pdt) {
//         setState(() {
//           productlist.add(pdt.data());
//         });
//         print(productlist);
//       });
//       return productlist;
//     });
//   }

//   openappshowproducts() async {
//     return FirebaseFirestore.instance
//         .collection('dhoni@gmail.com')
//         .doc(userdatalist.id)
//         .collection('product')
//         .where('cat_id', isEqualTo: 'ctg_bread_dhoni')
//         .snapshots()
//         .listen((data) => data.docChanges.forEach((dd) {
//               setState(() {
//                 productlist.add(dd.doc);

//                 //  pointlist = List.from(dd.doc['']);
//               });
//             }
//                 // => print(doc.doc['name'])
//                 ));
//   }

//   deleteitem(String selectedid) {
//     for (int i = 0; i < cartlist.length; i++) {
//       if (selectedid == cartlist[i].id) {
//         if (mounted)
//           setState(() {
//             cartlist.remove(cartlist[i]);
//           });
//       }
//     }
//   }

//   int _count = 1;
//   List pointlist = [];
//   fbproductlis(var pdata) {
//     FirebaseFirestore.instance
//         .collection('dhoni@gmail.com')
//         .doc(userdatalist.id)
//         .collection('product')
//         .where('cat_id', isEqualTo: pdata['id'])
//         .snapshots()
//         .listen((data) => data.docChanges.forEach((dd) {
//               setState(() {
//                 productlist.add(dd.doc);

//                 //  pointlist = List.from(dd.doc['']);
//               });
//             }
//                 // => print(doc.doc['name'])
//                 ));
//   }

//   fbmodifierlist(var pdata) {
//     FirebaseFirestore.instance
//         .collection('dhoni@gmail.com')
//         .doc(userdatalist.id)
//         .collection('menugroup')
//         .where('pdt_id', isEqualTo: pdata.id)
//         .snapshots()
//         .listen((data) => data.docChanges.forEach((dd) {
//               setState(() {
//                 productmodifierlist.add(dd.doc);

//                 //  pointlist = List.from(dd.doc['']);
//               });
//               print(productmodifierlist);
//             }
//                 // => print(doc.doc['name'])
//                 ));
//   }

//   gettotal(int totalvalue) {
//     setState(() {
//       total = '\$${_count * totalvalue}';
//     });
//     // addmodifierlist.length == 0
//     //     ? setState(() {
//     //         total = '\$${_count * totalvalue}';
//     //       })
//     //     : setState(() {
//     //         total = '\$${_count * totalvalue + addmodifierlist[0]['price']}';
//     //       });
//     print(total);
//   }

//   gettotalfirst(int totalvalue) {
//     setState(() {
//       totalfirstvalue = '\$${_count * totalvalue}';
//     });
//     print(total);
//   }

//   increment(int index) {
//     setState(() {
//       cartlist[index].qty = cartlist[index].qty + 1;
//     });
//   }

//   int addlist = 0;
//   // increment(Cartlist cartlist) {
//   //   setState(() {
//   //     addlist = cartlist.qty + 1;
//   //   });
//   //   return cartlist.qty = addlist;
//   //   // print(cartlist.qty);

//   //   // for (int i = 0; i < cartlist.length; i++) {
//   //   //   if (id == cartlist[i].id) {
//   //   //     setState(() {
//   //   //       cartlist[i].qty = cartlist[i].qty + 1;
//   //   //       //  _count = cart[i]['qty'] + 1;
//   //   //     });
//   //   //     print(cartlist[i].qty);
//   //   //   }
//   //   // }
//   // }

//   decriment(String id) {
//     for (int i = 0; i < cart.length; i++) {
//       if (id == cart[i]['id']) {
//         setState(() {
//           if (cart[i]['qty'] > 1) {
//             cart[i]['qty'] = cart[i]['qty'] - 1;
//           }
//         });
//         print(cart[i]['qty']);
//       }
//     }
//   }

//   int _selectedIndex = 0;

//   _onSelected(int index) {
//     setState(() => _selectedIndex = index);
//   }

//   var modifierprice;
//   List addmodifierlist = [];
//   String totalfirstvalue = '0';
//   String total = '0';
//   _addcombolist(List combodetails, int index) {
//     // gettotalfirst(combodetails['price']);
//     // setState(() {
//     //   totalfirstvalue = combodetails['price'].toString();
//     // });
//     return GestureDetector(
//       onTap: () {
//         _onSelected(index);
//         setState(() {
//           //carttapcolor = true;
//           addmodifierlist = combodetails;
//         });
//       },
//       child: Card(
//         color: _selectedIndex != null && _selectedIndex == index
//             ? Colors.blue[100]
//             : Colors.white,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   child: Row(
//                     children: [
//                       IconButton(
//                           onPressed: () {
//                             setState(() {
//                               if (_count > 1) {
//                                 _count -= 1;
//                                 //   gettotal(combodetails);
//                               }
//                             });
//                           },
//                           icon: Icon(
//                             Icons.remove,
//                             size: 28,
//                             color: Colors.green,
//                           )),
//                       Text(
//                         // combodetails['qty'].toString(),
//                         "$_count",
//                         style: TextStyle(fontSize: 20),
//                       ),
//                       IconButton(
//                           onPressed: () {
//                             // increment(combodetails.id);
//                             setState(() {
//                               // _count += 1;
//                               //  gettotal(combodetails['price']);
//                             });
//                           },
//                           icon: Icon(
//                             Icons.add,
//                             size: 28,
//                             color: Colors.orange,
//                           )),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // Text(
//                           //   combodetails['name'],
//                           //   style: TextStyle(
//                           //       color: Colors.black,
//                           //       fontWeight: FontWeight.bold,
//                           //       fontSize: 17),
//                           // ),
//                           addmodifierlist.length == 0
//                               ? Container()
//                               : Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: List.generate(
//                                       addmodifierlist.length, (index) {
//                                     // setState(() {
//                                     //   modifierprice = addmodifierlist[index]['price'];
//                                     // });
//                                     // print(modifierprice);
//                                     return Text(
//                                       addmodifierlist[index]['name'],

//                                       // combodetails.modify[index].modifiername,
//                                       style: TextStyle(
//                                           color: Colors.red,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 15),
//                                     );
//                                   }),
//                                 ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     // addmodifierlist.length == 0
//                     //     ? Text('\$${_count * combodetails['price']}',
//                     //         style: TextStyle(
//                     //             color: Colors.black,
//                     //             fontWeight: FontWeight.bold,
//                     //             fontSize: 15))
//                     //     : Text(
//                     //         '\$${_count * (combodetails['price'] + addmodifierlist[index]['price'])}',
//                     //         style: TextStyle(
//                     //             color: Colors.black,
//                     //             fontWeight: FontWeight.bold,
//                     //             fontSize: 15)),
//                     // Text('\$${_count * combodetails['price']}',
//                     //     style: TextStyle(
//                     //         color: Colors.black,
//                     //         fontWeight: FontWeight.bold,
//                     //         fontSize: 15)),
//                     IconButton(
//                         onPressed: () {
//                           //    deleteitem(combodetails.id);
//                         },
//                         icon: Icon(
//                           Icons.delete,
//                           size: 23,
//                           color: Colors.red,
//                         ))
//                     //  Text('\$${_count * combodetails['price']}'),
//                   ],
//                 ),
//               ],
//             ),

//             // addproduct(combodetails.id)
//           ],
//         ),
//       ),
//     );
//   }

//   getproductmodifierlist() {
//     return ListView.builder(
//         scrollDirection: Axis.vertical,
//         itemCount: cartproduct == null ? 1 : cartproduct['modifier'].length,
//         itemBuilder: (BuildContext context, int index) {
//           return GestureDetector(
//               onTap: () {
//                 if (cartproduct == null) {
//                   setState(() {
//                     addmodifierlist.add('');
//                   });
//                 } else if (cartproduct != null) {
//                   setState(() {
//                     addmodifierlist.add(cartproduct['modifier'][index]);
//                   });
//                 }

//                 print(addmodifierlist);
//               },
//               child: cartproduct != null
//                   ? Card(
//                       child: Container(
//                           color: Colors.brown,
//                           // color: restaurants[index].color,
//                           height: 80,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Center(
//                                   child: Text(
//                                 cartproduct == null
//                                     ? ''
//                                     : cartproduct['modifier'][index]['name'],
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 17.0,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               )),
//                               Center(
//                                   child: Text(
//                                 cartproduct == null
//                                     ? ''
//                                     : '\$${cartproduct['modifier'][index]['price']}'
//                                         .toString(),
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 17.0,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               )),
//                             ],
//                           )))
//                   : Container());
//         });
//   }

//   getcategorylist() {
//     return Expanded(
//         flex: 10,
//         child: Container(
//           decoration: BoxDecoration(
//               border: Border(bottom: BorderSide(color: Colors.black))),
//           child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: categorylist.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         modifierlist = categorylist[index];
//                       });
//                       productlist.clear();
//                       fbproductlis(categorylist[index]);
//                       // setState(() {
//                       //   product = restaurants[index];
//                       // modifierlist = restaurants[index];
//                       // });
//                     },
//                     child: Card(
//                         child: Container(
//                       color: Colors.red,
//                       // color: restaurants[index].color,
//                       width: 120,
//                       child: Center(
//                           child: Text(
//                         categorylist[index]['name'],
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 17.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       )),
//                     )));
//               }),
//           // color: Colors.white,
//         ));
//   }

//   // ignore: deprecated_member_use
//   List<Cartlist> cartlist = [];
//   var cartitems;
//   getdata() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 1,
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             flex: 70,
//             child: Container(
//               child: Column(
//                 children: [
//                   // productmodifierlist.length == 0
//                   //     ?
//                   getcategorylist(),
//                   // : Expanded(
//                   //     flex: 10,
//                   //     child: Container(
//                   //       decoration: BoxDecoration(
//                   //           border: Border(
//                   //               bottom: BorderSide(color: Colors.black))),
//                   //       child: ListView.builder(
//                   //           scrollDirection: Axis.horizontal,
//                   //           itemCount: productmodifierlist.length,
//                   //           itemBuilder: (BuildContext context, int index) {
//                   //             return GestureDetector(
//                   //                 onTap: () {
//                   //                   setState(() {
//                   //                     modifierlist = categorylist[index];
//                   //                   });
//                   //                   productlist.clear();
//                   //                   fbproductlis(categorylist[index]);
//                   //                   // setState(() {
//                   //                   //   product = restaurants[index];
//                   //                   // modifierlist = restaurants[index];
//                   //                   // });
//                   //                 },
//                   //                 child: Card(
//                   //                     child: Container(
//                   //                   color: Colors.red,
//                   //                   // color: restaurants[index].color,
//                   //                   width: 120,
//                   //                   child: Center(
//                   //                       child: Text(
//                   //                     productmodifierlist[index]['name'],
//                   //                     style: TextStyle(
//                   //                       color: Colors.white,
//                   //                       fontSize: 17.0,
//                   //                       fontWeight: FontWeight.bold,
//                   //                     ),
//                   //                   )),
//                   //                 )));
//                   //           }),
//                   //       // color: Colors.white,
//                   //     )),
//                   Expanded(
//                       flex: 80,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                               flex: 60,
//                               child: Container(
//                                 child: GridView.builder(
//                                     gridDelegate:
//                                         new SliverGridDelegateWithFixedCrossAxisCount(
//                                       crossAxisCount: 5,
//                                       childAspectRatio: 1.3,
//                                       mainAxisSpacing: 0,
//                                       crossAxisSpacing: 0,
//                                     ),
//                                     shrinkWrap: true,
//                                     itemCount: productlist.length == 0
//                                         ? openappproductlist.length
//                                         : productlist.length,
//                                     //  product == null
//                                     //     ? restaurants[0].menu.length
//                                     //     : product.menu.length,
//                                     itemBuilder:
//                                         (BuildContext context1, int index1) {
//                                       return GestureDetector(
//                                           onTap: () {
//                                             fbmodifierlist(productlist[index1]);
//                                             setState(() {
//                                               cartitems = new Cartlist(
//                                                   id: productlist[index1].id,
//                                                   name: productlist[index1]
//                                                       ['name'],
//                                                   price: productlist[index1]
//                                                           ['price']
//                                                       .toString(),
//                                                   qty: productlist[index1]
//                                                       ['qty'],
//                                                   cartmomodifylist: []);
//                                             });

//                                             //    productmodifier = productlist[index1];
//                                             cartproduct = productlist[index1];

//                                             cartlist.add(cartitems);
//                                             // if (product == null) {
//                                             //   setState(() {
//                                             //     itemlist =
//                                             //         restaurants[0].menu[index1];
//                                             //   });
//                                             //   if (restaurants[0]
//                                             //           .menu[index1]
//                                             //           .modifylist[index1] ==
//                                             //       null) {
//                                             //     return null;
//                                             //   } else {
//                                             //     Navigator.push(
//                                             //         context,
//                                             //         MaterialPageRoute(
//                                             //             builder: (context) =>
//                                             //                 Testscreen(
//                                             //                     modifiertemplate:
//                                             //                         restaurants[0]
//                                             //                             .menu[index1]
//                                             //                             .modifylist)));
//                                             //   }
//                                             //   cart.add(itemlist);
//                                             // } else {
//                                             //   setState(() {
//                                             //     itemlist = product.menu[index1];
//                                             //   });
//                                             //   if (product.menu[index1]
//                                             //           .modifylist[index1] ==
//                                             //       null) {
//                                             //     return null;
//                                             //   } else {
//                                             //     Navigator.push(
//                                             //         context,
//                                             //         MaterialPageRoute(
//                                             //             builder: (context) =>
//                                             //                 Testscreen(
//                                             //                     modifiertemplate:
//                                             //                         restaurants[0]
//                                             //                             .menu[index1]
//                                             //                             .modifylist)));
//                                             //   }
//                                             //   cart.add(itemlist);
//                                             // }
//                                           },
//                                           child: Card(
//                                               child: Container(
//                                             color: Colors.purple,
//                                             // color: product == null
//                                             //     ? restaurants[0].menu[index1].color
//                                             //     : product.menu[index1].color,
//                                             child: Center(
//                                                 child: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                   Text(
//                                                     productlist.length == 0
//                                                         ? openappproductlist[
//                                                             index1]['name']
//                                                         : productlist[index1]
//                                                             ['name'],
//                                                     // product == null
//                                                     //     ? restaurants[0]
//                                                     //         .menu[index1]
//                                                     //         .name
//                                                     //     : product.menu[index1].name,
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 17.0,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     productlist.length == 0
//                                                         ? '\$${openappproductlist[index1]['price'].toString()}'
//                                                         : '\$${productlist[index1]['price'].toString()} ',
//                                                     //  '\$${product.menu[index1].price.toString()} ',
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 17.0,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   )
//                                                 ])),
//                                           )));
//                                     }),
//                                 color: Colors.white,
//                               )),
//                           Expanded(
//                               flex: 10,
//                               child: Container(child: getproductmodifierlist()))
//                         ],
//                       )),
//                   // productmodifierlist.length == 0
//                   //     ?
//                   Expanded(
//                       flex: 10,
//                       child: Container(
//                         child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: modifierlist == null
//                                 ? 1
//                                 //categorylist[0]['modifier'].length
//                                 : modifierlist['modifier'].length,
//                             itemBuilder: (BuildContext context, int index) {
//                               return GestureDetector(
//                                   onTap: () {
//                                     // if (modifierlist == null) {
//                                     //   if (addmodifierlist == null) {
//                                     //     return addmodifierlist;
//                                     //   } else {
//                                     //     setState(() {
//                                     //       addmodifierlist.modify.add(
//                                     //           restaurants[0].modify[index]);
//                                     //     });
//                                     //   }
//                                     // } else {
//                                     //   if (addmodifierlist == null) {
//                                     //     return addmodifierlist;
//                                     //   } else {
//                                     //     setState(() {
//                                     //       addmodifierlist.modify.add(
//                                     //           modifierlist.modify[index]);
//                                     //     });
//                                     //   }
//                                     // }
//                                   },
//                                   child: Card(
//                                       child: Container(
//                                     color: Colors.blue,
//                                     // color: modifierlist == null
//                                     //     ? restaurants[0].modify[index].color
//                                     //     : modifierlist.modify[index].color,
//                                     width: 120,
//                                     child: Center(
//                                         child: Text(
//                                       modifierlist == null
//                                           ? 'cherry'
//                                           //pointlist[index][index]['name']
//                                           // categorylist[0]['modifier'][0]
//                                           //     ['name']
//                                           : modifierlist['modifier'][index]
//                                               ['name'],
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 17.0,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     )),
//                                   )));
//                             }),
//                         // color: Colors.pink,
//                       ))
//                   // : Expanded(
//                   //     flex: 10,
//                   //     child: Row(
//                   //       // mainAxisAlignment: MainAxisAlignment.start,
//                   //       crossAxisAlignment: CrossAxisAlignment.stretch,
//                   //       children: [
//                   //         Container(
//                   //             // height: 60,
//                   //             child: RaisedButton(
//                   //           color: Colors.red,
//                   //           onPressed: () {
//                   //             // productmodifier.clear();
//                   //             // getdata();
//                   //             // detailmod.clear();
//                   //             // detailmodifierlist.clear();
//                   //             Navigator.pushAndRemoveUntil(
//                   //                 context,
//                   //                 MaterialPageRoute(
//                   //                     builder: (context) => Firebasedata()),
//                   //                 (Route<dynamic> route) => false);
//                   //           },
//                   //           child: Text(
//                   //             'Back',
//                   //             style: TextStyle(color: Colors.white),
//                   //           ),
//                   //         ))
//                   //       ],
//                   //     ))
//                 ],
//               ),
//               // color: Colors.lightBlue[400],
//             ),
//           ),
//           Expanded(
//             flex: 30,
//             child: Container(
//               decoration: BoxDecoration(
//                   border: Border(left: BorderSide(color: Colors.black))),
//               child: Column(
//                 children: [
//                   Expanded(
//                     flex: 10,
//                     child: Container(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             // crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Text(
//                                 'New order',
//                                 style: TextStyle(fontSize: 22),
//                               )
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 'Total:',
//                                 style: TextStyle(fontSize: 22),
//                               ),
//                               Text(
//                                 total == null ? totalfirstvalue : total,
//                                 style: TextStyle(fontSize: 22),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                       color: Color(0xFFc3d2eb),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 90,
//                     child: Container(
//                       child: Column(
//                         children: [
//                           Expanded(
//                               flex: 6,
//                               child: Container(
//                                 child: DefaultTabController(
//                                   length: 3, // length of tabs
//                                   initialIndex: 0,
//                                   child: TabBar(
//                                     labelPadding:
//                                         EdgeInsets.symmetric(vertical: 10),
//                                     unselectedLabelColor: Colors.grey[700],
//                                     indicatorSize: TabBarIndicatorSize.label,
//                                     indicator: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(50),
//                                         color: Colors.green),
//                                     // indicatorColor: Colors.black,
//                                     // labelColor: Colors.grey,
//                                     tabs: [
//                                       Tab(
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   new BorderRadius.only(
//                                             topRight:
//                                                 const Radius.circular(40.0),
//                                             bottomRight:
//                                                 const Radius.circular(40.0),
//                                           )),
//                                           child: Align(
//                                             alignment: Alignment.center,
//                                             child: Text("Take out"),
//                                           ),
//                                         ),
//                                       ),
//                                       Tab(
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   new BorderRadius.only(
//                                             topRight:
//                                                 const Radius.circular(40.0),
//                                             bottomRight:
//                                                 const Radius.circular(40.0),
//                                           )),
//                                           child: Align(
//                                             alignment: Alignment.center,
//                                             child: Text("Dine In"),
//                                           ),
//                                         ),
//                                       ),
//                                       Tab(
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   new BorderRadius.only(
//                                             topRight:
//                                                 const Radius.circular(40.0),
//                                             bottomRight:
//                                                 const Radius.circular(40.0),
//                                           )),
//                                           child: Align(
//                                             alignment: Alignment.center,
//                                             child: Text("Park order"),
//                                           ),
//                                         ),
//                                       ),
//                                       // Tab(text: 'ABOUT'),
//                                       // Tab(text: 'QUESTION'),
//                                     ],
//                                   ),
//                                 ),
//                                 // color: Colors.yellow,
//                               )),
//                           Expanded(
//                               flex: 74,
//                               child: Container(
//                                 child: ListView.builder(
//                                     itemCount: cartlist.length,
//                                     itemBuilder: (context, index) {
//                                       // totalfirstvalue =
//                                       //     cart[index]['price'].toString();

//                                       return cartlist.length == 0
//                                           ? Container()
//                                           : GestureDetector(
//                                               onTap: () {
//                                                 _onSelected(index);
//                                                 setState(() {
//                                                   //carttapcolor = true;
//                                                   //addmodifierlist = combodetails;
//                                                 });
//                                               },
//                                               child: Card(
//                                                 color: _selectedIndex != null &&
//                                                         _selectedIndex == index
//                                                     ? Colors.blue[100]
//                                                     : Colors.white,
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         Container(
//                                                           child: Row(
//                                                             children: [
//                                                               IconButton(
//                                                                   onPressed:
//                                                                       () {
//                                                                     setState(
//                                                                         () {
//                                                                       if (_count >
//                                                                           1) {
//                                                                         _count -=
//                                                                             1;
//                                                                         //   gettotal(combodetails);
//                                                                       }
//                                                                     });
//                                                                   },
//                                                                   icon: Icon(
//                                                                     Icons
//                                                                         .remove,
//                                                                     size: 28,
//                                                                     color: Colors
//                                                                         .green,
//                                                                   )),
//                                                               Text(
//                                                                 cartlist[index]
//                                                                     .qty
//                                                                     .toString(),
//                                                                 // combodetails['qty'].toString(),
//                                                                 // "$_count",
//                                                                 style: TextStyle(
//                                                                     fontSize:
//                                                                         20),
//                                                               ),
//                                                               IconButton(
//                                                                   onPressed:
//                                                                       () {
//                                                                     increment(
//                                                                         index);
//                                                                     setState(
//                                                                         () {
//                                                                       // _count += 1;
//                                                                       //  gettotal(combodetails['price']);
//                                                                     });
//                                                                   },
//                                                                   icon: Icon(
//                                                                     Icons.add,
//                                                                     size: 28,
//                                                                     color: Colors
//                                                                         .orange,
//                                                                   )),
//                                                               Column(
//                                                                 crossAxisAlignment:
//                                                                     CrossAxisAlignment
//                                                                         .center,
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .center,
//                                                                 children: [
//                                                                   Text(
//                                                                     cartlist[
//                                                                             index]
//                                                                         .name,
//                                                                     style: TextStyle(
//                                                                         color: Colors
//                                                                             .black,
//                                                                         fontWeight:
//                                                                             FontWeight
//                                                                                 .bold,
//                                                                         fontSize:
//                                                                             17),
//                                                                   ),
//                                                                   addmodifierlist
//                                                                               .length ==
//                                                                           0
//                                                                       ? Container()
//                                                                       : Column(
//                                                                           crossAxisAlignment:
//                                                                               CrossAxisAlignment.start,
//                                                                           children: List.generate(
//                                                                               addmodifierlist.length,
//                                                                               (index) {
//                                                                             // setState(() {
//                                                                             //   modifierprice = addmodifierlist[index]['price'];
//                                                                             // });
//                                                                             // print(modifierprice);
//                                                                             return Text(
//                                                                               addmodifierlist[index]['name'],

//                                                                               // combodetails.modify[index].modifiername,
//                                                                               style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
//                                                                             );
//                                                                           }),
//                                                                         ),
//                                                                 ],
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             // addmodifierlist.length == 0
//                                                             //     ? Text('\$${_count * combodetails['price']}',
//                                                             //         style: TextStyle(
//                                                             //             color: Colors.black,
//                                                             //             fontWeight: FontWeight.bold,
//                                                             //             fontSize: 15))
//                                                             //     : Text(
//                                                             //         '\$${_count * (combodetails['price'] + addmodifierlist[index]['price'])}',
//                                                             //         style: TextStyle(
//                                                             //             color: Colors.black,
//                                                             //             fontWeight: FontWeight.bold,
//                                                             //             fontSize: 15)),
//                                                             Text(
//                                                                 '\$${cartlist[index].price}',
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .black,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold,
//                                                                     fontSize:
//                                                                         15)),
//                                                             IconButton(
//                                                                 onPressed: () {
//                                                                   deleteitem(
//                                                                       cartlist[
//                                                                               index]
//                                                                           .id);
//                                                                 },
//                                                                 icon: Icon(
//                                                                   Icons.delete,
//                                                                   size: 23,
//                                                                   color: Colors
//                                                                       .red,
//                                                                 ))
//                                                             //  Text('\$${_count * combodetails['price']}'),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),

//                                                     // addproduct(combodetails.id)
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                       // Container(
//                                       //     color: _selectedIndex != null &&
//                                       //             _selectedIndex == index
//                                       //         ? Colors.red
//                                       //         : Colors.white,
//                                       //     child:
//                                       //   _addcombolist(cart[index], index);
//                                       //  );
//                                     }),
//                                 color: Colors.white,
//                               )),
//                           Expanded(
//                               flex: 10,
//                               child: Container(
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   children: [
//                                     Expanded(
//                                         flex: 10,
//                                         child: Container(
//                                             height: 60,
//                                             child: RaisedButton(
//                                               color: Colors.red,
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             Paymentmode()));
//                                               },
//                                               child: Text('Pay',
//                                                   style: TextStyle(
//                                                       color: Colors.white)),
//                                             ))),
//                                     Expanded(
//                                         flex: 10,
//                                         child: Container(
//                                             height: 60,
//                                             child: RaisedButton(
//                                               color: Colors.green,
//                                               onPressed: () {},
//                                               child: Text(
//                                                 'Park',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                             ))),
//                                   ],
//                                 ),
//                                 // color: Colors.green,
//                               ))
//                         ],
//                       ),
//                       color: Colors.white,
//                     ),
//                   )
//                 ],
//               ),
//               // color: Colors.yellow,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   var backbuttonlist = 0;
//   var productmodifier;
//   List cart = [];
//   var card;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: Text(
//             'Peter Nick',
//             //   userdatalist == null ? 'Loading...' : userdatalist['name'],
//             style: TextStyle(color: Colors.black),
//           ),
//           actions: [
//             Row(
//               children: [
//                 FlatButton(
//                   onPressed: () {
//                     setState(() {
//                       // ordercomment = 1;
//                     });
//                   },
//                   child: Text('Order comment'),
//                 ),
//                 FlatButton(
//                   onPressed: () {
//                     // if (addmodifierlist.id != null) {
//                     //   _displayDialog();
//                     //   setState(() {
//                     //     commenttextID = addmodifierlist.id;
//                     //   });
//                     // } else {
//                     //   return null;
//                     // }

//                     // if (addmodifierlist.id ) {
//                     //   setState(() {
//                     //     ordercomment = 2;
//                     //   });
//                     //   print(ordercomment);
//                     // } else {
//                     //   setState(() {
//                     //     ordercomment = 0;
//                     //   });
//                     // }
//                   },
//                   child: Text('Product comment'),
//                 ),
//                 IconButton(
//                     color: Colors.black,
//                     onPressed: () async {
//                       SharedPreferences preferences =
//                           await SharedPreferences.getInstance();
//                       preferences.remove("userid");

//                       Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => LoginScreen()),
//                           (route) => false);
//                     },
//                     icon: Icon(Icons.power_settings_new_rounded))
//               ],
//             )
//           ],
//         ),
//         body: getdata()
//         // Column(
//         //   crossAxisAlignment: CrossAxisAlignment.start,
//         //   children: [
//         //     new Row(
//         //       children: <Widget>[
//         //         Expanded(
//         //           child: SizedBox(
//         //             height: 100.0,
//         //             child: new ListView.builder(
//         //               scrollDirection: Axis.horizontal,
//         //               itemCount:
//         //                   categorylist.length == 0 ? 0 : categorylist.length,
//         //               itemBuilder: (BuildContext ctxt, int index) {
//         //                 return new Card(
//         //                     child: Container(
//         //                   color: Colors.blue,
//         //                   width: 120,
//         //                   child: Center(
//         //                       child: Text(
//         //                     categorylist[index]['name'],
//         //                     style: TextStyle(
//         //                       color: Colors.white,
//         //                       fontSize: 17.0,
//         //                       fontWeight: FontWeight.bold,
//         //                     ),
//         //                   )),
//         //                 ));
//         //                 //Text(categorylist[index]['name']);
//         //               },
//         //             ),
//         //           ),
//         //         ),
//         //       ],
//         //     ),
//         //     // Container(
//         //     //     height: 200,
//         //     //     child: ListView.builder(
//         //     //         scrollDirection: Axis.horizontal,
//         //     //         itemCount:
//         //     //             categorylist.length == 0 ? 0 : categorylist.length,
//         //     //         itemBuilder: (BuildContext context, int index) {
//         //     //           return GestureDetector(
//         //     //               onTap: () {
//         //     //                 productlist.clear();
//         //     //                 fbproductlis(categorylist[index]);
//         //     //                 //  categorylist[index]
//         //     //               },
//         //     //               child: Card(
//         //     //                 child: ListTile(
//         //     //                   title: Text(categorylist[index]['name']),
//         //     //                   // subtitle: Text(productlist.length == 0
//         //     //                   //     ? 'data'
//         //     //                   //     : productlist[index]['name']),
//         //     //                 ),
//         //     //               ));
//         //     //         })
//         //     //         ),
//         //     Text(
//         //       'Products',
//         //       style: TextStyle(fontSize: 20),
//         //     ),
//         //     Expanded(
//         //         child: Container(
//         //             height: 100,
//         //             child: ListView.builder(
//         //                 shrinkWrap: true,
//         //                 itemCount:
//         //                     productlist.length == 0 ? 0 : productlist.length,
//         //                 itemBuilder: (BuildContext context, int index) {
//         //                   return GestureDetector(
//         //                       onTap: () {
//         //                         setState(() {
//         //                           card = productlist[index];
//         //                         });
//         //                         cart.add(card);
//         //                       },
//         //                       child: Card(
//         //                         child: ListTile(
//         //                           title: Text(productlist[index]['name']),
//         //                           // subtitle: Text(productlist.length == 0
//         //                           //     ? 'data'
//         //                           //     : productlist[index]['name']),
//         //                         ),
//         //                       ));
//         //                 }))),
//         //     Text(
//         //       'Cart List',
//         //       style: TextStyle(fontSize: 20),
//         //     ),
//         //     Expanded(
//         //         child: Container(
//         //             height: 100,
//         //             child: ListView.builder(
//         //                 shrinkWrap: true,
//         //                 itemCount: cart.length == 0 ? 0 : cart.length,
//         //                 itemBuilder: (BuildContext context, int index) {
//         //                   return GestureDetector(
//         //                       onTap: () {
//         //                         fetchcategory(productlist[index]);
//         //                         //  productlist[index]
//         //                       },
//         //                       child: Card(
//         //                         child: ListTile(
//         //                           title: Text(cart[index]['name']),
//         //                           // subtitle: Text(productlist.length == 0
//         //                           //     ? 'data'
//         //                           //     : productlist[index]['name']),
//         //                         ),
//         //                       ));
//         //                 }))),
//         //   ],
//         // )
//         );
//   }
// }
