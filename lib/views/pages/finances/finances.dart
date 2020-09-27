import 'package:Fick/controller/provider.dart';
import 'package:Fick/model/transactionModel.dart';
import 'package:Fick/views/pages/finances/financesForm.dart';
import 'package:provider/provider.dart';
import 'package:Fick/views/components/popup.dart';
import 'package:Fick/views/components/myDrawer.dart';
import 'financesView.dart';
import 'package:flutter/material.dart';

class FinancesPage extends StatelessWidget {
  List transactionList = [];
  @override
  Widget build(BuildContext context) {
    transactionList = Provider.of<MyProvider>(context).transactions;
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text('Finanças'),
        ),
        body: ListView.builder(
          itemBuilder: (_, index) {
            return FinancesView(transactionList[index], index);
          },
          itemCount: transactionList.length,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Popup(
            actions: (String value) {
              Map<String, FinancesFormConfig> actions = {
                'venda': FinancesFormConfig('Registrar Venda', false, true),
                'receita': FinancesFormConfig('Registrar Receita', false),
                'despesa': FinancesFormConfig('Registrar Despesa', true),
              };
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                //Provider.of<MyProvider>(context).itemForSell.clear();
                return FinancesForm(actions[value]);
              }));
            },
            icon: Icon(Icons.attach_money),
            menuItens: [
              MenuItemModel(
                title: 'Venda',
                value: 'venda',
                icon: Icon(
                  Icons.attach_money,
                  color: Colors.green,
                ),
              ),
              MenuItemModel(
                title: 'Receita',
                value: 'receita',
                icon: Icon(
                  Icons.attach_money,
                  color: Colors.green,
                ),
              ),
              MenuItemModel(
                title: 'Despesa',
                value: 'despesa',
                icon: Icon(
                  Icons.attach_money,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ));
  }
}
