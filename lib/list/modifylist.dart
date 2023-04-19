import 'package:flutter/cupertino.dart';
import 'package:posbillingapp/list/productmodlist.dart';

class Modifierlist {
  final String imageUrl;
  final String name;
  final double price;
  final Color color;
  final List<Productmodifier1> pdtmodifylist;
  Modifierlist({
     this.imageUrl,
     this.name,
     this.price,
     this.color,
     this.pdtmodifylist,
  });
}
