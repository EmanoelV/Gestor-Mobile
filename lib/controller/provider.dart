import 'dart:io';
import 'package:Fick/model/item/itemModel.dart';
import 'package:Fick/model/cliente/clientModel.dart';
import 'package:Fick/model/cliente/clientModelData.dart';
import 'package:Fick/model/item/itemModelData.dart';
import 'package:Fick/model/transaction/transactionModelData.dart';
import 'package:flutter/material.dart';

class MyProvider with ChangeNotifier {
  List<ItemModelData> _items = [];
  List<ItemModelData> itemForSell = [];
  List<ClientModelData> _clients = [];
  List<TransactionModelData> _transactions = [];
  bool itemSending = false;
  bool itemLoading = true;
  bool clientLoading = true;
  DateTime dateTransaction;

  set setDateTransaction(newDate) {
    dateTransaction = newDate;
  }

  List<ItemModelData> get items => [..._items];
  List<ClientModelData> get clients => [..._clients];
  List<TransactionModelData> get transactions => [..._transactions];

  MyProvider() {
    itemLoad();
    clientLoad();
  }

  // TRANSACTIONS ACTIONS
  List<TransactionModelData> _organizeParcelas(
      TransactionModelData transaction) {
    List<TransactionModelData> transactions = [];
    int interval = transaction.interval;
    String title = transaction.title;
    TransactionModelData tempTransaction;

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
      tempTransaction = new TransactionModelData.clone(transaction);
      tempTransaction.title = '$title x$i';
      tempTransaction.date = newDate(transaction.date, interval, i);
      tempTransaction.isPaid = i > 1 ? false : tempTransaction.isPaid;
      transactions.add(tempTransaction);
    }
    return transactions;
  }

  void transactionAdd(TransactionModelData transaction) {
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
  void cientAdd(ClientModelData client) async {
    _clients.add(client);
    notifyListeners();
    client.id = await ClientModel().add(client);
    _clients.remove(client);
    _clients.add(client);
    notifyListeners();
  }

  void clientEdit(ClientModelData client, int idx) async {
    ClientModel().update(client);
    _clients[idx] = client;
    notifyListeners();
  }

  void clientRemove(int idx) {
    ClientModel().remove(_clients[idx].id);
    _clients.remove(_clients[idx]);
    notifyListeners();
  }

  Future clientLoad() async {
    clientLoading = false;
    List<ClientModelData> clients = await ClientModel().readAll();
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
  void itemAdd(ItemModelData item, {File img}) async {
    itemSending = true;
    _items.add(item);
    notifyListeners();
    img == null ? item.img = null : item.img = await ItemModel().sendImg(img);
    item.id = await ItemModel().create(item);
    _items.remove(item);
    _items.add(item);
    itemSending = false;
    notifyListeners();
  }

  void itemEdit(ItemModelData item, int idx, {File img}) async {
    itemSending = true;
    if (img != null) {
      _items[idx] = item;
      notifyListeners();
      item.img = await ItemModel().sendImg(img, oldImg: item.img);
      ItemModel().update(item);
      _items[idx] = item;
      itemSending = false;
      notifyListeners();
    } else {
      ItemModel().update(item);
      _items[idx] = item;
      itemSending = false;
      notifyListeners();
    }
  }

  void itemIncrementEstoque(int idx, int newValue) async {
    itemSending = true;
    ItemModel().increment(_items[idx].id, newValue);
    _items[idx].estoque = newValue;
    itemSending = false;
    notifyListeners();
  }

  void itemRemove(int idx) async {
    itemSending = true;
    if (_items[idx].img != null) ItemModel().removeImg(_items[idx].img);
    ItemModel().remove(_items[idx].id);
    _items.remove(_items[idx]);
    itemSending = false;
    notifyListeners();
  }

  Future itemLoad() async {
    itemLoading = false;
    List<ItemModelData> products = await ItemModel().readAll();
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
