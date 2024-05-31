import 'dart:async';
import 'package:first_oxy_project/models/toggle_on_off.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:first_oxy_project/models/group.dart';

class DatabaseHelper{

  static DatabaseHelper? _databaseHelper ; // singleton database helper
  static  Database? _database  ; //singleton database

  String groupTable = 'group_table';
  String colId='id';
  String colGroupName='groupName';
  String colGroupDescription='groupDescription';
  String colDate='date';
  String colParentGroupTiles = 'allTilesOfGroup';
 // List<List<String>> colParemtGroup=[];


  String toggleTable = 'toggle_table';
  String toggleId='toggleId';
  String tileName='tileName';
  String onValue ='onValue';
  String offValue='offValue';
  String toggleDate='date';
  // String parentGroupId = 'parentGroupId';


  DatabaseHelper._createInstance();


  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async{
    if(_database==null){
      _database = await initializeDatabase();
    }
    return _database!;
  }


  Future<Database> initializeDatabase() async{

    Directory directory =  await getApplicationDocumentsDirectory();
    String path = directory.path +'group.db';
    // String databasePath = await getDatabasesPath();
    // String path = databasePath+'group.db';

    print('hello i m in your databse');


    var groupDatabase = await openDatabase(path,version: 1,onCreate: _createDb);

    return groupDatabase;


  }




  void _createDb (Database db , int newVersion) async{
    
    await db.execute('CREATE TABLE $groupTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colGroupName TEXT, $colGroupDescription TEXT, $colDate TEXT ,$colParentGroupTiles TEXT)');

    await db.execute('CREATE TABLE IF NOT EXISTS $toggleTable($toggleId INTEGER PRIMARY KEY AUTOINCREMENT,$tileName TEXT,'
   '$onValue TEXT, $offValue TEXT,$toggleDate TEXT)');

  }


  Future<List<Map<String,dynamic>>>getGroupMapList() async{

    Database db = await this.database;
    //var result = await db.rawQuery('SELECT * FROM $groupTable order by $colPriority ASC');
    var result = await db.query(groupTable,orderBy:'$colDate ASC ');

    return result ;

  }

  // to get from toggle
  Future<List<Map<String,dynamic>>>getToggleMapList() async{
    Database db = await this.database;
    var result = await db.query(toggleTable,orderBy: '$toggleDate ASC');

    return result ;

  }

  //to insert in the group
  Future<int> insertGroup(Group group) async{
    Database db = await this.database;
    int result = await db.insert(groupTable, group.toMap() );
    return result;
  }


  //to insert in the toggle
  Future<int> insertToggle(ToggleTile toggle) async{
    Database db = await this.database;
    int result = await db.insert(toggleTable, toggle.toMapToggle() );
    return result;
  }



  Future<int> updateGroup(Group group) async{
    var db = await this.database;
    var result = await db.update(groupTable, group.toMap(),where: '$colId = ?',whereArgs:[group.id] );

    return result;
  }

  //update for toggle table
  Future<int> updateToggle(ToggleTile toggle) async{
    var db = await this.database;
    var result = await db.update(toggleTable, toggle.toMapToggle(),where: '$toggleId = ?',whereArgs:[toggle.id] );

    return result;
  }


  Future<int> deleteGroup(int id) async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $groupTable WHERE $colId = $id');
    return result;
  }

  //delete from toggle
  Future<int> deleteToggle(int toggleid) async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $toggleTable WHERE $toggleId = $toggleid');
    return result;
  }

  Future<int?> getCount() async{
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $groupTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  } //may be type int can be a problem in it


  // getcount for toggle
  Future<int?> getCountToggle() async{
    Database db = await this.database;
    List<Map<String,dynamic>> y = await db.rawQuery('SELECT COUNT (*) from $toggleTable');
    int? result = Sqflite.firstIntValue(y);
    return result;
  }




   Future<List<Group>> getGroupList() async{
    var groupMapList = await getGroupMapList();
    int count = groupMapList.length;

    List<Group> groupList = [];
    for(int i = 0 ; i <count;i++){
      groupList.add(Group.fromMapObject(groupMapList[i]));
    }
    return groupList ;
   }

   //retrivel for toggle

  Future<List<ToggleTile>> getToggleList() async{
    var toggleMapList = await getToggleMapList();
    int count = toggleMapList.length;

    List<ToggleTile> toggleList = [];
    for(int i = 0 ; i <count;i++){
      toggleList.add(ToggleTile.fromMapObject(toggleMapList[i]));
    }
    return toggleList ;
  }




  // fetch data of each group's toggle tiles
  // Future<List<ToggleTile>> fetchGroupToggle(int group_id) async{
  //
  //   // var parentGroupToggleMapList = await getToggleMapList();
  //   Database db = await this.database ;
  //
  //   List<Map<String,dynamic>> parentGroupToggleMapList = await db.query(toggleTable,where: '$parentGroupId = ?',whereArgs: [parentGroupId]);
  //
  //   int count = parentGroupToggleMapList.length;
  //
  //   List<ToggleTile> addGroupToggle = [];
  //
  //   for(int i = 0 ; i <count;i++){
  //     addGroupToggle.add(ToggleTile.fromMapObject(parentGroupToggleMapList[i]));
  //   }
  //
  //   return addGroupToggle ;
  //
  // }


  Future close() async {
    final db = await this.database;
    db.close();
  }



}