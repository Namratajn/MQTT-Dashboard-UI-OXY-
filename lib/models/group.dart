
import 'dart:convert';

class Group{

  int? _id;
  String? _groupName;
  String? _groupDescription;
  String? _date;
  String? _parentGroupOfTiles ;



  Group(this._groupName, this._groupDescription, this._date,[this._parentGroupOfTiles]) ;

  Group.withId(this._id, this._groupName, this._groupDescription, this._date,[this._parentGroupOfTiles]);

  int get id => _id ?? 0 ;
  String get date => _date!;
  String get groupDescription => _groupDescription!;
  String get groupName => _groupName!;



  String get parentGroupOfTiles => _parentGroupOfTiles ?? jsonEncode([['5']]) ;
      //'no tiles' ;


  set parentGroupOfTiles(String value) {

      _parentGroupOfTiles = value;


  }

  set date(String value) {
    _date = value;
  }


  set groupDescription(String value) {
    if(value.length<=255){
      _groupDescription = value;
    }
  }


  set groupName(String value) {
    if(value.length<=255){
      _groupName = value;
    }
  }


  Map<String, dynamic > toMap(){
    var map= Map<String, dynamic>();
    if(id != null){
      map['id']=_id;
    }
    //map['id']=_id;
    map['groupName']= _groupName;
    map['groupDescription']= _groupDescription;
    map['date']=_date;
    map['allTilesOfGroup']=_parentGroupOfTiles;

    return map;
  }


  Group.fromMapObject(Map<String,dynamic> map){
    this._id =map['id'] ;
    this._groupName=map['groupName'];
    this._groupDescription=map['groupDescription'];
    this._date=map['date'];
    this._parentGroupOfTiles= map['allTilesOfGroup'];

  }

}