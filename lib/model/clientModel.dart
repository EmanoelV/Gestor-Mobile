import 'package:flutter/foundation.dart';

class ClientModel {
  String id;
  String name;
  String endereco;
  int numero;
  DateTime aniversario;
  DateTime date;

  ClientModel(
      {this.name,
      this.endereco,
      this.date,
      this.numero,
      this.aniversario,
      this.id});
}
