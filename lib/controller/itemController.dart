import 'dart:convert';
import 'dart:io';
import 'package:Fick/model/itemModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class ItemController {
  final _urlBase = 'https://projetodetestes-2357.firebaseio.com/products';

  removeImg(String imgLink) async {
    print('Removendo imagem...');
    String imgId = RegExp('.{8}-.{4}-.{4}-.{4}-.{12}').stringMatch(imgLink);
    FirebaseStorage.instance
        .ref()
        .child('/products/$imgId')
        .delete()
        .then((value) => print('Imagem removida'));
  }

  sendImg(File img, {String oldImg}) async {
    if (oldImg != null) removeImg(oldImg);
    print('Enviando imagem');
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('/products/${Uuid().v1().toString()}');
    StorageUploadTask uploadTask = ref.putFile(img);
    await uploadTask.onComplete;
    print('Imagem enviada');
    String urlImg = await ref.getDownloadURL();
    return urlImg;
  }

  create(ItemModel product) async {
    String id;
    try {
      print('Enviando produto...');
      final resp = await post(_urlBase + '.json',
          body: json.encode({
            'title': product.title,
            'value': product.value,
            'newValue': product.newValue,
            'estoque': product.estoque,
            'date': product.date.toIso8601String(),
            'img': product.img
          }));

      id = json.decode(resp.body)['name'];
      print('Produto foi enviado');

      return id;
    } catch (e) {
      print(e);
      this.create(product);
    }
  }

  update(ItemModel product) async {
    try {
      print('Enviando atualização...');

      await patch(_urlBase + '/' + product.id + '.json',
          body: json.encode({
            'title': product.title,
            'value': product.value,
            'newValue': product.newValue,
            'estoque': product.estoque,
            'date': product.date.toIso8601String(),
            'img': product.img
          }));
      print('Atualizado');
    } catch (e) {
      print(e);
    }
  }

  increment(String id, int value) async {
    try {
      print('Atualizando estoque...');
      await patch(_urlBase + '/' + id + '.json',
          body: json.encode({'estoque': value}));
      print('Estoque atualizado!');
    } catch (e) {
      print(e);
    }
  }

  remove(String id, {String oldImg}) async {
    try {
      print('Deletando produto...');
      await delete(_urlBase + '/' + id + '.json');
      print('Produto removido!');
    } catch (e) {
      print(e);
    }
  }

  readAll() async {
    try {
      print('Carregando produtos...');
      List<ItemModel> productList = [];
      final resp = await get(_urlBase + '.json');
      await json.decode(resp.body).forEach((key, value) {
        productList.add(ItemModel(
            title: value['title'],
            id: key,
            value: value['value'],
            newValue: value['newValue'],
            estoque: value['estoque'],
            img: value['img'],
            date: DateTime.parse(value['date'])));
      });
      print('Produtos carregados!');
      return productList;
    } on NoSuchMethodError {
      return [];
    } catch (e) {
      print('Erro: ' + e.toString());
      this.readAll();
    }
  }
}
