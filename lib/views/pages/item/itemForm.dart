import 'dart:io';
import 'package:Fick/model/itemModel.dart';
import 'package:Fick/controller/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ItemForm extends StatefulWidget {
  String title;
  String id;
  double value;
  double newValue;
  int estoque;
  String urlImg;
  int idx;

  ItemForm(
      {this.title,
      this.value,
      this.estoque,
      this.newValue,
      this.id,
      this.urlImg,
      this.idx});

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();

  String _title;
  double _value;
  double _newValue;
  int _estoque;
  File fileImg;

  Widget iconSelector() {
    if (fileImg != null) {
      return Image.file(fileImg);
    } else if (widget.urlImg != null) {
      return Image.network(widget.urlImg);
    } else {
      return Icon(Icons.add_a_photo);
    }
  }

  getImg() async {
    File img;
    var loadImg = await ImagePicker().getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 720,
        maxWidth: 720);
    img = File(loadImg.path);
    setState(() {
      fileImg = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  IconButton(
                      color: Colors.blue,
                      icon: iconSelector(),
                      onPressed: getImg),
                  Flexible(
                    child: TextFormField(
                      initialValue: widget.title,
                      onSaved: (value) => _title = value,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                      ),
                    ),
                  ),
                ]),
                Row(children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      initialValue:
                          widget.value == null ? "" : widget.value.toString(),
                      onSaved: (value) =>
                          _value = double.parse(value.replaceAll(',', '.')),
                      decoration: InputDecoration(
                        labelText: 'Despesa',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: TextFormField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      initialValue: widget.newValue == null
                          ? ""
                          : widget.newValue.toString(),
                      onSaved: (value) =>
                          _newValue = double.parse(value.replaceAll(',', '.')),
                      decoration: InputDecoration(
                        labelText: 'Preço',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: TextFormField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      initialValue: widget.estoque == null
                          ? ""
                          : widget.estoque.toString(),
                      onSaved: (value) => _estoque = int.parse(value),
                      decoration: InputDecoration(
                        labelText: 'Quantidade',
                      ),
                    ),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          'Salvar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _formKey.currentState.save();
                          ItemModel prod = ItemModel(
                              id: widget.id,
                              title: _title,
                              estoque: _estoque,
                              value: _value,
                              newValue: _newValue,
                              date: DateTime.now(),
                              img: widget.urlImg);
                          if (prod.id == null) {
                            Provider.of<MyProvider>(context, listen: false)
                                .itemAdd(prod, img: fileImg);
                          } else {
                            Provider.of<MyProvider>(context, listen: false)
                                .itemEdit(prod, widget.idx, img: fileImg);
                          }

                          Navigator.of(context).pop();
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
