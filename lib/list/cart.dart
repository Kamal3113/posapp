import 'package:posbillingapp/list/cartmodifierlist.dart';

import 'modifylist.dart';

class Cartlist {
  final String id;
  final String name;
   final double price;
   int qty;
  final List<CartModifierlist> cartmomodifylist;
  Cartlist(
      { this.id,
       this.name,
       this.price,
       this.qty,
       this.cartmomodifylist});
}
