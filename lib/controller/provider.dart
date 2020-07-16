import 'dart:io';

import 'package:Fick/controller/clientController.dart';
import 'package:Fick/controller/itemController.dart';
import 'package:Fick/model/clientModel.dart';
import 'package:Fick/model/itemModel.dart';
import 'package:flutter/material.dart';

class MyProvider with ChangeNotifier {
  List<ItemModel> _items = [];
  List<ClientModel> _clients = [];
  bool itemSending = false;
  bool itemLoading = true;
  bool clientLoading = true;

  List<ItemModel> get items => [..._items];
  List<ClientModel> get clients => [..._clients];

  MyProvider() {
    itemLoad();
    clientLoad();
  }

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
