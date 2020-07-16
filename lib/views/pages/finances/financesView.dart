import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinancesView extends StatelessWidget {
  final _transaction;
  FinancesView(this._transaction);


  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        dense: true,
        title: Text(
          'R\$' + _transaction.products.map((item) => item['value']).toList().fold(0, (p, c) => p + c).toStringAsFixed(2).replaceAll('.',',') +
          ' - ' + _transaction.client + ' - ' + DateFormat('d/MM/yy').format( _transaction.date )
          ,
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
        subtitle: Container(
          height: 30,
          child: ListView(
            children: <Widget>[ ..._transaction.products.map(
              (item) => Text('${item['name']} - R\$ ${item['value'].toStringAsFixed(2)}' )
            ) ],
          ),
        ) ,
        trailing: PopupMenuButton(
          onSelected: (value) => print(value),
          itemBuilder: (context) => <PopupMenuEntry>[
            PopupMenuItem<String>(
              value: 'Editar',
              child: ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('Editar'),
              )
            ),
            PopupMenuItem<String>(
              value: 'Cliente',
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.blue),
                title: Text('Cliente'),
              )
            ),
            PopupMenuItem<String>(
              value: 'Excluir',
              child: ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.red),
                title: Text('Excluir'),
              )
            ),
          ]
        ),
      ),
    );
  }
}