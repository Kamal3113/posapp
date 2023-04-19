import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:posbillingapp/list/cart.dart';
import 'package:posbillingapp/list/cartmodifierlist.dart';
import 'package:posbillingapp/list/recalllist.dart';
import 'package:posbillingapp/login.dart';

import 'package:posbillingapp/recall.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'payment/paymentscreen.dart';

class Firebasedata extends StatefulWidget {
  List<Recalllist> recalldata;
  Firebasedata({this.recalldata});

  @override
  _FirebasedataState createState() => _FirebasedataState();
}

class _FirebasedataState extends State<Firebasedata> {
  void initState() {
    super.initState();
    getappid();
  }

  nodataAlert(context) {
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
      type: AlertType.info,
      title: "Add Product",
      desc: "Add product to proceed payment.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  var modifierlist;
 String email;
  getappid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString("email").toString();
    });
    fetchAllCategory();
  }

  double addmodifierprice = 0.0;
  double modifierprice = 0.0;
  // double? modifierprice;
  var cartproduct;
  List categorylist = [];
  List productlist = [];
  List openappproductlist = [];
  List productmodifierlist = [];
  var userdatalist;
  fetchAllCategory() async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('dhoni@gmail.com')
        .get()
        .then((vl) {
      vl.docs.forEach((f) {
        print(f.data()['name']);
        setState(() {
          userdatalist = f;
        });
        print(userdatalist);
        FirebaseFirestore.instance
            .collection('dhoni@gmail.com')
            .doc(f.id)
            .collection('category')
            .get()
            //     .then((dd) {
            //   categorylist = dd.data();l
            // });
            .then((vl) {
          vl.docs.forEach((ff) {
            setState(() {
              categorylist.add(ff.data());
              pointlist.add(ff.data()['modifier']);
            });
          });
          return categorylist;
        });
      });
    });
    openappshowproducts();
    // return categorylist;
  }

  fetchcategory(var pdtdata) async {
    FirebaseFirestore.instance
        .collection('dhoni@gmail.com')
        .doc(userdatalist.id)
        .collection('category')
        .doc(pdtdata['id'])
        .collection('product')
        .get()
        .then((pdtval) {
      pdtval.docs.forEach((pdt) {
        setState(() {
          productlist.add(pdt.data());
        });
        print(productlist);
      });
      return productlist;
    });
  }

  openappshowproducts() async {
    return FirebaseFirestore.instance
        .collection('dhoni@gmail.com')
        .doc(userdatalist.id)
        .collection('product')
        .where('cat_id', isEqualTo: 'ctg_bread_dhoni')
        .snapshots()
        .listen((data) => data.docChanges.forEach((dd) {
              setState(() {
                productlist.add(dd.doc);

                //  pointlist = List.from(dd.doc['']);
              });
            }
                // => print(doc.doc['name'])
                ));
  }

  deleteitem(String selectedid) {
    for (int i = 0; i < cartlist.length; i++) {
      if (selectedid == cartlist[i].id) {
        if (mounted)
          setState(() {
            cartlist.remove(cartlist[i]);
          });
      }
    }
  }

  int _count = 1;
  List pointlist = [];
  fbproductlis(var pdata) {
    FirebaseFirestore.instance
        .collection('dhoni@gmail.com')
        .doc(userdatalist.id)
        .collection('product')
        .where('cat_id', isEqualTo: pdata['id'])
        .snapshots()
        .listen((data) => data.docChanges.forEach((dd) {
              setState(() {
                productlist.add(dd.doc);

                //  pointlist = List.from(dd.doc['']);
              });
            }
                // => print(doc.doc['name'])
                ));
  }

  fbmodifierlist(var pdata) {
    FirebaseFirestore.instance
        .collection('dhoni@gmail.com')
        .doc(userdatalist.id)
        .collection('menugroup')
        .where('pdt_id', isEqualTo: pdata.id)
        .snapshots()
        .listen((data) => data.docChanges.forEach((dd) {
              setState(() {
                productmodifierlist.add(dd.doc);

                //  pointlist = List.from(dd.doc['']);
              });
              print(productmodifierlist);
            }
                // => print(doc.doc['name'])
                ));
  }

  gettotal(int totalvalue) {
    setState(() {
      total = '\$${_count * totalvalue}';
    });
    // addmodifierlist.length == 0
    //     ? setState(() {
    //         total = '\$${_count * totalvalue}';
    //       })
    //     : setState(() {
    //         total = '\$${_count * totalvalue + addmodifierlist[0]['price']}';
    //       });
    print(total);
  }

  // gettotalfirst(int totalvalue) {
  //   setState(() {
  //     totalfirstvalue = '\$${_count * totalvalue}';
  //   });
  //   print(total);
  // }

  // String addlist = '0';
  // increment(Cartlist cartlist) {
  //   setState(() {
  //     // cartlist.qty = cartlist.qty + 1;
  //     // ignore: unnecessary_statements
  //     cartlist.qty + 1;
  //     // addlist = (cartlist.qty + 1) as String;
  //     // cartlist.qty = addlist as int;
  //   });
  //   // return cartlist.qty = addlist;
  //   print(cartlist.qty);

  //   // for (int i = 0; i < cartlist.length; i++) {
  //   //   if (id == cartlist[i].id) {
  //   //     setState(() {
  //   //       cartlist[i].qty = cartlist[i].qty + 1;
  //   //       //  _count = cart[i]['qty'] + 1;
  //   //     });
  //   //     print(cartlist[i].qty);
  //   //   }
  //   // }
  // }

  // decriment(String id) {
  //   for (int i = 0; i < cart.length; i++) {
  //     if (id == cart[i]['id']) {
  //       setState(() {
  //         if (cart[i]['qty'] > 1) {
  //           cart[i]['qty'] = cart[i]['qty'] - 1;
  //         }
  //       });
  //       print(cart[i]['qty']);
  //     }
  //   }
  // }

  // String addlist = '0';
  decrement(Cartlist cartlist) {
    if (cartlist.qty > 1) {
      setState(() {
        cartlist.qty--;
      });
      calculateTotal(cartlist);
    }
  }
