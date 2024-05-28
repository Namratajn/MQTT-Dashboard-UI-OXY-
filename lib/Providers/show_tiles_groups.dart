import 'package:flutter/foundation.dart';
import 'package:first_oxy_project/utils/database_helpeer.dart';
import 'package:first_oxy_project/models/toggle_on_off.dart';
import 'package:sqflite/sqflite.dart';


class ShowGroups extends ChangeNotifier {
  //bool _showData = false ;
  List<ToggleTile> toggleList = [];

  //List<Group> groupList = [] ;

  List<ToggleTile> get tiles => toggleList;

  int count = 0;

  DatabaseHelper databaseHelper = new DatabaseHelper();

  ShowGroups (){
    updateToggleListView();
  }

  void updateToggleListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ToggleTile>> toggleListFuture = databaseHelper
          .getToggleList();
      toggleListFuture.then((toggleList) {
        //setState(() {
        this.toggleList = toggleList;
        this.count = toggleList.length;
        //});
        notifyListeners();
      });
    });
  }
}
