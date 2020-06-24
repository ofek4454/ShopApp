import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';

class CustomDrawer extends StatelessWidget {

  final String currentPage;

  CustomDrawer(this.currentPage);

  Widget _buildListTile(
      BuildContext ctx, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(
        icon,
        size: 28,
        color: Theme.of(ctx).primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(ctx).primaryColor,
        ),
      ),
      onTap: () {
        if(route == currentPage)
        {
          Navigator.of(ctx).pop(this);
        }else{
          Navigator.of(ctx).pushReplacementNamed(route);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 80,
              padding: EdgeInsets.only(left: 15),
              width: double.infinity,
              color: Theme.of(context).accentColor,
              alignment: Alignment.centerLeft,
              child: Text(
                'Shop App',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _buildListTile(
                context, 'Main Screen', Icons.shopping_basket, '/'),
            _buildListTile(
                context, 'Orders', Icons.history, OrdersScreen.routeName),
          ],
        ),
      ),
    );
  }
}
