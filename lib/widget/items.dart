// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:todo_app/widget/model.dart';

class ItemsToDo extends StatelessWidget {
  final MyItems myItems;
  final onChanged;
  final onDelete;
  const ItemsToDo(
      {super.key,
      required this.myItems,
      required this.onChanged,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onChanged(myItems);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.grey[800],
        leading: Icon(
          myItems.isDone
              ? Icons.check_box_outlined
              : Icons.check_box_outline_blank_outlined,
          color: Color(0xFFC19F54),
        ),
        title: Text(
          myItems.itemsText!,
          style: TextStyle(color: Colors.white),
        ),
        trailing: SizedBox(
          height: 35,
          width: 35,
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              padding: EdgeInsets.all(5),
              onPressed: () {
                onDelete(myItems.id);
              },
              icon: Icon(Icons.delete_outline_rounded),
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}