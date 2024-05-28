class ToggleTile{

  int? _toggleid;
  String? _tileName;
  String? _onValue;
  String? _offValue;
  String? _date;
  //int? _parentGroupId ;


  //String _quesMark = "?";



  ToggleTile( this._tileName, this._onValue,
      this._offValue,this._date);

  ToggleTile.withId(this._toggleid,this._tileName, this._onValue,
      this._offValue,this._date);

  int get id => _toggleid!;



  String get offValue => _offValue!;

  set offValue(String value) {
    _offValue = value;
  }

  String get onValue => _onValue!;

  set onValue(String value) {
    _onValue = value;
  }

  String get tileName => _tileName!;

  set tileName(String value) {
    _tileName = value;
  }

  String get date => _date!;

  set date(String value) {
    _date = value;
  }


  // int get parentGroupId => _parentGroupId!;
  //
  // set parentGroupId(int value) {
  //   _parentGroupId = value;
  // } // making group name asa foreign key



  // foreign key parent group


  Map<String, dynamic > toMapToggle(){
    var map= Map<String, dynamic>();
    if( id != null){
      map['toggleId']=_toggleid;
    }
    //map['id']=_id;
    map['tileName']= _tileName;
    map['onValue']= _onValue;
    map['offValue']=_offValue;
    //map['quesMark']= _quesMark;
    map['date']=_date;

    //map['parentGroupId']=_parentGroupId;

    return map;

  }

  ToggleTile.fromMapObject(Map<String,dynamic> map){
    this._toggleid =map['toggleId'];
    this._tileName=map['tileName'];
    this._onValue=map['onValue'];
    this._offValue=map['offValue'];
    // this._quesMark=map['quesMark'];
    this._date=map['date'];

    //this._parentGroupId=map['parentGroupId'];

  }

}