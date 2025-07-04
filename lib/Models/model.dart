class MyItems {
  String? id;
  String? itemsText;
  bool isDone;
  MyItems({
    required this.id,
    required this.itemsText,
    this.isDone = false,
  });
  static List<MyItems> itemsList() {
    return [
      MyItems(id: '01', itemsText: 'Vintapay Card'),
      MyItems(id: '02', itemsText: 'Addidas'),
      MyItems(id: '03', itemsText: 'Paypal'),
      MyItems(id: '04', itemsText: 'Netflix'),
      MyItems(id: '05', itemsText: 'Airways'),
      MyItems(id: '06', itemsText: 'Amazon'),
      MyItems(id: '07', itemsText: 'Itunes'),
      MyItems(id: '08', itemsText: 'WellsFargo'),
    ];
  }
}