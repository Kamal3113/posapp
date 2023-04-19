import 'package:flutter/material.dart';
import 'package:posbillingapp/list/food.dart';
import 'package:posbillingapp/list/modifier.dart';
import 'package:posbillingapp/list/modifylist.dart';
import 'package:posbillingapp/list/productmodlist.dart';
import 'package:posbillingapp/list/restaurantlist.dart';
import 'package:posbillingapp/list/userlist.dart';

// Food
final _burrito = Food(
    id: 1,
    qty: 1,
    total: 8.99,
    imageUrl: 'assest/brito.jpg',
    name: 'Burrito',
    price: 8.99,
    color: Colors.red,
    modify: [_m1],
    modifylist: [_pn1, _pn2],
    pdcommments: '');
final _steak = Food(
    id: 2,
    qty: 1,
    total: 17.99,
    imageUrl: 'assest/steak.jpg',
    name: 'Steak',
    price: 17.99,
    color: Colors.deepPurpleAccent,
    modify: [],
    modifylist: [_pn2],
    pdcommments: '');
final _pasta = Food(
    id: 3,
    qty: 1,
    total: 14.99,
    imageUrl: 'assest/pasta.jpg',
    name: 'Pasta',
    price: 14.99,
    color: Colors.purple,
    modify: [],
    modifylist: [_pn3, _pn5, _pn1],
    pdcommments: '');
final _ramen = Food(
    id: 4,
    qty: 1,
    total: 13.99,
    imageUrl: 'assest/ramen.jpg',
    name: 'Ramen',
    price: 13.99,
    color: Colors.blue,
    modify: [],
    modifylist: [_pn1, _pn5],
    pdcommments: '');
final _pancakes = Food(
    id: 5,
    qty: 1,
    total: 9.99,
    imageUrl: 'assest/pancake.jpg',
    name: 'Noodle',
    price: 9.99,
    color: Colors.red,
    modify: [],
    modifylist: [],
    pdcommments: '');
final _burger = Food(
    id: 6,
    qty: 1,
    total: 14.99,
    imageUrl: 'assest/burger.jpg',
    name: 'Burger',
    price: 14.99,
    color: Colors.teal,
    modify: [],
    modifylist: [],
    pdcommments: '');
final _pizza = Food(
    id: 7,
    qty: 1,
    total: 11.99,
    imageUrl: 'assest/pizza.jpg',
    name: 'Pizza',
    price: 11.99,
    color: Colors.green,
    modify: [],
    modifylist: [],
    pdcommments: '');
final _salmon = Food(
    id: 8,
    qty: 1,
    total: 12.99,
    imageUrl: 'assest/salmen.jpg',
    name: 'Salmon',
    price: 12.99,
    color: Colors.orange,
    modify: [],
    modifylist: [],
    pdcommments: '');
final _f1 = Food(
    id: 9,
    qty: 1,
    total: 12.99,
    imageUrl: 'assest/pn1.jpg',
    name: 'Salmon',
    price: 12.99,
    color: Colors.pink,
    modify: [],
    modifylist: [],
    pdcommments: '');
final _f2 = Food(
    id: 10,
    qty: 1,
    total: 12.99,
    imageUrl: 'assest/pn2.jpg',
    name: 'Salmon',
    price: 12.99,
    color: Colors.green,
    modify: [],
    modifylist: [],
    pdcommments: '');
final _f3 = Food(
    id: 11,
    qty: 1,
    total: 12.99,
    imageUrl: 'assest/pn3.jpg',
    name: 'Salmon',
    price: 12.99,
    color: Colors.brown,
    modify: [],
    modifylist: [],
    pdcommments: '');
final _f4 = Food(
    id: 12,
    qty: 1,
    total: 12.99,
    imageUrl: 'assest/pn4.jpg',
    name: 'Salmon',
    price: 12.99,
    color: Colors.greenAccent,
    modify: [],
    modifylist: [],
    pdcommments: '');
final _f5 = Food(
    id: 13,
    qty: 1,
    total: 12.99,
    imageUrl: 'assest/pn5.jpg',
    name: 'Salmon',
    price: 12.99,
    color: Colors.red,
    modify: [],
    modifylist: [],
    pdcommments: '');
