import 'package:flutter/material.dart';

class PlaceOrderCard extends StatelessWidget {
  final double totalAmount;

  PlaceOrderCard(this.totalAmount);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Text(
              'total: ',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
              ),
            ),
            Chip(
              backgroundColor: Theme.of(context).primaryColor,
              label: Text(
                '\$$totalAmount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Spacer(),
            FlatButton(
              onPressed: () {},
              child: Text(
                'place order!'.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
