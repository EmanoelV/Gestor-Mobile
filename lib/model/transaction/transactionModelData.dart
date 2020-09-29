import 'package:Fick/model/cliente/clientModel.dart';
import 'package:Fick/model/item/itemModelData.dart';

class TransactionModelData {
  DateTime date = DateTime.now();
  int parcelas;
  int interval;
  String id;
  bool isPaid;
  String desc;
  String title;
  double total;
  ClientModel copyClient;
  List<ItemModelData> copyProducts;

  TransactionModelData(
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

  TransactionModelData.clone(TransactionModelData transaction) {
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
