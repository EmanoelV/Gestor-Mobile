import 'package:flutter/foundation.dart';

class TransactionModel {
  final String id;
  final String client;
  final List products;
  final List<bool> fastSelling; //For client and products
  final DateTime date;

  TransactionModel(
      {@required this.id,
      @required this.client,
      @required this.products,
      @required this.fastSelling,
      @required this.date});
}
