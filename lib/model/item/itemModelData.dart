import 'package:flutter/foundation.dart';

class ItemModelData {
  String id;
  String title;
  int estoque;
  double value;
  double newValue;
  DateTime date;
  String img;
  int quantidadeVendida;

  ItemModelData(
      {@required this.id,
      @required this.title,
      @required this.estoque,
      @required this.value,
      @required this.newValue,
      @required this.date,
      this.img,
      this.quantidadeVendida});
}
