import 'package:Fick/model/clientModel.dart';
import 'package:Fick/model/itemModel.dart';
import 'package:Fick/model/transactionModel.dart';

class Data {
  List<ClientModel> clientList = [
    ClientModel(
        name: 'Nome do Cliente',
        endereco: 'Endereço do cliente',
        id: '1',
        date: DateTime.now()),
    ClientModel(
        name: 'Nome do Cliente',
        endereco: 'Endereço do cliente',
        id: '2',
        date: DateTime.now()),
    ClientModel(
        name: 'Nome do Cliente',
        endereco: 'Endereço do cliente',
        id: '3',
        date: DateTime.now()),
  ];

  List transactionList = [
    TransactionModel(
        id: '1',
        client: 'Client name',
        products: [
          {'name': 'Nome do produto 1', 'value': 10.0},
          {'name': 'Nome do produto 2', 'value': 2.0}
        ],
        fastSelling: [true, true],
        date: DateTime.now()),
    TransactionModel(
        id: '1',
        client: 'Client name',
        products: [
          {'name': 'Nome do produto 1', 'value': 10.0},
          {'name': 'Nome do produto 1', 'value': 10.0},
          {'name': 'Nome do produto 1', 'value': 10.0},
          {'name': 'Nome do produto 1', 'value': 10.0},
          {'name': 'Nome do produto 1', 'value': 10.0},
          {'name': 'Nome do produto 1', 'value': 10.0},
          {'name': 'Nome do produto 1', 'value': 10.0},
          {'name': 'Nome do produto 1', 'value': 10.0},
          {'name': 'Nome do produto 1', 'value': 10.0},
          {'name': 'Nome do produto 1', 'value': 10.0},
          {'name': 'Nome do produto 1', 'value': 10.0},
          {'name': 'Nome do produto 1', 'value': 10.0},
          {'name': 'Nome do produto 2', 'value': 20.0}
        ],
        fastSelling: [true, true],
        date: DateTime.now()),
  ];

  List itemList = [
    ItemModel(
      id: '1',
      title: 'Nome do produto',
      estoque: 20,
      value: 14.99,
      newValue: 28.99,
      date: DateTime.now(),
    ),
    ItemModel(
      id: '2',
      title: 'Nome do produto',
      estoque: 20,
      value: 15.10,
      newValue: 298.99,
      date: DateTime.now(),
    ),
    ItemModel(
      id: '3',
      title: 'Nome do produto',
      estoque: 20,
      value: 1.81,
      newValue: 8.99,
      date: DateTime.now(),
    ),
  ];
}
