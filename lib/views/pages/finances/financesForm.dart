import 'package:Fick/controller/provider.dart';
import 'package:Fick/model/item/itemModelData.dart';
import 'package:Fick/model/transaction/transactionModelData.dart';
import 'package:Fick/views/pages/finances/formDate.dart';
import 'package:Fick/views/pages/finances/formParcelar.dart';
import 'package:Fick/views/pages/finances/selectItems.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinancesFormConfig {
  TransactionModelData transaction;
  String title;
  bool isNegative;
  bool isVenda;

  FinancesFormConfig(this.title,
      [this.isNegative = false, this.isVenda = false, this.transaction]);
}

class FinancesForm extends StatefulWidget {
  FinancesFormConfig config;

  FinancesForm(this.config);

  @override
  _FinancesFormState createState() => _FinancesFormState();
}

class _FinancesFormState extends State<FinancesForm> {
  bool repeat;
  bool isPaid;
  double total;
  int interval;
  int parcelas;
  String title;
  String desc;
  DateTime date;
  bool resetedValues;
  List<ItemModelData> listItems = [];
  final keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    repeat = false;
    isPaid = true;
    interval = 0;
    parcelas = 1;
    resetedValues = false;
    total = listItems.fold(
        0, (value, item) => value + item.newValue * item.quantidadeVendida);
  }

  @override
  Widget build(BuildContext context) {
    if (!resetedValues) {
      resetedValues = true;
      Provider.of<MyProvider>(context).itemForSell.clear();
    }

    listItems = Provider.of<MyProvider>(context).itemForSell;

    List<Widget> itemsSelected() {
      int ctIdx = -1;

      return listItems.map((item) {
        ctIdx++;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            DropdownButton<int>(
                value: listItems[ctIdx].quantidadeVendida,
                items: List.generate(item.estoque + 1, (i) => i)
                    .map((e) =>
                        DropdownMenuItem<int>(value: e, child: Text('$e')))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    listItems[ctIdx].quantidadeVendida = value;
                    total = listItems.fold(
                        0,
                        (value, item) =>
                            value + item.newValue * item.quantidadeVendida);
                    if (value == 0) {
                      listItems.removeAt(ctIdx);
                    }
                  });
                }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Text(item.title),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            Text('R\$${item.newValue * item.quantidadeVendida}')
          ],
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.config.title),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: keyForm,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  subtitle: !widget.config.isVenda
                      ? null
                      : Column(
                          children: [
                            ...itemsSelected(),
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.add_circle,
                                        color: Colors.green),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (_) => SelectItems()))
                                          .then((_) {
                                        setState(() {
                                          total = listItems.fold(
                                              0,
                                              (value, item) =>
                                                  value +
                                                  item.newValue *
                                                      item.quantidadeVendida);
                                        });
                                      });
                                    }),
                                Text('Adicionar Produto')
                              ],
                            ),
                          ],
                        ),
                  title: TextFormField(
                    controller: TextEditingController(text: total.toString()),
                    onSaved: (value) => total = widget.config.isNegative
                        ? -double.parse(value)
                        : double.parse(value),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                        prefix: Text('R\$'),
                        labelText: 'Valor',
                        border: InputBorder.none,
                        alignLabelWithHint: true),
                  ),
                ),
                SwitchListTile(
                    title: Text('Pago'),
                    value: isPaid,
                    onChanged: (_) {
                      setState(() {
                        print(date);
                        isPaid = !isPaid;
                      });
                    }),
                Divider(
                  thickness: 2,
                ),
                FormDate((DateTime newDate) {
                  date = newDate;
                  if (date.isAfter(DateTime.now())) {
                    setState(() {
                      isPaid = false;
                    });
                  }
                }),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  trailing: !widget.config.isVenda
                      ? null
                      : RaisedButton(
                          padding: EdgeInsets.all(11),
                          child: Text('Selecionar\nCliente'),
                          onPressed: null),
                  title: TextFormField(
                    onSaved: (value) => title = value,
                    decoration: InputDecoration(
                        labelText:
                            !widget.config.isVenda ? 'Titulo' : 'Cliente'),
                  ),
                ),
                TextFormField(
                  onSaved: (value) => desc = value,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                  ),
                ),
                Column(
                  children: <Widget>[
                    SwitchListTile(
                        title: Row(children: [
                          Icon(Icons.rotate_right),
                          Text(!widget.config.isVenda ? 'Repetir' : 'Parcelar')
                        ]),
                        value: repeat,
                        onChanged: (_) {
                          setState(() {
                            repeat = !repeat;
                            if (!repeat) {
                              parcelas = 1;
                              interval = 0;
                            } else {
                              parcelas = 2;
                              interval = 30;
                            }
                          });
                        }),
                    !repeat
                        ? SizedBox()
                        : FormParcelar((int newPeriod, int newParcelas) {
                            setState(() {
                              interval = newPeriod;
                              parcelas = newParcelas;
                            });
                          })
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          keyForm.currentState.save();
          final trans = TransactionModelData(
              id: 'await id',
              isPaid: isPaid,
              total: !widget.config.isVenda ? total : total / parcelas,
              date: date,
              interval: interval,
              parcelas: parcelas,
              title: title,
              desc: desc,
              copyProducts: listItems);
          Provider.of<MyProvider>(context, listen: false).transactionAdd(trans);
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.save,
        ),
      ),
    );
  }
}
