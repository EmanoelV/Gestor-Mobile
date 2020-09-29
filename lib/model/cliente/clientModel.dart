import 'dart:convert';
import 'package:Fick/model/cliente/clientModelData.dart';
import 'package:http/http.dart';

class ClientModel {
  final _urlBase = 'https://projetodetestes-2357.firebaseio.com/clients';

  add(ClientModelData client) async {
    String id;
    print('Enviando cliente...');
    final resp = await post(_urlBase + '.json',
        body: json.encode({
          'name': client.name,
          'endereco': client.endereco,
          'aniversario': client.aniversario != null
              ? client.aniversario.toIso8601String()
              : client.aniversario,
          'date': client.date.toIso8601String(),
          'numero': client.numero,
        }));
    print('Cliente enviando');
    id = json.decode(resp.body)['name'];
    return id;
  }

  readAll() async {
    try {
      print('Carregando clientes...');
      List<ClientModelData> clientList = [];
      final resp = await get(_urlBase + '.json');
      await json.decode(resp.body).forEach((key, value) {
        clientList.add(ClientModelData(
            name: value['name'],
            endereco: value['endereco'],
            aniversario: value['aniversario'] != null
                ? DateTime.parse(value['aniversario'])
                : null,
            numero: value['numero'],
            id: key,
            date: DateTime.parse(value['date'])));
      });
      print('Clientes carregados!');
      return clientList;
    } on NoSuchMethodError {
      return [];
    } catch (e) {
      print('Erro: ' + e.toString());
      this.readAll();
    }
  }

  remove(String id) async {
    try {
      print('Deletando produto...');
      await delete(_urlBase + '/' + id + '.json');
      print('Produto removido!');
    } catch (e) {
      print(e);
    }
  }

  update(ClientModelData client) async {
    try {
      print('Enviando atualização...');
      await patch(_urlBase + '/' + client.id + '.json',
          body: json.encode({
            'name': client.name,
            'endereco': client.endereco,
            'aniversario': client.aniversario != null
                ? client.aniversario.toIso8601String()
                : client.aniversario,
            'numero': client.numero,
            'date': client.date.toIso8601String(),
          }));
      print('Atualizado');
    } catch (e) {
      print(e);
    }
  }
}