// Cartlist testerdata;
  increment(Cartlist ctlist) {
    setState(() {
      ctlist.qty++;
      totalCartValue = ctlist.price * ctlist.qty;
      cartitems = Cartlist(
          id: ctlist.id,
          name: ctlist.name,
          price: totalCartValue,
          qty: ctlist.qty,
          cartmomodifylist: []);
      // ctlist.price = totalCartValue;
    });
  ctlist = cartitems;
    // setState(() {
    //   testerdata = cartitems;
    // });
    print(ctlist);
  }
  // increment(Cartlist cartlist) {
  //   setState(() {
  //     cartlist.qty++;

  //     totalCartValue = cartlist.price * cartlist.qty;
  //     cartitems = Cartlist(
  //         id: cartlist.id,
  //         name: cartlist.name,
  //         price: totalCartValue,
  //         qty: cartlist.qty,
  //         cartmomodifylist: []);
  //     // cartlist = cartitems;
  //     // cartlist.price = totalCartValue;
  //   });
  //   return cartlist;
  //   // settotal(cartitems);
  //   // calculateTotal(cartlist);
  //   // print(cartlist.qty);
  // }

  // settotal(cartitems) {
  //   setState(() {
  //     // cartlist.price = cartlist.price * cartlist.qty;
  //     cartlist.add(cartitems);
  //   });
  //   print(cartlist);
  // }

  double totalCartValue = 0;
  calculateTotal(cartlist) {
    totalCartValue = 0;
    setState(() {
      totalCartValue = cartlist.price * cartlist.qty;
      cartlist = new Cartlist(
          id: cartlist.id,
          name: cartlist.name,
          price: totalCartValue,
          qty: cartlist.qty,
          cartmomodifylist: []);
      cartlist = cartlist;
    });
    return cartlist;
    // testdata(cartlist);
    // setState(() {
    //   cartlist.forEach((f) {

    // totalCartValue = f.price;
    //  cartlist.add(totalCartValue)
    // });

    // });

    // modifierprice = totalCartValue;
    // setState(() {
    //   modifierprice = totalCartValue;
    // });
    print(cartlist);
  }

  testdata(cartlist) {
    setState(() {
      return cartlist;
    });
    // return cartlist;
  }

  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  // var modifierprice;
  List addmodifierlist = [];
  var addcartmodifierlist;
  List testdataa = [];
  num totalfirstvalue = 0;
  String total = '0';
  // _addcombolist(List combodetails, int index) {
  //   // gettotalfirst(combodetails['price']);
  //   // setState(() {
  //   //   totalfirstvalue = combodetails['price'].toString();
  //   // });
  //   return GestureDetector(
  //     onTap: () {
  //       _onSelected(index);
  //       setState(() {
  //         //carttapcolor = true;
  //         addmodifierlist = combodetails;
  //       });
  //     },
  //     child: Card(
  //       color: _selectedIndex != null && _selectedIndex == index
  //           ? Colors.blue[100]
  //           : Colors.white,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Container(
  //                 child: Row(
  //                   children: [
  //                     IconButton(
  //                         onPressed: () {
  //                           setState(() {
  //                             if (_count > 1) {
  //                               _count -= 1;
  //                               //   gettotal(combodetails);
  //                             }
  //                           });
  //                         },
  //                         icon: Icon(
  //                           Icons.remove,
  //                           size: 28,
  //                           color: Colors.green,
  //                         )),
  //                     Text(
  //                       // combodetails['qty'].toString(),
  //                       "$_count",
  //                       style: TextStyle(fontSize: 20),
  //                     ),
  //                     IconButton(
  //                         onPressed: () {
  //                           // increment(combodetails.id);
  //                           setState(() {
  //                             // _count += 1;
  //                             //  gettotal(combodetails['price']);
  //                           });
  //                         },
  //                         icon: Icon(
  //                           Icons.add,
  //                           size: 28,
  //                           color: Colors.orange,
  //                         )),
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         // Text(
  //                         //   combodetails['name'],
  //                         //   style: TextStyle(
  //                         //       color: Colors.black,
  //                         //       fontWeight: FontWeight.bold,
  //                         //       fontSize: 17),
  //                         // ),
  //                         addmodifierlist.length == 0
  //                             ? Container()
  //                             : Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: List.generate(
  //                                     addmodifierlist.length, (index) {
  //                                   // setState(() {
  //                                   //   modifierprice = addmodifierlist[index]['price'];
  //                                   // });
  //                                   // print(modifierprice);
  //                                   return Text(
  //                                     addmodifierlist[index]['name'],

  //                                     // combodetails.modify[index].modifiername,
  //                                     style: TextStyle(
  //                                         color: Colors.red,
  //                                         fontWeight: FontWeight.bold,
  //                                         fontSize: 15),
  //                                   );
  //                                 }),
  //                               ),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               Row(
  //                 children: [
  //                   // addmodifierlist.length == 0
  //                   //     ? Text('\$${_count * combodetails['price']}',
  //                   //         style: TextStyle(
  //                   //             color: Colors.black,
  //                   //             fontWeight: FontWeight.bold,
  //                   //             fontSize: 15))
  //                   //     : Text(
  //                   //         '\$${_count * (combodetails['price'] + addmodifierlist[index]['price'])}',
  //                   //         style: TextStyle(
  //                   //             color: Colors.black,
  //                   //             fontWeight: FontWeight.bold,
  //                   //             fontSize: 15)),
  //                   // Text('\$${_count * combodetails['price']}',
  //                   //     style: TextStyle(
  //                   //         color: Colors.black,
  //                   //         fontWeight: FontWeight.bold,
  //                   //         fontSize: 15)),
  //                   IconButton(
  //                       onPressed: () {
  //                         //    deleteitem(combodetails.id);
  //                       },
  //                       icon: Icon(
  //                         Icons.delete,
  //                         size: 23,
  //                         color: Colors.red,
  //                       ))
  //                   //  Text('\$${_count * combodetails['price']}'),
  //                 ],
  //               ),
  //             ],
  //           ),

  //           // addproduct(combodetails.id)
  //         ],
  //       ),
  //     ),
  //   );
  // }
  showmodifierlist(CartModifierlist list) {
    if (list.id.contains(list.id)) {
      return Text('data');
    } else {
      return Text(list.name);
    }

    // for (int i = 0; i > list.length; i++) {
    //   if (list[i].id == list[i].id) {
    //     return Text('data');
    //   } else {
    //     return Text(
    //       list.length == 0 ? 'qw' : list[i].name,
    //       // cartlist[1].cartmomodifylist[indexx].name,
    //       style: TextStyle(
    //           color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
    //     );
    //   }
    // }
  }

  getproductmodifierlist() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: cartproduct == null ? 1 : cartproduct['modifier'].length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  cartmodifieritems = CartModifierlist(
                      id: cartproduct['modifier'][index]['pdt_modifier_id'],
                      name: cartproduct['modifier'][index]['name'],
                      price:
                          cartproduct['modifier'][index]['price'].toDouble());
                });
                addcartmodifierlist.cartmomodifylist.add(cartmodifieritems);
                // setState(() {
                //   cartlist.add(addcartmodifierlist);
                // });

                print(addcartmodifierlist);

                print(addmodifierlist);
              },
              child: cartproduct != null
                  ? Card(
                      child: Container(
                          color: Colors.brown,
                          // color: restaurants[index].color,
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                cartproduct == null
                                    ? ''
                                    : cartproduct['modifier'][index]['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              Center(
                                  child: Text(
                                cartproduct == null
                                    ? ''
                                    : '\$${cartproduct['modifier'][index]['price']}'
                                        .toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ],
                          )))
                  : Container());
        });
  }

  getcategorylist() {
    return Expanded(
        flex: 10,
        child: Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black))),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categorylist.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        modifierlist = categorylist[index];
                      });
                      productlist.clear();
                      fbproductlis(categorylist[index]);
                      // setState(() {
                      //   product = restaurants[index];
                      // modifierlist = restaurants[index];
                      // });
                    },
                    child: Card(
                        child: Container(
                      color: Colors.red,
                      // color: restaurants[index].color,
                      width: 120,
                      child: Center(
                          child: Text(
                        categorylist[index]['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    )));
              }),
          // color: Colors.white,
        ));
  }

  // ignore: deprecated_member_use
  List<Cartlist> cartlist = [];
  var cartitems;
  var cartmodifieritems;
  int sum = 0;
  getdata() {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 70,
            child: Container(
              child: Column(
                children: [
                  getcategorylist(),

                  Expanded(
                      flex: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 60,
                              child: Container(
                                child: GridView.builder(
                                    gridDelegate:
                                        new SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      childAspectRatio: 1.3,
                                      mainAxisSpacing: 0,
                                      crossAxisSpacing: 0,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: productlist.length == 0
                                        ? openappproductlist.length
                                        : productlist.length,
                                    //  product == null
                                    //     ? restaurants[0].menu.length
                                    //     : product.menu.length,
                                    itemBuilder:
                                        (BuildContext context1, int index1) {
                                      return GestureDetector(
                                          onTap: () {
                                            fbmodifierlist(productlist[index1]);
                                            // addcartmodifierlist.cartmomodifylist
                                            //     .clear();
                                            setState(() {
                                              cartitems = new Cartlist(
                                                  id: productlist[index1].id,
                                                  name: productlist[index1]
                                                      ['name'],
                                                  price: productlist[index1]
                                                          ['price']
                                                      .toDouble(),
                                                  qty: productlist[index1]
                                                      ['qty'],
                                                  cartmomodifylist: []);
                                            });

                                            //    productmodifier = productlist[index1];
                                            cartproduct = productlist[index1];

                                            cartlist.add(cartitems);
                                            addcartmodifierlist.clear();
                                          },
                                          child: Card(
                                              child: Container(
                                            color: Colors.purple,
                                            // color: product == null
                                            //     ? restaurants[0].menu[index1].color
                                            //     : product.menu[index1].color,
                                            child: Center(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                  Text(
                                                    productlist.length == 0
                                                        ? openappproductlist[
                                                            index1]['name']
                                                        : productlist[index1]
                                                            ['name'],
                                                    // product == null
                                                    //     ? restaurants[0]
                                                    //         .menu[index1]
                                                    //         .name
                                                    //     : product.menu[index1].name,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    productlist.length == 0
                                                        ? '\$${openappproductlist[index1]['price'].toString()}'
                                                        : '\$${productlist[index1]['price'].toString()} ',
                                                    //  '\$${product.menu[index1].price.toString()} ',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ])),
                                          )));
                                    }),
                                color: Colors.white,
                              )),
                          Expanded(
                              flex: 10,
                              child: Container(child: getproductmodifierlist()))
                        ],
                      )),
                  // productmodifierlist.length == 0
                  //     ?
                  Expanded(
                      flex: 10,
                      child: Container(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: modifierlist == null
                                ? 1
                                //categorylist[0]['modifier'].length
                                : modifierlist['modifier'].length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                      child: Container(
                                    color: Colors.blue,
                                    // color: modifierlist == null
                                    //     ? restaurants[0].modify[index].color
                                    //     : modifierlist.modify[index].color,
                                    width: 120,
                                    child: Center(
                                        child: Text(
                                      modifierlist == null
                                          ? 'cherry'
                                          //pointlist[index][index]['name']
                                          // categorylist[0]['modifier'][0]
                                          //     ['name']
                                          : modifierlist['modifier'][index]
                                              ['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                  )));
                            }),
                        // color: Colors.pink,
                      ))
                ],
              ),
            ),
          ),
          Expanded(
            flex: 30,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.black))),
              child: Column(
                children: [
                  Expanded(
                    flex: 10,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'New order',
                                style: TextStyle(fontSize: 22),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Total:',
                                style: TextStyle(fontSize: 22),
                              ),
                              Text(
                                modifierprice == null
                                    ? '0.0'
                                    :
                                    // modifierprice.toString(),
                                    (modifierprice + totalCartValue).toString(),

                                // total == null ? totalfirstvalue : total,
                                style: TextStyle(fontSize: 22),
                              ),
                            ],
                          )
                        ],
                      ),
                      color: Color(0xFFc3d2eb),
                    ),
                  ),
                  Expanded(
                    flex: 90,
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                              flex: 6,
                              child: Container(
                                child: DefaultTabController(
                                  length: 3, // length of tabs
                                  initialIndex: 0,
                                  child: TabBar(
                                    labelPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                    unselectedLabelColor: Colors.grey[700],
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.green),
                                    // indicatorColor: Colors.black,
                                    // labelColor: Colors.grey,
                                    tabs: [
                                      Tab(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.only(
                                            topRight:
                                                const Radius.circular(40.0),
                                            bottomRight:
                                                const Radius.circular(40.0),
                                          )),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text("Take out"),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.only(
                                            topRight:
                                                const Radius.circular(40.0),
                                            bottomRight:
                                                const Radius.circular(40.0),
                                          )),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text("Dine In"),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.only(
                                            topRight:
                                                const Radius.circular(40.0),
                                            bottomRight:
                                                const Radius.circular(40.0),
                                          )),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text("Park order"),
                                          ),
                                        ),
                                      ),
                                      // Tab(text: 'ABOUT'),
                                      // Tab(text: 'QUESTION'),
                                    ],
                                  ),
                                ),
                                // color: Colors.yellow,
                              )),
                          Expanded(
                              flex: 74,
                              child: Container(
                                child: ListView.builder(
                                    itemCount: cartlist.length,
                                    itemBuilder: (context, index) {
                                      modifierprice = cartlist.fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue + element.price);

                                      print(modifierprice);
                                      // totalfirstvalue += cartlist[index].price;
                                      // print(totalfirstvalue);
                                      return cartlist.length == 0
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () {
                                                _onSelected(index);
                                                setState(() {
                                                  //carttapcolor = true;
                                                  // addcartmodifierlist.clear();
                                                  addcartmodifierlist =
                                                      cartlist[index];
                                                });
                                              },
                                              child: Card(
                                                color: _selectedIndex != null &&
                                                        _selectedIndex == index
                                                    ? Colors.blue[100]
                                                    : Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    decrement(
                                                                        cartlist[
                                                                            index]);
                                                                    // setState(
                                                                    //     () {
                                                                    //   if (_count >
                                                                    //       1) {
                                                                    //     _count -=
                                                                    //         1;
                                                                    //     //   gettotal(combodetails);
                                                                    //   }
                                                                    // });
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    size: 28,
                                                                    color: Colors
                                                                        .green,
                                                                  )),
                                                              Text(
                                                                '${cartlist[index].qty.toString()}',
                                                                // cartlist[index]
                                                                //     .qty
                                                                //     .toString(),
                                                                // combodetails['qty'].toString(),
                                                                // "$_count",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    increment(
                                                                        cartlist[
                                                                            index]);
                                                                    setState(
                                                                        () {
                                                                      // _count += 1;
                                                                      //  gettotal(combodetails['price']);
                                                                    });
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.add,
                                                                    size: 28,
                                                                    color: Colors
                                                                        .orange,
                                                                  )),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    cartlist[
                                                                            index]
                                                                        .name,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  cartlist[index]
                                                                              .cartmomodifylist
                                                                              .length ==
                                                                          0
                                                                      // addcartmodifierlist ==
                                                                      //         null
                                                                      ? Container()
                                                                      : Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: List.generate(
                                                                              cartlist[index].cartmomodifylist.length,
                                                                              //     cartlist[index].cartmomodifylist.length,
                                                                              (indexx) {
                                                                            modifierprice =
                                                                                cartlist[index].price + cartlist[index].cartmomodifylist[indexx].price;
                                                                            totalCartValue =
                                                                                modifierprice;
                                                                            testdataa =
                                                                                cartlist[index].cartmomodifylist;
                                                                            return
                                                                                // showmodifierlist(cartlist[index].cartmomodifylist[indexx]);
                                                                                Text(
                                                                              cartlist[index].cartmomodifylist[indexx].name,
                                                                              // cartlist[1].cartmomodifylist[indexx].name,
                                                                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
                                                                            );
                                                                          }),
                                                                        ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            cartlist[index]
                                                                        .cartmomodifylist
                                                                        .length ==
                                                                    0
                                                                ? Text(
                                                                    '\$${cartlist[index].qty * cartlist[index].price}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            15))
                                                                : Text(
                                                                    '\$${(modifierprice)}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            15)),
                                                            // Text(
                                                            //     '\$${cartlist[index].price}',
                                                            //     style: TextStyle(
                                                            //         color: Colors
                                                            //             .black,
                                                            //         fontWeight:
                                                            //             FontWeight
                                                            //                 .bold,
                                                            //         fontSize:
                                                            //             15)),
                                                            IconButton(
                                                                onPressed: () {
                                                                  deleteitem(
                                                                      cartlist[
                                                                              index]
                                                                          .id);
                                                                },
                                                                icon: Icon(
                                                                  Icons.delete,
                                                                  size: 23,
                                                                  color: Colors
                                                                      .red,
                                                                ))
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                    }),
                                color: Colors.white,
                              )),
                          Expanded(
                              flex: 10,
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                        flex: 10,
                                        child: Container(
                                            height: 60,
                                            child: RaisedButton(
                                              color: Colors.red,
                                              onPressed: () {
                                                cartlist.length == 0 &&
                                                        modifierprice == 0
                                                    ? nodataAlert(context)
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Paymentmode(
                                                                      selectedorders:cartlist,
                                                                      total:
                                                                          modifierprice,
                                                                    )));
                                              },
                                              child: Text('Pay',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ))),
                                    Expanded(
                                        flex: 10,
                                        child: Container(
                                            height: 60,
                                            child: RaisedButton(
                                              color: Colors.green,
                                              onPressed: () {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             Dataprint()));
                                              },
                                              child: Text(
                                                'Park',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ))),
                                  ],
                                ),
                                // color: Colors.green,
                              ))
                        ],
                      ),
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              // color: Colors.yellow,
            ),
          )
        ],
      ),
    );
  }

  var backbuttonlist = 0;
  var productmodifier;
  List cart = [];
  var card;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Peter Nick',
            //   userdatalist == null ? 'Loading...' : userdatalist['name'],
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Row(
              children: [
                FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Recallpage(
                                    recalldata: widget.recalldata,
                                  )));
                    },
                    child: Text('Recall')),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      // ordercomment = 1;
                    });
                  },
                  child: Text('Order comment'),
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text('Product comment'),
                ),
                IconButton(
                    color: Colors.black,
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.remove("userid");

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false);
                    },
                    icon: Icon(Icons.power_settings_new_rounded))
              ],
            )
          ],
        ),
        body: getdata());
  }
}
