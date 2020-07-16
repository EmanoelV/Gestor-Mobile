import '../../../data.dart';
import 'package:Fick/views/components/popup.dart';
import 'package:Fick/views/components/myDrawer.dart';
import 'financesView.dart';
import 'package:flutter/material.dart';

class FinancesPage extends StatelessWidget {
  final List transactionList = Data().transactionList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('Finanças[EM DESENVOLVIMENTO]'),
        ),
        body: ListView.builder(
          itemBuilder: (_, index) {
            return FinancesView(transactionList[index]);
          },
          itemCount: transactionList.length,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Popup(
            actions: (String value) {
              print(value);
              showModalBottomSheet(
                context: context,
                builder: (_) => Scaffold(
                  body: SingleChildScrollView(
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Cliente',
                              icon: Icon(Icons.person),
                            ),
                          ),
                          Row(children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Produtos',
                                  icon: Icon(Icons.shopping_cart),
                                ),
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Valor',
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            icon: Icon(Icons.attach_money),
            menuItens: [
              MenuItemModel(
                title: 'Receita',
                value: 'r',
                icon: Icon(
                  Icons.attach_money,
                  color: Colors.green,
                ),
              )
            ],
          ),
        ));
  }
}
