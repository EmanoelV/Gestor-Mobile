import 'package:Fick/controller/provider.dart';
import 'package:Fick/views/pages/client/clientForm.dart';
import 'package:provider/provider.dart';

import 'clientView.dart';
import '../../components/popup.dart';
import 'package:Fick/views/components/myDrawer.dart';
import 'package:flutter/material.dart';

class ClientPage extends StatefulWidget {
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  List _clientList;

  @override
  Widget build(BuildContext context) {
    _clientList = Provider.of<MyProvider>(context).clients;
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text('Clientes'),
        ),
        body: !Provider.of<MyProvider>(context).clientLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => Provider.of<MyProvider>(context, listen: false)
                    .clientLoad(),
                child: ListView.builder(
                    itemCount: _clientList.length,
                    itemBuilder: (_, index) =>
                        ClientView(_clientList[index], index)),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Popup(
            actions: (String value) {
              showModalBottomSheet(
                  context: context, builder: (_) => ClientForm());
            },
            icon: Icon(Icons.person),
            menuItens: [
              MenuItemModel(
                title: 'Novo Cliente',
                value: 'nc',
                icon: Icon(
                  Icons.person_add,
                  color: Colors.green,
                ),
              )
            ],
          ),
        ));
  }
}
