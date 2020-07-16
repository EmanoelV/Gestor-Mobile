import '../pages/client/client.dart';
import '../pages/finances/finances.dart';
import '../pages/item/item.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
              color: Colors.white,
              width: 150,
              height: 150,
              child: Image.asset('assets/imgs/menu.jpg')),
          ListTile(
            title: Text('Finanças'),
            leading: Icon(
              Icons.attach_money,
              color: Colors.green,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FinancesPage()),
            ),
          ),
          ListTile(
            title: Text('Produtos'),
            leading: Icon(
              Icons.shopping_cart,
              color: Colors.blue,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItemPage()),
            ),
          ),
          ListTile(
            title: Text('Clientes'),
            leading: Icon(
              Icons.person,
              color: Colors.blue,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClientPage()),
            ),
          ),
        ],
      ),
    );
  }
}
