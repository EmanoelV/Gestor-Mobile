import 'package:Fick/model/itemModel.dart';
import 'package:flutter/material.dart';

class ItemDetail extends StatelessWidget {
  ItemModel _item;
  ItemDetail(this._item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_item.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
                child: Container(
              padding: EdgeInsets.all(16),
              child: _item.img == null
                  ? Image.asset('assets/imgs/menu.jpg')
                  : Image.network(_item.img),
            )),
            ListTile(
                title: Text(
                    'Despesa: R\$ ${_item.value.toStringAsFixed(2).replaceAll('.', ',')}')),
            ListTile(
                title: Text(
                    'Preço: R\$ ${_item.newValue.toStringAsFixed(2).replaceAll('.', ',')}')),
            ListTile(
                title: Text(
                    'Lucro Real: ${(100 * (_item.newValue - _item.value) / _item.newValue).toStringAsPrecision(2).replaceAll('.', ',')}% (R\$ ${(_item.newValue - _item.value).toStringAsFixed(2).replaceAll('.', ',')})')),
            ListTile(
              title: Text('Estoque: ${_item.estoque}'),
            ),
          ],
        ),
      ),
    );
  }
}
