import 'package:flutter/material.dart';

class FormParcelar extends StatefulWidget {
  Function(int interval, int parcelas) callBack;

  FormParcelar(this.callBack);

  @override
  _FormParcelarState createState() => _FormParcelarState();
}

class _FormParcelarState extends State<FormParcelar> {
  List<bool> intervalSelected;
  int interval;
  int parcelas;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    intervalSelected = [false, true, false];
    interval = 30;
    parcelas = 2;
  }

  void updateConfig() {
    if (intervalSelected[0]) {
      print('semanal');
      widget.callBack(7, parcelas);
    } else if (intervalSelected[1]) {
      print('mensal');
      widget.callBack(30, parcelas);
    } else {
      print('anual');
      widget.callBack(365, parcelas);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(' Periodo: '),
              ToggleButtons(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Semanal'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Mensal'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Anual'),
                  ),
                ],
                isSelected: intervalSelected,
                onPressed: (idx) {
                  setState(() {
                    intervalSelected = [
                      false,
                      false,
                      false,
                    ];

                    intervalSelected[idx] = true;
                    updateConfig();
                  });
                },
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 2,
              child: SizedBox(),
            ),
            Flexible(
              flex: 3,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      parcelas = int.parse(value);
                      updateConfig();
                    },
                    initialValue: '2',
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      border: InputBorder.none,
                      suffix: Text('x'),
                      isDense: true,
                      prefix: Text('Quantidade: '),
                      labelStyle: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: SizedBox(),
            ),
          ],
        ),
      ],
    );
  }
}
