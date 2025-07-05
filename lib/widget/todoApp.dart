// ignore_for_file: file_names, non_constant_identifier_names, library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Models/model.dart';
import 'package:todo_app/widget/items.dart';

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});

  @override
  _ToDoAppState createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  final List<MyItems> brandNames = [];
  final textController = TextEditingController();
  final searchController = TextEditingController();
  List<MyItems> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = brandNames;
    loadItems();
    searchController.addListener(
      filterItems,
    ); // Add a listener to the search box
  }

  @override
  void dispose() {
    searchController.dispose();
    textController.dispose();
    super.dispose();
  }

  filterItems() {
    final query = searchController.text.toLowerCase(); // Get the search query
    setState(() {
      filteredItems =
          brandNames.where((item) {
            return item.itemsText!.toLowerCase().contains(
              query,
            ); // Filter items by text
          }).toList();
    });
  }

  Future<void> storeItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> itemsList =
        brandNames
            .map(
              (item) => {
                'id': item.id,
                'text': item.itemsText,
                'isDone': item.isDone,
              },
            )
            .toList();
    prefs.setString('items', jsonEncode(itemsList));
    if (kDebugMode) {
      print('Saved to SharedPreferences: ${jsonEncode(itemsList)}');
    }
  }

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsData = prefs.getString('items');
    if (kDebugMode) {
      print('Loaded from SharedPreferences: $itemsData');
    } 
    if (itemsData != null) {
      final List<dynamic> itemsList = jsonDecode(itemsData);
      setState(() {
        brandNames.clear();
        filteredItems.clear();
        brandNames.addAll(
          itemsList.map(
            (item) => MyItems(
              id: item['id'],
              itemsText: item['itemsText'],
              isDone: item['isDone'] ?? false,
            ),
          ),
        );
        filteredItems = List.from(brandNames);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        child: const Text(
                          'TODO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ...(filteredItems.isEmpty
                          ? [
                            SizedBox(height: 80),
                            Center(
                              child: Icon(
                                Icons.list_alt,
                                color: Colors.grey.shade600,
                                size: 100,
                              ),
                            ),
                            Center(
                              child: Text(
                                'No items',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ]
                          : filteredItems
                              .map(
                                (myItems) => ItemsToDo(
                                  myItems: myItems,
                                  onChanged: _myListItemChanged,
                                  onDelete: _myListItemDelete,
                                ),
                              )
                              .toList()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      boxShadow: [
                        BoxShadow(color: Colors.black, blurRadius: 10.0),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: textController,
                      cursorColor: Colors.white30,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Add new Items',
                        hintStyle: TextStyle(color: Colors.white30),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10, right: 20),
                  child: ElevatedButton(
                    onPressed: AddNewItems,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50, 50),
                      backgroundColor: Color(0xFFC19F54),
                      elevation: 20,
                      shape: CircleBorder(),
                    ),
                    child: Text(
                      '+',
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _myListItemChanged(MyItems myItems) {
    setState(() {
      myItems.isDone = !myItems.isDone;
    });
    storeItems();
  }

  _myListItemDelete(String id) {
    setState(() {
      brandNames.removeWhere((item) => item.id == id);
      filteredItems = brandNames; // Update filtered list
    });
    storeItems();
  }

  AddNewItems() {
    final newItemText = textController.text.trim();
    if (newItemText.isNotEmpty) {
      setState(() {
        brandNames.add(
          MyItems(id: DateTime.now().toString(), itemsText: newItemText),
        );
        filteredItems = brandNames; // Update filtered list
        textController.clear();
      });
      storeItems();
    }
  }

  Widget searchBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextFormField(
          controller: searchController,
          cursorColor: Colors.white30,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Color(0xFFC19F54), size: 20),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.white30),
          ),
        ),
      ),
    );
  }
}
