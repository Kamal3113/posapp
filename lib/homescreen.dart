import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:posbillingapp/data/data.dart';
import 'package:posbillingapp/drawer.dart';
import 'package:posbillingapp/login.dart';
import 'package:posbillingapp/payment.dart';
import 'package:posbillingapp/payment/paymentscreen.dart';
import 'package:posbillingapp/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  final String name;
  Homescreen({ this.name});
  // const mainpage({ Key? key }) : super(key: key);

  @override
  _mainpageState createState() => _mainpageState();
}

class _mainpageState extends State<Homescreen> {
  void initState() {
    super.initState();
    getappid();
  }

  TextEditingController productcomment = TextEditingController();
  var itemlist;
  var product;
  var modifierlist;
  List cart = [];
 String email;
  settext() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.02;
    double multiplier = 1;
    return Text(
      'New Order',
      style: TextStyle(
        color: Colors.black,
        fontSize: multiplier * unitHeightValue,
      ),
    );
  }

  setTOTALtext() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.03;
    double multiplier = 1;
    return Text(
      'Total:',
      style: TextStyle(
        color: Colors.black,
        fontSize: multiplier * unitHeightValue,
      ),
    );
  }

  setpricetext() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.02;
    double multiplier = 1.2;
    return Text(
      '\$2046.00',
      style: TextStyle(
        color: Colors.black,
        fontSize: multiplier * unitHeightValue,
      ),
    );
  }

  var productcommentshow = '';
  _displayDialog() async {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return Container(
                    height: height - 600,
                    width: width - 600,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Text(
                            'ADD COMMENT',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextField(
                          autofocus: true,
                          controller: productcomment,
                          decoration:
                              InputDecoration(hintText: "Product Comment"),
                        ),
                        RaisedButton(
                          onPressed: () {
                            setState(() {
                              productcommentshow = productcomment.text;
                            });
                            Navigator.pop(context);
                            productcomment.clear();
                          },
                          child: Text('SUBMIT'),
                        )
                      ],
                    ),
                  );
                },
              ),
            ));
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text('Add Comment'),
    //         content: TextField(
    //           autofocus: true,
    //           controller: productcomment,
    //           decoration: InputDecoration(hintText: "Product Comment"),
    //         ),
    //         actions: <Widget>[
    //           new FlatButton(
    //             child: new Text('SUBMIT'),
    //             onPressed: () {
    //               // commentlist.pdcommments
    //               //     .add(commentlist.pdcommments[0].productcomment.text);

    //               // print(commentlist);
    //               Navigator.pop(context);
    //               productcomment.clear();
    //             },
    //           )
    //         ],
    //       );
    //     });
  }
  // setdatetext() {
  //   double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  //   double multiplier = 2;
  //   return Text(
  //     '22-04-2021',
  //     style: TextStyle(
  //       color: Colors.black,
  //       fontSize: multiplier * unitHeightValue,
  //     ),
  //   );
  // }

  deleteitem(int selected_id) {
    for (int i = 0; i < cart.length; i++) {
      if (selected_id == cart[i].id) {
        if (mounted)
          setState(() {
            cart.remove(cart[i]);
          });
      }
    }
  }

  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  bool carttapcolor = false;
  int _count = 1;
  var addmodifierlist;
  _addcombolist(var combodetails, int index) {
    return GestureDetector(
      onTap: () {
        _onSelected(index);
        setState(() {
          carttapcolor = true;
          addmodifierlist = combodetails;
        });
      },
      child: Card(
        color: _selectedIndex != null && _selectedIndex == index
            ? Colors.blue[100]
            : Colors.white,
        // color: _selectedIndex != null && _selectedIndex == index
        //       ? Colors.red
        //       : Colors.white,
        // color: carttapcolor ? Colors.yellow : Colors.pink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (_count > 1) {
                                _count -= 1;
                              }
                            });
                          },
                          icon: Icon(
                            Icons.remove,
                            size: 20,
                            color: Colors.green,
                          )),
                      Text(
                        "$_count",
                        style: TextStyle(fontSize: 20),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _count += 1;
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.orange,
                          )),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(combodetails.name),
                    Text('\$${_count * combodetails.price}'),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      deleteitem(combodetails.id);
                    },
                    icon: Icon(
                      Icons.delete,
                      size: 23,
                      color: Colors.red,
                    ))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(combodetails.modify.length, (index) {
                return Text(
                  combodetails.modify[index].modifiername,
                  style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                );
              }),
            ),
            // ordercomment != 1
            //     ? Text('')
            //     : TextFormField(
            //         decoration: InputDecoration(
            //           border: OutlineInputBorder(),
            //           labelText: " Order Comment",
            //         ),
            //         //maxLines: 5,
            //       ),
            addproduct(combodetails.id)
            // commenttextID != combodetails.id
            //     ? Text('')
            //     : Text(productcomment.text)
          ],
        ),
      ),
    );
  }

  addproduct(int id) {
    if (commenttextID == id) {
      return Text(productcommentshow);
    } else {
      return Container();
    }
  }

  getappid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString("email").toString();
    });
    fetchAllContact();
  }

  var commenttextID;
  var userdatalist;
  Future<List> fetchAllContact() async {
    List contactList = [];
    var documentSnapshot =
        await FirebaseFirestore.instance.collection(email).get().then((vl) {
      vl.docs.forEach((f) {
        print(f.data()['name']);
        setState(() {
          userdatalist = f.data();
        });
        print(userdatalist);
        FirebaseFirestore.instance
            .collection(email)
            .doc(f.id)
            .collection('category')
            .get()
            .then((vl) {
          vl.docs.forEach((ff) {
            print(ff.data()['category_name']);
          });
        });
      });
    });

    //     .doc()
    //     .get();
    // contactList = documentSnapshot.data.['category_name'];
    return contactList;
  }

  List detailmod = [];
  var detailmodifierlist = [];
  getdate(var data, int index1) {
    if (restaurants[0].menu[index1].modifylist[index1] == null) {
      return null;
    } else {
      setState(() {
        detailmod = restaurants[0].menu[index1].modifylist;
      });
      print(detailmod);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             Testscreen(
      //                 modifiertemplate:
      //                     restaurants[0]
      //                         .menu[index1]
      //                         .modifylist)));
    }
  }

  int ordercomment = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     icon: Icon(
          //       Icons.arrow_back,
          //       color: Colors.black,
          //     )),
          backgroundColor: Colors.white,
          title: Text(
            userdatalist == null ? 'Loading...' : userdatalist['name'],
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Row(
              children: [
                FlatButton(
                  onPressed: () {
                    setState(() {
                      ordercomment = 1;
                    });
                  },
                  child: Text('Order comment'),
                ),
                FlatButton(
                  onPressed: () {
                    if (addmodifierlist.id != null) {
                      _displayDialog();
                      setState(() {
                        commenttextID = addmodifierlist.id;
                      });
                    } else {
                      return null;
                    }

                    // if (addmodifierlist.id ) {
                    //   setState(() {
                    //     ordercomment = 2;
                    //   });
                    //   print(ordercomment);
                    // } else {
                    //   setState(() {
                    //     ordercomment = 0;
                    //   });
                    // }
                  },
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
         drawer: Drawer(
        child: MainDrawer(),
      ),
        body: getalldata());
  }

  getmodifierlist() {
    if (detailmod.length == 0) {
      return Expanded(
          flex: 80,
          child: Container(
            child: GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1.3,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                ),
                shrinkWrap: true,
                itemCount: product == null
                    ? restaurants[0].menu.length
                    : product.menu.length,
                itemBuilder: (BuildContext context1, int index1) {
                  return GestureDetector(
                      onTap: () {
                        if (product == null) {
                          setState(() {
                            itemlist = restaurants[0].menu[index1];
                          });
                          cart.add(itemlist);
                          getdate(restaurants[0].menu, index1);
                          // if (restaurants[0]
                          //         .menu[index1]
                          //         .modifylist[index1] ==
                          //     null) {
                          //   return null;
                          // } else {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               Testscreen(
                          //                   modifiertemplate:
                          //                       restaurants[0]
                          //                           .menu[index1]
                          //                           .modifylist)));
                          // }

                        } else {
                          setState(() {
                            itemlist = product.menu[index1];
                          });
                          cart.add(itemlist);
                          getdate(product.menu[index1], index1);
                          // if (product.menu[index1]
                          //         .modifylist[index1] ==
                          //     null) {
                          //   return null;
                          // } else {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               Testscreen(
                          //                   modifiertemplate:
                          //                       restaurants[0]
                          //                           .menu[
                          //                               index1]
                          //                           .modifylist)));
                          // }

                        }
                      },
                      child: Card(
                          child: Container(
                        color: product == null
                            ? restaurants[0].menu[index1].color
                            : product.menu[index1].color,
                        child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Text(
                                product == null
                                    ? restaurants[0].menu[index1].name
                                    : product.menu[index1].name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                product == null
                                    ? '\$${restaurants[0].menu[index1].price.toString()}'
                                    : '\$${product.menu[index1].price.toString()} ',
                                //  '\$${product.menu[index1].price.toString()} ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ])),
                      )));
                }),
            color: Colors.white,
          ));
    } else if (detailmodifierlist.isNotEmpty) {
      return Expanded(
          flex: 80,
          child: Container(
            child: GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1.3,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                ),
                shrinkWrap: true,
                itemCount: detailmodifierlist.length == 0
                    ? detailmodifierlist[0].length
                    : detailmodifierlist.length,
                itemBuilder: (BuildContext context1, int index1) {
                  return GestureDetector(
                      onTap: () {
                        if (product == null) {
                          setState(() {
                            itemlist = restaurants[0].menu[index1];
                          });
                          getdate(restaurants[0].menu, index1);

                          cart.add(itemlist);
                        } else {
                          setState(() {
                            itemlist = product.menu[index1];
                          });
                          // if (product.menu[index1]
                          //         .modifylist[index1] ==
                          //     null) {
                          //   return null;
                          // } else {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               Testscreen(
                          //                   modifiertemplate:
                          //                       restaurants[0]
                          //                           .menu[
                          //                               index1]
                          //                           .modifylist)));
                          // }
                          cart.add(itemlist);
                        }
                      },
                      child: Card(
                          child: Container(
                        color: detailmodifierlist == null
                            ? detailmodifierlist[0].color
                            : detailmodifierlist[index1].color,
                        child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Text(
                                detailmodifierlist == null
                                    ? detailmodifierlist[0].name
                                    : detailmodifierlist[index1].name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                product == null
                                    ? '\$${detailmodifierlist[0].price.toString()}'
                                    : '\$${detailmodifierlist[index1].price.toString()} ',
                                //  '\$${product.menu[index1].price.toString()} ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ])),
                      )));
                }),
            color: Colors.white,
          ));
    } else {
      return Expanded(
          flex: 80,
          child: Container(
            child: GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1.3,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                ),
                shrinkWrap: true,
                itemCount: detailmod[0].pdtmodifylist == null
                    ? 0
                    : detailmod[0].pdtmodifylist.length,
                itemBuilder: (BuildContext context1, int index1) {
                  return GestureDetector(
                      onTap: () {
                        // if (product == null) {
                        //   setState(() {
                        //     itemlist = restaurants[0].menu[index1];
                        //   });
                        //   getdate(restaurants[0].menu, index1);

                        //   cart.add(itemlist);
                        // } else {
                        //   setState(() {
                        //     itemlist = product.menu[index1];
                        //   });
                        //   // if (product.menu[index1]
                        //   //         .modifylist[index1] ==
                        //   //     null) {
                        //   //   return null;
                        //   // } else {
                        //   //   Navigator.push(
                        //   //       context,
                        //   //       MaterialPageRoute(
                        //   //           builder: (context) =>
                        //   //               Testscreen(
                        //   //                   modifiertemplate:
                        //   //                       restaurants[0]
                        //   //                           .menu[
                        //   //                               index1]
                        //   //                           .modifylist)));
                        //   // }
                        //   cart.add(itemlist);
                        // }
                      },
                      child: Card(
                          child: Container(
                        color: detailmod[0].pdtmodifylist[index1].color,
                        child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Text(
                                detailmod[0].pdtmodifylist[index1].name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${detailmod[0].pdtmodifylist[index1].price.toString()} ',
                                //  '\$${product.menu[index1].price.toString()} ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ])),
                      )));
                }),
            color: Colors.white,
          ));
    }
    // detailmodifierlist.length == 0
    //     ?
    // : Expanded(
    //     flex: 80,
    //     child: Container(
    //       child: GridView.builder(
    //           gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
    //             crossAxisCount: 5,
    //             childAspectRatio: 1.3,
    //             mainAxisSpacing: 0,
    //             crossAxisSpacing: 0,
    //           ),
    //           shrinkWrap: true,
    //           itemCount: detailmodifierlist.length == 0
    //               ? detailmodifierlist[0].length
    //               : detailmodifierlist.length,
    //           itemBuilder: (BuildContext context1, int index1) {
    //             return GestureDetector(
    //                 onTap: () {
    //                   if (product == null) {
    //                     setState(() {
    //                       itemlist = restaurants[0].menu[index1];
    //                     });
    //                     getdate(restaurants[0].menu, index1);

    //                     cart.add(itemlist);
    //                   } else {
    //                     setState(() {
    //                       itemlist = product.menu[index1];
    //                     });
    //                     // if (product.menu[index1]
    //                     //         .modifylist[index1] ==
    //                     //     null) {
    //                     //   return null;
    //                     // } else {
    //                     //   Navigator.push(
    //                     //       context,
    //                     //       MaterialPageRoute(
    //                     //           builder: (context) =>
    //                     //               Testscreen(
    //                     //                   modifiertemplate:
    //                     //                       restaurants[0]
    //                     //                           .menu[
    //                     //                               index1]
    //                     //                           .modifylist)));
    //                     // }
    //                     cart.add(itemlist);
    //                   }
    //                 },
    //                 child: Card(
    //                     child: Container(
    //                   color: detailmodifierlist == null
    //                       ? detailmodifierlist[0].color
    //                       : detailmodifierlist[index1].color,
    //                   child: Center(
    //                       child: Column(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                         Text(
    //                           detailmodifierlist == null
    //                               ? detailmodifierlist[0].name
    //                               : detailmodifierlist[index1].name,
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                             fontSize: 17.0,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         ),
    //                         Text(
    //                           product == null
    //                               ? '\$${detailmodifierlist[0].price.toString()}'
    //                               : '\$${detailmodifierlist[index1].price.toString()} ',
    //                           //  '\$${product.menu[index1].price.toString()} ',
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                             fontSize: 17.0,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         )
    //                       ])),
    //                 )));
    //           }),
    //       color: Colors.white,
    //     ));
  }

  getalldata() {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 70,
            child: Container(
              child: Column(
                children: [
                  detailmod.length == 0
                      ? Expanded(
                          flex: 10,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.black))),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: restaurants.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          product = restaurants[index];
                                          modifierlist = restaurants[index];
                                        });
                                      },
                                      child: Card(
                                          child: Container(
                                        color: restaurants[index].color,
                                        width: 120,
                                        child: Center(
                                            child: Text(
                                          restaurants[index].name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                      )));
                                }),
                            // color: Colors.white,
                          ))
                      : Expanded(
                          flex: 10,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.black))),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: detailmod.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          detailmodifierlist =
                                              detailmod[index].pdtmodifylist;
                                        });
                                      },
                                      child: Card(
                                          child: Container(
                                        color: detailmod[index].color,
                                        width: 120,
                                        child: Center(
                                            child: Text(
                                          detailmod[index].name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                      )));
                                }),
                            // color: Colors.white,
                          )),
                  getmodifierlist(),
                  detailmod.length == 0
                      ? Expanded(
                          flex: 10,
                          child: Container(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: modifierlist == null
                                    ? restaurants[0].modify.length
                                    : modifierlist.modify.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        if (modifierlist == null) {
                                          if (addmodifierlist == null) {
                                            return addmodifierlist;
                                          } else {
                                            setState(() {
                                              addmodifierlist.modify.add(
                                                  restaurants[0].modify[index]);
                                            });
                                          }
                                        } else {
                                          if (addmodifierlist == null) {
                                            return addmodifierlist;
                                          } else {
                                            setState(() {
                                              addmodifierlist.modify.add(
                                                  modifierlist.modify[index]);
                                            });
                                          }
                                        }
                                      },
                                      child: Card(
                                          child: Container(
                                        color: modifierlist == null
                                            ? restaurants[0].modify[index].color
                                            : modifierlist.modify[index].color,
                                        width: 120,
                                        child: Center(
                                            child: Text(
                                          modifierlist == null
                                              ? restaurants[0]
                                                  .modify[index]
                                                  .modifiername
                                              : modifierlist
                                                  .modify[index].modifiername,
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
                      : Expanded(
                          flex: 10,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                  // height: 60,
                                  child: RaisedButton(
                                color: Colors.red,
                                onPressed: () {
                                  // detailmod.clear();
                                  // detailmodifierlist.clear();
                                  Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Homescreen(
                                                    name: '',
                                                  )),
                                          (route) => false)
                                      .whenComplete(getmodifierlist());
                                  // Navigator.of(context)
                                  // .push(new MaterialPageRoute(
                                  //     builder: (context) => Mainpage1(
                                  //           name: '',
                                  //         )))
                                  // .whenComplete(getmodifierlist());
                                  // setState(() {
                                  //    restaurants.add(1);
                                  // });
                                  // getmodifierlist();
                                },
                                child: Text(
                                  'Back',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                            ],
                          ))
                ],
              ),
              // color: Colors.lightBlue[400],
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
                                'New Order',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 22),
                              )
                              //    settext()
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Toatl:',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              Text(
                                '₹2340000',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),

                              // setTOTALtext(), setpricetext()
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
                                    itemCount: cart.length,
                                    itemBuilder: (context, index) {
                                      return
                                          // Container(
                                          //     color: _selectedIndex != null &&
                                          //             _selectedIndex == index
                                          //         ? Colors.red
                                          //         : Colors.white,
                                          //     child:
                                          _addcombolist(cart[index], index);
                                      //  );
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
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             Paymentmode()));
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
                                              onPressed: () {},
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
}

// fetchdata()async{
//  await FirebaseFirestore.instance
//         .collection('Kamal@techsapphire.net')
//         .get()
//         .then((vl) {
//       vl.docs.forEach((f) {
//         print(f.data()['category_name']);
//         FirebaseFirestore.instance
//             .collection('Kamal@techsapphire.net')
//             .doc(f.id)
//             .collection('category')
//             .get()
//             .then((vl) {
//           vl.docs.forEach((ff) {
//             print(ff.data()['category_name']);
//           });
//         });
//       });
//     });
// }
