import 'dart:io';
import 'package:Fick/controller/clientController.dart';
import 'package:Fick/controller/itemController.dart';
import 'package:Fick/model/clientModel.dart';
import 'package:Fick/model/itemModel.dart';
import 'package:Fick/model/transactionModel.dart';
import 'package:flutter/material.dart';

class MyProvider with ChangeNotifier {
  List<ItemModel> _items = [];
  List<ItemModel> itemForSell = [];
  List<ClientModel> _clients = [];
  List<TransactionModel> _transactions = [];
  bool itemSending = false;
  bool itemLoading = true;
  bool clientLoading = true;
  DateTime dateTransaction;

  set setDateTransaction(newDate) {
    dateTransaction = newDate;
  }

  List<ItemModel> get items => [..._items];
  List<ClientModel> get clients => [..._clients];
  List<TransactionModel> get transactions => [..._transactions];

  MyProvider() {
    itemLoad();
    clientLoad();
  }

  // TRANSACTIONS ACTIONS
  List<TransactionModel> _organizeParcelas(TransactionModel transaction) {
    List<TransactionModel> transactions = [];
    int interval = transaction.interval;
    String title = transaction.title;
    TransactionModel tempTransaction;

    DateTime newDate(DateTime date, int interval, int parcela) {
      int year = date.year;
      int month = date.month;
      int day = date.day;
      print(interval);
      if (interval == 30) {
        return month == 12
            ? DateTime.parse('${year + 1}-01-$day')
            : DateTime.parse(
                '$year-${(month + parcela - 1) >= 10 ? '' : '0'}${month + parcela - 1}-${day > 9 ? "" : "0"}$day');
      } else if (interval == 365) {
        return DateTime.parse(
            '${year + parcela - 1}-${month > 9 ? "" : "0"}$month-${day > 9 ? "" : "0"}$day');
      } else {
        return date.add(Duration(days: interval * parcela));
      }
    }

    for (var i = 1; i <= transaction.parcelas; i++) {
      tempTransaction = new TransactionModel.clone(transaction);
      tempTransaction.title = '$title x$i';
      tempTransaction.date = newDate(transaction.date, interval, i);
      tempTransaction.isPaid = i > 1 ? false : tempTransaction.isPaid;
      transactions.add(tempTransaction);
    }
    return transactions;
  }

  void transactionAdd(TransactionModel transaction) {
    if (transaction.interval == 0) {
      transaction.copyProducts.forEach((element) {
        for (int i = 0; i < _items.length; i++) {
          if (_items[i].id == element.id) {
            _items[i].estoque -= element.estoque;
            break;
          }
        }
      });
      _transactions.add(transaction);
    } else {
      _transactions.addAll(_organizeParcelas(transaction));
    }

    notifyListeners();
  }

  void addItemForSell(item) {
    itemForSell.add(item);
    notifyListeners();
  }

  void transactionEdit() {}

  void transactionRemove(int idx) {
    _transactions.remove(_transactions[idx]);
    notifyListeners();
  }

  void transactionRead() {}

  // END TRANSACTIONS ACTIONS

  // CLIENT ACTIONS
  void cientAdd(ClientModel client) async {
    _clients.add(client);
    notifyListeners();
    client.id = await ClientControler().add(client);
    _clients.remove(client);
    _clients.add(client);
    notifyListeners();
  }

  void clientEdit(ClientModel client, int idx) async {
    ClientControler().update(client);
    _clients[idx] = client;
    notifyListeners();
  }

  void clientRemove(int idx) {
    ClientControler().remove(_clients[idx].id);
    _clients.remove(_clients[idx]);
    notifyListeners();
  }

  Future clientLoad() async {
    clientLoading = false;
    List<ClientModel> clients = await ClientControler().readAll();
    _clients.clear();
    clients.isNotEmpty
        ? _clients.addAll(clients)
        : print('Nenhum cliente encontrado');
    clientLoading = true;
    notifyListeners();
    return;
  }
  // END CLIENT ACTIONS

  // ITEM ACTIONS
  void itemAdd(ItemModel item, {File img}) async {
    itemSending = true;
    _items.add(item);
    notifyListeners();
    img == null
        ? item.img = null
        : item.img = await ItemController().sendImg(img);
    item.id = await ItemController().create(item);
    _items.remove(item);
    _items.add(item);
    itemSending = false;
    notifyListeners();
  }

  void itemEdit(ItemModel item, int idx, {File img}) async {
    itemSending = true;
    if (img != null) {
      _items[idx] = item;
      notifyListeners();
      item.img = await ItemController().sendImg(img, oldImg: item.img);
      ItemController().update(item);
      _items[idx] = item;
      itemSending = false;
      notifyListeners();
    } else {
      ItemController().update(item);
      _items[idx] = item;
      itemSending = false;
      notifyListeners();
    }
  }

  void itemIncrementEstoque(int idx, int newValue) async {
    itemSending = true;
    ItemController().increment(_items[idx].id, newValue);
    _items[idx].estoque = newValue;
    itemSending = false;
    notifyListeners();
  }

  void itemRemove(int idx) async {
    itemSending = true;
    if (_items[idx].img != null) ItemController().removeImg(_items[idx].img);
    ItemController().remove(_items[idx].id);
    _items.remove(_items[idx]);
    itemSending = false;
    notifyListeners();
  }

  Future itemLoad() async {
    itemLoading = false;
    List<ItemModel> products = await ItemController().readAll();
    _items.clear();
    products.isNotEmpty
        ? _items.addAll(products)
        : print('Nenhum produto encontrado');
    itemLoading = true;
    notifyListeners();
    return;
  }
  // END ITEM ACTIONS
}
