import 'package:flutter/cupertino.dart';
import 'package:posbillingapp/list/modifier.dart';

import 'food.dart';

class Restaurant {
  int id;
  final String imageUrl;
  final String name;
  final String address;
  final int rating;
  final List<Food> menu;
  final List<Modifier> modify;
  final Color color;

  Restaurant({
     this.id,
     this.imageUrl,
     this.name,
     this.address,
     this.rating,
     this.menu,
     this.modify,
     this.color,
  });
}
