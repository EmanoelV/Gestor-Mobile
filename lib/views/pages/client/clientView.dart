import 'package:Fick/controller/provider.dart';
import 'package:Fick/model/clientModel.dart';
import 'package:Fick/views/pages/client/clientForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientView extends StatelessWidget {
  ClientModel _client;
  int idx;

  ClientView(this._client, this.idx);

  @override
  Widget build(BuildContext context) {
    void edit(ClientModel client, int idx) {
      showModalBottomSheet(
          context: context,
          builder: (_) => ClientForm(
                client: _client,
                idx: idx,
              ));
    }

    return Card(
      child: ListTile(
        title: Text(
          _client.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_client.endereco),
        trailing: PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem<String>(
                      child: ListTile(
                    onTap: () => edit(_client, idx),
                    leading: Icon(Icons.edit, color: Colors.blue),
                    title: Text('Editar'),
                  )),
                  PopupMenuItem<String>(
                      value: 'Add',
                      child: ListTile(
                        onTap: () {
                          launch(
                              'whatsapp://send?phone=\$+55${_client.numero}');
                        },
                        leading: Icon(Icons.rate_review, color: Colors.green),
                        title: Text('Whatsapp'),
                      )),
                  PopupMenuItem<String>(
                      value: 'Add',
                      child: ListTile(
                        onTap: () => launch('tel:${_client.numero}'),
                        leading: Icon(Icons.call, color: Colors.green),
                        title: Text('Chamar'),
                      )),
                  PopupMenuItem<String>(
                      child: ListTile(
                    onTap: () => Provider.of<MyProvider>(context, listen: false)
                        .clientRemove(idx),
                    leading: Icon(Icons.delete_forever, color: Colors.red),
                    title: Text('Excluir'),
                  )),
                ]),
      ),
    );
  }
}
