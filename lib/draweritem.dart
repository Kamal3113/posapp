
   

import 'package:flutter/material.dart';
import 'package:posbillingapp/homescreen.dart';
import 'package:posbillingapp/printerformat.dart';
import 'package:posbillingapp/test.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    // new DrawerItem("Profile", Icons.person_outline),
    new DrawerItem("Settings", Icons.people_outline)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Firebasedata();
      case 1:
        return new printerDevices();
      // case 2:
      //   return new AboutusFragment();

      default:
        return new Text("Error");
    }
  }
  
  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        )
      );
    }

    return new Scaffold(
      
      // appBar: new AppBar(
      //   // here we display the title corresponding to the fragment
      //   // you can instead choose to have a static title
      //   title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      // ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text("Lapcare food"), accountEmail: new Text("extrameal@gmail.com"),currentAccountPicture: CircleAvatar(
              backgroundColor:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                "LF",
                style: TextStyle(fontSize: 40.0),
              ),
            ),),
            new Column(children: drawerOptions),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}