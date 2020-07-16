import 'package:Fick/controller/itemController.dart';
import 'package:Fick/views/pages/item/itemForm.dart';

import 'package:Fick/views/components/myDrawer.dart';
import 'package:Fick/controller/provider.dart';
import 'package:provider/provider.dart';
import '../../components/popup.dart';
import 'package:flutter/material.dart';
import '../../../model/itemModel.dart';
import 'itemView.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  List<ItemModel> _itemList;

  @override
  Widget build(BuildContext context) {
    _itemList = Provider.of<MyProvider>(context).items;
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text('Produtos'),
        ),
        body: !Provider.of<MyProvider>(context).itemLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    Provider.of<MyProvider>(context, listen: false).itemLoad(),
                child: ListView.builder(
                    itemCount: _itemList.length,
                    itemBuilder: (_, index) =>
                        ItemView(_itemList[index], index)),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Popup(
            actions: (String value) {
              if (value == 'np') {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => ItemForm(),
                );
              }
            },
            icon: Icon(Icons.shopping_cart),
            menuItens: [
              MenuItemModel(
                title: 'Novo Produto',
                value: 'np',
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: Colors.green,
                ),
              ),
              MenuItemModel(
                  title: 'Gerar Catálogo Online',
                  value: 'ct',
                  icon: Icon(
                    Icons.link,
                    color: Colors.blue,
                  ))
            ],
          ),
        ));
  }
}
