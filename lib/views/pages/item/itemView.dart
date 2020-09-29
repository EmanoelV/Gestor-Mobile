import 'package:Fick/model/item/itemModelData.dart';
import 'package:Fick/views/pages/item/itemDetail.dart';
import 'package:Fick/controller/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'itemForm.dart';

class ItemView extends StatelessWidget {
  ItemModelData _item;
  int _idx;

  ItemView(this._item, this._idx);

  @override
  Widget build(BuildContext context) {
    void edit(ItemModelData item, int idx) {
      showModalBottomSheet(
        context: context,
        builder: (_) => ItemForm(
          title: item.title,
          value: item.value,
          newValue: item.newValue,
          estoque: item.estoque,
          id: item.id,
          urlImg: item.img,
          idx: idx,
        ),
      );
    }

    void addEstoque(idx) {
      print('ad estoque');
      final _key = GlobalKey<FormState>();
      save(String value) async {
        int newValue = _item.estoque + int.parse(value);
        Provider.of<MyProvider>(context, listen: false)
            .itemIncrementEstoque(idx, newValue);
      }

      showModalBottomSheet(
        context: context,
        builder: (_) => Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Form(
                    key: _key,
                    child: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      onSaved: save,
                      decoration: InputDecoration(
                          labelText: 'Quantidade',
                          contentPadding: EdgeInsets.all(0)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                RaisedButton(
                  onPressed: () {
                    _key.currentState.save();
                    Navigator.of(context).pop();
                  },
                  color: Colors.blue,
                  child: Text(
                    'Salvar',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: ListTile(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => ItemDetail(_item))),
        title: Text(
          _item.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(children: <Widget>[
          Text('R\$ ' + _item.newValue.toStringAsFixed(2).replaceAll('.', ','),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          Text('   Estoque: ${_item.estoque}'),
        ]),
        leading: Container(
            child: _item.img != null
                ? Image.network(
                    _item.img,
                    loadingBuilder: (context, child, loadingProgress) {
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
        trailing: PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem<String>(
                      child: ListTile(
                    onTap: () => edit(_item, _idx),
                    leading: Icon(Icons.edit, color: Colors.blue),
                    title: Text('Editar'),
                  )),
                  PopupMenuItem<String>(
                      child: ListTile(
                    onTap: () => addEstoque(_idx),
                    leading: Icon(Icons.add_circle, color: Colors.green),
                    title: Text('Aumentar Estoque'),
                  )),
                  PopupMenuItem<String>(
                      child: ListTile(
                    onTap: () {
                      Provider.of<MyProvider>(context, listen: false)
                          .itemRemove(_idx);
                      Navigator.of(context).pop();
                    },
                    leading: Icon(Icons.delete_forever, color: Colors.red),
                    title: Text('Excluir'),
                  )),
                ]),
      ),
    );
  }
}
