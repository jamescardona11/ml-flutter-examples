import 'package:flutter/material.dart';

List<Widget> convertMapToList(BuildContext context, screens) {
  List<Widget> listItems = [];
  screens.forEach(
    (key, value) => listItems.add(
      Card(
        child: ListTile(
          title: Text(key, style: TextStyle()),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => value)),
        ),
      ),
    ),
  );

  return listItems;
}
