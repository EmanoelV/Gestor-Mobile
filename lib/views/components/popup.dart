import 'package:flutter/material.dart';

class MenuItemModel {
  final String title;
  final String value;
  final Icon icon;

  MenuItemModel({
    @required this.title,
    @required this.value,
    @required this.icon,
  });
}

class Popup extends StatelessWidget {
  Function(String value) actions;
  Function() mySetState;
  List menuItens;
  Icon icon;

  Popup({this.actions, this.menuItens, this.icon});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: icon,
        onSelected: (value) => actions(value),
        itemBuilder: (_) => <PopupMenuEntry>[
              ...menuItens.map((menuItem) {
                return PopupMenuItem(
                    value: menuItem.value,
                    child: ListTile(
                      title: Text(menuItem.title),
                      leading: menuItem.icon,
                    ));
              }),
            ]);
  }
}
