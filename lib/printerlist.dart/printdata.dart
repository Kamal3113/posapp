
import 'package:posbillingapp/printerlist.dart/orderlist.dart';

class Printerlist {
  String header;
  List<Order> order;
  String address;
  DateTime orderdatetime;
  String billno;
  String gst;
  String subtotal;
  String total;
  String amountpaid;
  String paymentstatus;
  String logo;
  String phoneno;
  String thankyouCard;
  String barcode;
  Printerlist({
    this.header,
    this.order,
    this.address,
    this.orderdatetime,
    this.billno,
    this.gst,
    this.subtotal,
    this.total,
    this.amountpaid,
    this.paymentstatus,
    this.logo,
    this.phoneno,
    this.thankyouCard,
    this.barcode,
  });
}
