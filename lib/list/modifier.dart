import 'package:flutter/cupertino.dart';
import 'package:posbillingapp/list/modifylist.dart';

class Modifier {
  int modifierid;
  final int qty;
  final double total;
  final String imageUrl;
  final String modifiername;
  final double price;
  final List<Modifierlist> modifylist;
  final Color color;
  Modifier({
    this.modifierid,
    this.qty,
    this.total,
    this.imageUrl,
    this.modifiername,
    this.price,
    this.modifylist,
    this.color,
  });
}
