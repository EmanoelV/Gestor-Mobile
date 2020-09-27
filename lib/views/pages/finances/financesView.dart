import 'package:Fick/controller/provider.dart';
import 'package:Fick/model/transactionModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FinancesView extends StatelessWidget {
  final TransactionModel _transaction;
  final int idx;
  String _totalValue;
  String _date;

  FinancesView(this._transaction, this.idx) {
    _totalValue = _transaction.total.toStringAsFixed(2).replaceAll('.', ',');
    _date = DateFormat('d/MM/yy').format(_transaction.date);
  }

  MaterialColor defineColor() {
    if (_transaction.isPaid) {
      return (_transaction.total > 0 ? Colors.green : Colors.red);
    } else {
      return (Colors.yellow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: defineColor(),
          child: Text(
            'R\$$_totalValue',
            style: TextStyle(
                fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(_transaction.title),
        subtitle: Container(
          child: Text(_date),
        ),
        trailing: PopupMenuButton(
            onSelected: (value) => print(value),
            itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem<String>(
                      value: 'Editar',
                      child: ListTile(
                        leading: Icon(Icons.edit, color: Colors.blue),
                        title: Text('Editar'),
                      )),
                  PopupMenuItem<String>(
                      value: 'Cliente',
                      child: ListTile(
                        leading: Icon(Icons.person, color: Colors.blue),
                        title: Text('Cliente'),
                      )),
                  PopupMenuItem<String>(
                      value: 'Excluir',
                      child: ListTile(
                        onTap: () =>
                            Provider.of<MyProvider>(context, listen: false)
                                .transactionRemove(idx),
                        leading: Icon(Icons.delete_forever, color: Colors.red),
                        title: Text('Excluir'),
                      )),
                ]),
      ),
    );
  }
}
