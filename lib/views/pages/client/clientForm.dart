import 'package:Fick/controller/provider.dart';
import 'package:Fick/model/clientModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ClientForm extends StatefulWidget {
  ClientModel client;
  final int idx;
  bool hasClient = false;

  ClientForm({this.client, this.idx}) {
    if (this.client != null) hasClient = true;
  }

  @override
  _ClientFormState createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _aniversario;
  String _name = "";
  String _endereco = "";
  int _number = 0;
  int refreshIdx = 0;

  @override
  Widget build(BuildContext context) {
    refreshIdx += 1;
    if (widget.hasClient && refreshIdx <= 1) {
      _aniversario = widget.client.aniversario;
      _name = widget.client.name;
      _endereco = widget.client.endereco;
      _number = widget.client.numero;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: _name,
                    onSaved: (name) => _name = name,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Nome',
                        icon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        )),
                  ),
                  TextFormField(
                    initialValue: _endereco,
                    onSaved: (endereco) => _endereco = endereco,
                    decoration: InputDecoration(
                        labelText: 'Endereço',
                        icon: Icon(
                          Icons.map,
                          color: Colors.blue,
                        )),
                  ),
                  TextFormField(
                    initialValue: _number.toString(),
                    onSaved: (telefone) => _number = int.parse(telefone),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: 'Telefone',
                        icon: Icon(
                          Icons.phone_android,
                          color: Colors.blue,
                        )),
                  ),
                  Card(
                    child: ListTile(
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            _aniversario = null;
                          });
                        },
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                        ),
                        onPressed: () => showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate:
                                    DateTime.now().add(Duration(days: 50)))
                            .then((value) {
                          setState(() {
                            _aniversario = value;
                          });
                        }),
                      ),
                      title: Text('Aniversário' +
                          (_aniversario == null
                              ? ''
                              : ': ' +
                                  DateFormat('dd/MM/y').format(_aniversario))),
                    ),
                  ),
                ],
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _formKey.currentState.save();
          ClientModel client = ClientModel(
              id: widget.hasClient ? widget.client.id : "",
              name: _name,
              endereco: _endereco,
              aniversario: _aniversario,
              numero: _number,
              date: DateTime.now());

          if (!widget.hasClient) {
            Provider.of<MyProvider>(context, listen: false).cientAdd(client);
          } else {
            Provider.of<MyProvider>(context, listen: false)
                .clientEdit(client, widget.idx);
          }

          Navigator.of(context).pop();
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
