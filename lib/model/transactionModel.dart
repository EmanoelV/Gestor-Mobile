import 'package:Fick/model/clientModel.dart';
import 'package:Fick/model/itemModel.dart';

class TransactionModel {
  DateTime date = DateTime.now();
  int parcelas;
  int interval;
  String id;
  bool isPaid;
  String desc;
  String title;
  double total;
  ClientModel copyClient;
  List<ItemModel> copyProducts;

  TransactionModel(
      {this.id,
      this.isPaid,
      this.total,
      this.title,
      this.copyClient,
      this.copyProducts,
      this.desc,
      this.date,
      this.interval,
      this.parcelas});

  TransactionModel.clone(TransactionModel transaction) {
    this.id = transaction.id;
    this.isPaid = transaction.isPaid;
    this.total = transaction.total;
    this.title = transaction.title;
    this.copyClient = transaction.copyClient;
    this.copyProducts = transaction.copyProducts;
    this.desc = transaction.desc;
    this.date = transaction.date;
    this.interval = transaction.interval;
    this.parcelas = transaction.parcelas;
  }
}
