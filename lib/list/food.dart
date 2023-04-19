import 'package:flutter/cupertino.dart';
import 'package:posbillingapp/list/modifier.dart';
import 'package:posbillingapp/list/pcommentslist.dart';

import 'modifylist.dart';

class Food {
  int id;
  final int qty;
  final double total;
  final String imageUrl;
  final String name;
  final double price;
  final Color color;
  final List<Modifier> modify;
  final List<Modifierlist> modifylist;
  final String pdcommments;
  Food({
     this.id,
     this.qty,
     this.total,
     this.imageUrl,
     this.name,
     this.price,
     this.color,
     this.modify,
     this.modifylist,
     this.pdcommments,
  });
}
