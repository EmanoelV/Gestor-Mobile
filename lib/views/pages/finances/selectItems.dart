import 'package:Fick/controller/provider.dart';
import 'package:Fick/model/itemModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectItems extends StatelessWidget {
  List<ItemModel> _itemList;
  List<ItemModel> _itemSelected;

  @override
  Widget build(BuildContext context) {
    _itemList = Provider.of<MyProvider>(context).items;
    _itemSelected = Provider.of<MyProvider>(context).itemForSell;
    _itemSelected.forEach((item) {
      _itemList.remove(item);
    });
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: _itemList.length,
          itemBuilder: (_, index) => Card(
                child: ListTile(
                  onTap: () {
                    _itemList[index].quantidadeVendida = 1;
                    Provider.of<MyProvider>(context, listen: false)
                        .addItemForSell(_itemList[index]);
                    Navigator.of(context).pop();
                  },
                  title: Text(
                    _itemList[index].title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(children: <Widget>[
                    Text(
                        'R\$ ' +
                            _itemList[index]
                                .newValue
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                    Text('   Estoque: ${_itemList[index].estoque}'),
                  ]),
                  leading: Container(
                      child: _itemList[index].img != null
                          ? Image.network(
                              _itemList[index].img,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            )
                          : Icon(
                              Icons.image,
                              size: 40,
                            )),
                ),
              )),
    );
  }
}
