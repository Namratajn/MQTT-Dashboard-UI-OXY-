
class Brokers {

  int? _brokerId ;
  String? _brokerName;
  String? _brokerAddress;
  String? _brokerPort;
  String? _brokerClientId;
  String? _brokerAliveInterval;
  String? _date ;
  // String? _brokerProtectionCheck ;
  String? _userName ;
  String? _password ;


  Brokers(this._brokerName, this._brokerAddress, this._brokerPort,
      this._brokerClientId, this._brokerAliveInterval,this._date, this._userName, this._password);

  Brokers.withId(this._brokerId,this._brokerName, this._brokerAddress, this._brokerPort,
      this._brokerClientId, this._brokerAliveInterval,this._date, this._userName, this._password);


  // String get brokerProtectionCheck => _brokerProtectionCheck!;
  //
  // set brokerProtectionCheck(String value) {
  //   _brokerProtectionCheck = value;
  // }

  String get date => _date!;

  set date(String value) {
    _date = value;
  }

  String get brokerAliveInterval => _brokerAliveInterval!;

  set brokerAliveInterval(String value) {
    _brokerAliveInterval = value;
  }

  String get brokerClientId => _brokerClientId!;

  set brokerClientId(String value) {
    _brokerClientId = value;
  }

  String get brokerPort => _brokerPort!;

  set brokerPort(String value) {
    _brokerPort = value;
  }

  String get brokerAddress => _brokerAddress!;

  set brokerAddress(String value) {
    _brokerAddress = value;
  }

  String get brokerName => _brokerName!;

  set brokerName(String value) {
    _brokerName = value;
  }

  int get brokerId => _brokerId ?? 0;


  Map <String,dynamic> toMapBroker(){
    var map = Map<String,dynamic>();
    if(brokerId != null){
      map['brokerId']=_brokerId;
    }
    map['brokerName']=_brokerName;
    map['brokerAddress']=_brokerAddress;
    map['brokerPort']=_brokerPort;
    map['brokerClientId']=_brokerClientId;
    map['brokerAliveInterval']=_brokerAliveInterval;
    map['brokerDate']=_date;
   // map['brokerProtectionCheck'] = _brokerProtectionCheck;

    //if(brokerProtectionCheck=='true'){
      map['brokerUserName']=_userName;
      map['brokerPassword']=_password;
    //}
    return map ;
  }

  Brokers.fromMapObjectBroker(Map<String,dynamic> map){

    this._brokerId = map['brokerId'];
    this._brokerName=map['brokerName'];
    this._brokerAddress=map['brokerAddress'];
    this._brokerPort=map['brokerPort'];
    this._brokerClientId=map['brokerClientId'];
    this._brokerAliveInterval=map['brokerAliveInterval'];
    this._date=map['brokerDate'];
   // this._brokerProtectionCheck=map['brokerProtectionCheck'];
    this._userName= map['brokerUserName'];
    this._password=map['brokerPassword'];

  }

  String get userName => _userName!;

  String get password => _password!;

  set password(String value) {
    _password = value;
  }

  set userName(String value) {
    _userName = value;
  }

}