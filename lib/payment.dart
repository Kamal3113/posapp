import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posbillingapp/payment/input.dart';
import 'package:posbillingapp/payment/payment.dart';
import 'package:posbillingapp/payment/string.dart';

class Payment extends StatefulWidget {
  final selectedorder;
  Payment({this.selectedorder});
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidateMode = AutovalidateMode.disabled;

  var _card = new PaymentCard();
  bool changecolor = false;
  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
  }

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

  dialogbox() {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(23.0))),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Container(
                          height: 100,
                          width: 420,
                          decoration: BoxDecoration(
                              color: Color(0xFF1f1338),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 25),
                                      child: Text(
                                        '\u20B9345',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      )),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 2),
                                      child: Text(
                                        'Total amount with Discount',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ))
                                ],
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    'CREDIT CARD',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ))
                            ],
                          ))),
                  new Container(
                    height: 440,
                    width: 380,
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: new Form(
                        key: _formKey,
                        autovalidateMode: _autoValidateMode,
                        child: new ListView(
                          children: <Widget>[
                            new SizedBox(
                              height: 20.0,
                            ),
                            new TextFormField(
                              decoration: const InputDecoration(
                                border: const UnderlineInputBorder(),
                                filled: true,
                                icon: const Icon(
                                  Icons.person,
                                  size: 40.0,
                                ),
                                hintText: 'What name is written on card?',
                                labelText: 'Card Name',
                              ),
                              onSaved: (String value) {
                                _card.name = value;
                              },
                              keyboardType: TextInputType.text,
                              validator: (String value) =>
                                  value.isEmpty ? Strings.fieldReq : null,
                            ),
                            new SizedBox(
                              height: 30.0,
                            ),
                            new TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(19),
                                // new CardNumberInputFormatter()
                              ],
                              controller: numberController,
                              decoration: new InputDecoration(
                                border: const UnderlineInputBorder(),
                                filled: true,
                                icon: CardUtils.getCardIcon(_paymentCard.type),
                                hintText: 'What number is written on card?',
                                labelText: 'Number',
                              ),
                              onSaved: (String value) {
                                print('onSaved = $value');
                                print(
                                    'Num controller has = ${numberController.text}');
                                _paymentCard.number =
                                    CardUtils.getCleanedNumber(value);
                              },
                              validator: CardUtils.validateCardNum,
                            ),
                            new SizedBox(
                              height: 30.0,
                            ),
                            new TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(4),
                              ],
                              decoration: new InputDecoration(
                                border: const UnderlineInputBorder(),
                                filled: true,
                                icon: new Image.asset(
                                  'assest/visa.jpg',
                                  width: 40.0,
                                  color: Colors.grey[600],
                                ),
                                hintText: 'Number behind the card',
                                labelText: 'CVV',
                              ),
                              validator: CardUtils.validateCVV,
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                _paymentCard.cvv = int.parse(value);
                              },
                            ),
                            new SizedBox(
                              height: 30.0,
                            ),
                            new TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(4),
                                // new CardMonthInputFormatter()
                              ],
                              decoration: new InputDecoration(
                                border: const UnderlineInputBorder(),
                                filled: true,
                                icon: new Image.asset(
                                  'assest/visa.jpg',
                                  width: 40.0,
                                  color: Colors.grey[600],
                                ),
                                hintText: 'MM/YY',
                                labelText: 'Expiry Date',
                              ),
                              validator: CardUtils.validateDate,
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                List<int> expiryDate =
                                    CardUtils.getExpiryDate(value);
                                _paymentCard.month = expiryDate[0];
                                _paymentCard.year = expiryDate[1];
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              height: 50,
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: RaisedButton(
                                color: Color(0xFF1f1338),
                                onPressed: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => Tester1()));
                                },
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            // new Container(
                            //   alignment: Alignment.center,
                            //   child: _getPayButton(),
                            // )
                          ],
                        )),
                  ),
                ],
              )
              // content:
              );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        // backgroundColor: Color(0xFF1f1338),
        title: Text(
          'Payment',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height * 100 / 100,
          width: MediaQuery.of(context).size.width * 100 / 100,
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 20, left: 20),
                  child: Container(
                    height: 720,
                    width: 300,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        // color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Color(0xFF1f1338),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8))),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 6, left: 30),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Selected Orders',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      SizedBox(width: 20),
                                      FlatButton(
                                          color: Colors.white,
                                          onPressed: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             Editdetails()));
                                          },
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(fontSize: 20),
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5, bottom: 2),
                          child: Container(
                              height: 600,
                              width: 400,
                              child: ListView.builder(
                                  itemCount: widget.selectedorder == null
                                      ? 4
                                      : widget.selectedorder.length,
                                  itemBuilder: (context, index) {
                                    // Restaurant cat = restaurants[index];
                                    return new GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          width: double.infinity,
                                          height: 90,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Center(
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0),
                                                    child: Container(
                                                      height: 80,
                                                      width: 80.0,
                                                      decoration: BoxDecoration(
                                                        // image: DecorationImage(
                                                        //   image: AssetImage(
                                                        //       widget
                                                        //           .selectedorder[
                                                        //               index]
                                                        //           .imageUrl),
                                                        //   fit: BoxFit.cover,
                                                        // ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    )),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Pizza',
                                                      // widget
                                                      //     .selectedorder[index]
                                                      //     .name,

                                                      // /   details[index]['name'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10),
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text('North india',
                                                            // details[index]['country'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                letterSpacing:
                                                                    .3)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      '12',
                                                      // widget
                                                      //     .selectedorder[index]
                                                      //     .price
                                                      //     .toString(),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
                                  })),
                          // Row(
                          //   children: [
                          //     Container(
                          //       height: 50,
                          //       width: 200,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(8.0),
                          //       ),
                          //       child: RaisedButton(
                          //         color: Colors.green,
                          //         onPressed: () {},
                          //         child: Text(
                          //           'Pay 23',
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       width: 3,
                          //     ),
                          //     Container(
                          //       height: 50,
                          //       width: 80,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(8.0),
                          //       ),
                          //       child: RaisedButton(
                          //         color: Color(0xFF1f1338),
                          //         onPressed: () {},
                          //         child: Text(
                          //           'Park',
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // )
                        )
                      ],
                    ),
                  )),
              SizedBox(
                width: 20,
              ),
              Padding(
                padding: EdgeInsets.only(top: 34, bottom: 0),
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      width: 900,
                      color: Color(0xFFe4eff0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 40, left: 120),
                                child: Text(
                                  '\u20B9345',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10, left: 120),
                                child: Text(
                                  'Total payable amount',
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 10, left: 120, bottom: 10),
                              child: VerticalDivider(
                                color: Colors.black,
                              )),
                          Padding(
                              padding: EdgeInsets.only(top: 12, left: 10),
                              child: Column(
                                children: [
                                  Text(
                                    'Discount',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: Color(0xFF1f1338),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: FlatButton(
                                          onPressed: () => {},
                                          color: Colors.transparent,
                                          padding: EdgeInsets.all(12.0),
                                          child: Text(
                                            '10%',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Container(
                                        height: 60,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: Color(0xFF1f1338),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: FlatButton(
                                          onPressed: () => {},
                                          color: Colors.transparent,
                                          padding: EdgeInsets.all(12.0),
                                          child: Text(
                                            '20%',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Container(
                                        height: 60,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: Color(0xFF1f1338),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: FlatButton(
                                          onPressed: () => {},
                                          color: Colors.transparent,
                                          padding: EdgeInsets.all(12.0),
                                          child: Text(
                                            '50%',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 500,
                      width: 900,
                      color: Color(0xFFe4eff0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                    top: 60,
                                  ),
                                  child: Container(
                                    height: 150,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: changecolor == true
                                            ? Colors.grey
                                            : Colors.red,
                                        // Color(0xFF8aa8b8),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: FlatButton(
                                      onPressed: () {
                                        changecolor = true;
                                      },
                                      // color: Colors.transparent,
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Icon(Icons.money,
                                                  size: 60,
                                                  color: Colors.white)),
                                          Text(
                                            "Cash",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                    top: 60,
                                  ),
                                  child: Container(
                                    height: 150,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        // color: Color(0xFF8aa8b8),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: FlatButton(
                                      onPressed: () {
                                        dialogbox();
                                      },
                                      color: Colors.transparent,
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Icon(
                                                  Icons.credit_card_outlined,
                                                  size: 60,
                                                  color: Colors.white)),
                                          Text(
                                            "Credit card",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                    top: 60,
                                  ),
                                  child: Container(
                                    height: 150,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: changecolor == true
                                            ? Colors.grey
                                            : Colors
                                                .red, // color: Color(0xFF8aa8b8),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: FlatButton(
                                      onPressed: () {
                                        changecolor = true;
                                      },
                                      // color: Colors.transparent,
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Icon(
                                                  Icons.credit_card_outlined,
                                                  size: 60,
                                                  color: Colors.white)),
                                          Text(
                                            "Debit card",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                    top: 60,
                                  ),
                                  child: Container(
                                    height: 150,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        // color: Color(0xFF8aa8b8),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: FlatButton(
                                      onPressed: () => {},
                                      color: Colors.transparent,
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Icon(
                                                  Icons.credit_card_outlined,
                                                  size: 60,
                                                  color: Colors.white)),
                                          Text(
                                            "External Pay",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                    top: 60,
                                  ),
                                  child: Container(
                                    height: 150,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        // color: Color(0xFF8aa8b8),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: FlatButton(
                                      onPressed: () => {},
                                      color: Colors.transparent,
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Icon(
                                                  Icons.timelapse_outlined,
                                                  size: 60,
                                                  color: Colors.white)),
                                          Text(
                                            "Pay Overtime",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                    top: 60,
                                  ),
                                  child: Container(
                                    height: 150,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        // color: Color(0xFF8aa8b8),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: FlatButton(
                                      onPressed: () => {},
                                      color: Colors.transparent,
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Icon(
                                                Icons.timeline_rounded,
                                                color: Colors.white,
                                                size: 60,
                                              )),
                                          Text(
                                            "Pay Safe",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