final _m1 = Modifier(
    imageUrl: 'assest/pn1.jpg',
    modifierid: 1,
    modifiername: 'Paneer',
    modifylist: [],
    qty: 1,
    total: 12,
    price: 8.99,
    color: Colors.green);
final _pn1 = Modifierlist(
    imageUrl: 'assest/pn1.jpg',
    name: 'Paneer tikka',
    price: 8.99,
    color: Colors.green,
    pdtmodifylist: [pm3, pm4]);
final _pn2 = Modifierlist(
    imageUrl: 'assest/pn2.jpg',
    name: 'Palakpaneer',
    price: 17.99,
    color: Colors.brown,
    pdtmodifylist: [pm5, pm3]);
final _pn3 = Modifierlist(
    imageUrl: 'assest/pn3.jpg',
    name: 'butter masala',
    price: 14.99,
    color: Colors.purple,
    pdtmodifylist: [pm1, pm3]);
final _pn4 = Modifierlist(
    imageUrl: 'assest/pn4.jpg',
    name: 'Matarpaneer',
    price: 13.99,
    color: Colors.green,
    pdtmodifylist: [pm3]);
final _pn5 = Modifierlist(
    imageUrl: 'assest/pn5.jpg',
    name: 'kadai paneer',
    price: 9.99,
    color: Colors.red,
    pdtmodifylist: [pm5, pm1]);

final pm1 = Productmodifier1(
    imageUrl: 'assest/pn1.jpg',
    name: 'Paneer tikka',
    price: 8.99,
    color: Colors.teal);
final pm2 = Productmodifier1(
    imageUrl: 'assest/pn2.jpg',
    name: 'Palakpaneer',
    price: 17.99,
    color: Colors.brown);
final pm3 = Productmodifier1(
    imageUrl: 'assest/pn3.jpg',
    name: 'butter masala',
    price: 14.99,
    color: Colors.purple);
final pm4 = Productmodifier1(
    imageUrl: 'assest/pn4.jpg',
    name: 'Matarpaneer',
    price: 13.99,
    color: Colors.green);
final pm5 = Productmodifier1(
    imageUrl: 'assest/pn5.jpg',
    name: 'kadai paneer',
    price: 9.99,
    color: Colors.red);
final _a = Modifier(
    modifierid: 1,
    qty: 1,
    total: 8.99,
    imageUrl: 'assest/m1.jpg',
    modifiername: 'Mushroom',
    price: 8.99,
    modifylist: [_pn1, _pn2, _pn4, _pn5],
    color: Colors.red);
final _b = Modifier(
    modifierid: 4,
    qty: 1,
    total: 13.99,
    imageUrl: 'assest/m2.jpg',
    modifiername: 'Pepperoni',
    price: 13.99,
    modifylist: [_pn4, _pn5],
    color: Colors.green);
final _c = Modifier(
    modifierid: 8,
    qty: 1,
    total: 12.99,
    imageUrl: 'assest/m3.jpg',
    modifiername: 'Jalapeno',
    price: 12.99,
    modifylist: [_pn3, _pn2],
    color: Colors.brown);
final _d = Modifier(
    modifierid: 7,
    qty: 1,
    total: 11.99,
    imageUrl: 'assest/m4.jpg',
    modifiername: 'Blue cheese',
    price: 11.99,
    modifylist: [_pn1, _pn5],
    color: Colors.green);
// Restaurants
final _restaurant0 = Restaurant(
    id: 1,
    imageUrl: 'assest/ps.jpg',
    name: 'Pizza',
    address: '200 Main St, New York, NY',
    rating: 5,
    menu: [
      _burrito,
      _steak,
      _pasta,
      _ramen,
      _pancakes,
      _burger,
      _pizza,
      _salmon
    ],
    modify: [
      _a,
    ],
    color: Colors.red);
final _restaurant1 = Restaurant(
    id: 2,
    imageUrl: 'assest/momos.jpg',
    name: 'Signs',
    address: '200 Main St, New York, NY',
    rating: 4,
    menu: [
      _ramen,
      _pancakes,
      _burger,
      _pizza,
      _salmon,
      _steak,
      _burger,
      _pizza,
      _burger,
      _pizza,
      _ramen,
      _pancakes,
      _burger,
      _pizza,
      _salmon,
      _ramen,
      _pancakes,
      _burger,
      _pizza,
      _salmon,
      _salmon
    ],
    modify: [
      _c,
    ],
    color: Colors.blue);
