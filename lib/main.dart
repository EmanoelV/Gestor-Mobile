import 'package:Fick/controller/provider.dart';
import 'package:Fick/views/pages/client/client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

enum Register { sell, buy, client, item }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyProvider(),
      child: MaterialApp(
        title: 'Fick',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ClientPage(),
      ),
    );
  }
}
