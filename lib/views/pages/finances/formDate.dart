import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormDate extends StatefulWidget {
  Function(DateTime date) callBack;

  FormDate(this.callBack);

  @override
  _FormDateState createState() => _FormDateState();
}

class _FormDateState extends State<FormDate> {
  List<bool> dateSelected;
  DateTime date;

  void setDate(newDate) {
    setState(() {
      date = newDate;
    });
    widget.callBack(date);
  }

  void initState() {
    super.initState();
    dateSelected = [true, false, false];
    setDate(DateTime.now());
  }

  void dateSelector(idx) {
    if (idx == 2) {
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(Duration(days: 50)),
              lastDate: DateTime.now().add(Duration(days: 50)))
          .then((value) {
        if (value != null) {
          setDate(value);
        } else {
          dateSelector(0);
        }
      });
    } else if (idx == 1) {
      setDate(DateTime.now().subtract(Duration(days: 1)));
    } else {
      setDate(DateTime.now());
    }

    setState(() {
      dateSelected = [false, false, false];
      dateSelected[idx] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(
                Icons.calendar_today,
                color: Colors.blue,
              ),
              Text(DateFormat('dd/MM/yy').format(date))
            ],
          ),
          ToggleButtons(
            children: <Widget>[
              Text('Hoje'),
              Text('Ontem'),
              Text('Outro'),
            ],
            isSelected: dateSelected,
            onPressed: (idx) => dateSelector(idx),
          ),
        ]);
  }
}