final _restaurant2 = Restaurant(
    id: 3,
    imageUrl: 'assest/dal.jpg',
    name: 'Etern',
    address: '200 Main St, New York, NY',
    rating: 4,
    menu: [_pizza, _salmon],
    modify: [],
    color: Colors.brown);
final _restaurant3 = Restaurant(
    id: 4,
    imageUrl: 'assest/it.jpg',
    name: 'Dosa',
    address: '200 Main St, New York, NY',
    rating: 2,
    menu: [
      _burrito,
      _steak,
      _burger,
      _burger,
      _pizza,
      _salmon,
      _pizza,
      _salmon
    ],
    modify: [
      _d,
    ],
    color: Colors.green);
//     'assest/pn1.jpg'
// 'assest/pn2.jpg'
// 'assest/pn3.jpg'
// 'assest/pn4.jpg'
// 'assest/pn5.jpg'
final _restaurant4 = Restaurant(
    id: 5,
    imageUrl: 'assest/steak.jpg',
    name: 'court',
    address: '200 Main St, New York, NY',
    rating: 3,
    menu: [_burrito, _ramen, _pancakes, _salmon, _burger, _pizza, _salmon],
    modify: [_a, _b, _d],
    color: Colors.pink);
final _restaurant5 = Restaurant(
    id: 5,
    imageUrl: 'assest/pn1.jpg',
    name: 'Cream',
    address: '200 Main St, New York, NY',
    rating: 3,
    menu: [_burrito, _ramen, _pancakes, _salmon, _burger, _pizza, _salmon],
    modify: [],
    color: Colors.blue);
final _restaurant6 = Restaurant(
    id: 5,
    imageUrl: 'assest/pn2.jpg',
    name: 'Meal',
    address: '200 Main St, New York, NY',
    rating: 3,
    menu: [_burrito, _ramen, _pancakes, _salmon, _burger, _pizza, _salmon],
    modify: [],
    color: Colors.purple);
final _restaurant7 = Restaurant(
    id: 5,
    imageUrl: 'assest/pn3.jpg',
    name: 'Pasta',
    address: '200 Main St, New York, NY',
    rating: 3,
    menu: [_burrito, _ramen, _pancakes, _salmon, _burger, _pizza, _salmon],
    modify: [_d],
    color: Colors.teal);
final _restaurant8 = Restaurant(
    id: 5,
    imageUrl: 'assest/pn4.jpg',
    name: 'Meat',
    address: '200 Main St, New York, NY',
    rating: 3,
    menu: [_burrito, _ramen, _pancakes, _salmon, _burger, _pizza, _salmon],
    modify: [_a, _b, _d],
    color: Colors.purple);
final _restaurant9 = Restaurant(
    id: 5,
    imageUrl: 'assest/pn5.jpg',
    name: 'Sweet',
    address: '200 Main St, New York, NY',
    rating: 3,
    menu: [_burrito, _ramen, _pancakes, _salmon, _burger, _pizza, _salmon],
    modify: [],
    color: Colors.black);

final List<Food> food = [
  _burrito,
  _steak,
  _pasta,
  _ramen,
  _pancakes,
  _burger,
  _pizza,
  _salmon,
  _f1,
  _f2,
  _f3,
  _f4,
  _f5
];
final List<Productmodifier1> productmodlist = [
  pm1,
  pm2,
  pm3,
  pm4,
  pm5,
];
final List<Modifier> md = [
  _a,
  _b,
  _c,
  _d,
];
final List<Modifierlist> paneer = [
  _pn1,
  _pn2,
  _pn3,
  _pn4,
  _pn5,
];
final List<User> us = [
  _us1,
  _us2,
  _us3,
  _us4,
  _us5,
];
final _us1 = User(name: 'David');
final _us2 = User(name: 'Peter');
final _us3 = User(name: 'James');
final _us4 = User(name: 'Spetor');
final _us5 = User(name: 'Jone');
final List<Restaurant> restaurants = [
  _restaurant0,
  _restaurant1,
  _restaurant2,
  _restaurant3,
  _restaurant4,
  _restaurant5,
  _restaurant6,
  _restaurant7,
  _restaurant8,
  _restaurant9,
];
