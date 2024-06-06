import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../models/brokers_model.dart';
import '../utils/database_helpeer.dart';
import 'manage_broker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateManageBroker extends StatefulWidget{

  final String appBarTitle ;
  final Brokers brokers;

  CreateManageBroker(this.appBarTitle,this.brokers);

  @override
  State<StatefulWidget> createState() {
      return CreateManageBrokerState(this.appBarTitle,this.brokers);
  }

}

class CreateManageBrokerState extends State<CreateManageBroker>{



  final Brokers brokers;
  final String appBarTitle ;

  CreateManageBrokerState(this.appBarTitle,this.brokers);

  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Brokers> brokerList = [];

  int count = 0 ;

  @override
  void initState() {
    super.initState();
    //updateBrokerList();
  }



  // void updateBrokerList() async{
  //   final Future<Database> dbfuture = databaseHelper.initializeDatabase();
  //   dbfuture.then((database){
  //     Future<List<Brokers>> brokerListFuture = databaseHelper.getBrokerList();
  //     brokerListFuture.then((brokerList){
  //       setState(() {
  //         this.brokerList = brokerList;
  //         this.count = brokerList.length ;
  //       });
  //     });
  //   });
  // }

  // this is the main build function which will return a scaffold
  @override
  Widget build(BuildContext context){

    if(appBarTitle == 'Edit Broker'){
       brokerNameController.text = brokers.brokerName ;
       brokerAddressController.text = brokers.brokerAddress;
      brokerPortController.text = brokers.brokerPort ;
          brokerClientIdController.text = brokers.brokerClientId ;
      brokerKeepAliveController.text =brokers.brokerAliveInterval;


         brokerUserNameController.text=brokers.userName;
         brokerPasswordController.text=brokers.password;

    }


    return Scaffold(

      appBar: AppBar(

        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(this.appBarTitle,),
        ),

      ),

      resizeToAvoidBottomInset: false,
      
      body : form(),
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          for(int i = 0 ; i <brokerList.length;i++){
            print(brokerList[i].brokerName);
            print(brokerList[i].userName);
          }
          print('save');
          toCheckTextControllers();


        },
        backgroundColor: Colors.pink.shade900,
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(95)
        ),
        child: Icon(Icons.save,color: Colors.white,),

      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


      bottomNavigationBar: BottomAppBar(
        notchMargin: 7,
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> Broker()));
              }, icon:Icon(Icons.arrow_back)),



              Icon(Icons.info_outline)

            ],
          ),
        ),
      ),
    );

  }



  TextEditingController brokerNameController = TextEditingController();
  TextEditingController brokerAddressController = TextEditingController();
  TextEditingController brokerPortController = TextEditingController();
  TextEditingController brokerClientIdController = TextEditingController();
  TextEditingController brokerKeepAliveController = TextEditingController();
  TextEditingController brokerPasswordController = TextEditingController();
  TextEditingController brokerUserNameController = TextEditingController();

  // bool checkBox= false ;

  List<bool> checkBox = List.filled(10,false);

  bool checkBox2= false ;
  bool ss = false ;

  int ind = 0 ;

  // return a form for body
  Widget form(){


    // bool hello ;
    if(ss ==false){
      ss = true ;
      if(brokers.password.isNotEmpty || brokers.userName.isNotEmpty){
        checkBox[brokers.brokerId] = true ;
      }
      for(int i = 0 ; i < brokerList.length;i++){

      }
    }



    return Form(child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(children: [
          textFormFields('Broker Name',brokerNameController,Icon(Icons.speaker_group)),
          Container(height: 10,),
          Divider(thickness: 1,),
          Container(height: 10,),
          textFormFields('Address',brokerAddressController,Icon(Icons.wordpress)),
          Container(height: 5,),
          Center(child: Text('Comprising of protocol (tcp://,ssl://...)')),
          Container(height: 5,),
          textFormFields('Port',brokerPortController,Icon(Icons.import_export)),

          Container(height: 10,),
          Divider(thickness: 1,),
          Container(height: 10,),

          textFormFields('Client Id',brokerClientIdController,Icon(Icons.contact_page_outlined)),
          Center(child: Text('Must be unique. The connection might be unstable otherwise')),
          Container(height: 10,),
          Divider(thickness: 1,),
          Container(height: 10,),

          Row(
            children: [
              Checkbox(value: checkBox[brokers.brokerId] ,
              //_checkJson = jsonDecode(brokers.brokerProtectionCheck),
                  onChanged: (newvalue){
                setState(() {
                  checkBox[brokers.brokerId]=newvalue!;

                  if(checkBox[brokers.brokerId]==false){
                    brokers.userName='';
                    brokers.password='';
                  }

                });
              }),
              Text('Broker protection')
            ],
          ),

          Visibility(
              visible: checkBox[brokers.brokerId],
              child: textFormFields('UserName', brokerUserNameController, Icon(Icons.person_outline))
          ),
          Container(height: 10,),

          Visibility(
               visible: checkBox[brokers.brokerId],
              child: textFormFields('Password', brokerPasswordController, Icon(Icons.key))
          ),

          Container(height: 10,),
          Divider(thickness: 1,),
          Container(height: 10,),


          Row(
            children: [
              Icon(Icons.equalizer),
              Text('      '),
              Text('Use SSL connection',style: TextStyle(fontSize: 20),),
              Text('                        '),
              Icon(Icons.arrow_forward_ios)
            ],
          ),


          Container(height: 10,),
          Divider(thickness: 1,),
          Container(height: 10,),

          Row(
            children: [
              Checkbox(value: checkBox2, onChanged: (newvalue){}),
              Text('Do not connect at startup')
            ],
          ),

          Center(child: Text('if enabled, you will need to manually start the connection from the menu')),

          Divider(thickness: 1,),
          Container(height: 10,),

          textFormFields('Keep alive interval',brokerKeepAliveController,Icon(Icons.access_time_outlined)),


          Container(height: 10,),

          Row(
            children: [
              Checkbox(value: checkBox2, onChanged: (newvalue){}),
              Text('Use Clean Connection')
            ],
          ),

          Container(
            width: double.infinity,
            child: ToggleButtons(children: [
              Text('           QOS 0         '),
              Text('           QOS 1         '),
              Text('           QOS 2         '),
            ], isSelected: selectToggle,
              constraints: BoxConstraints(
                minHeight: double.infinity,
                maxWidth: double.infinity
              ),
            ),
          ),

            Text('Will be used for all subscriptions related to this broker'),

            Container(height: 10,),
        ],),
      ),
    ));
    
  }

  List<bool> selectToggle = [false,false,false];

  // return the text fields for the form
  Widget textFormFields(String textFieldName , TextEditingController editingController,Icon icon){
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        )
      ),
      child: TextFormField(
        keyboardType: textFieldName == 'Keep alive interval'
            ? TextInputType.number
            : TextInputType.text,
        controller: editingController,
        decoration: InputDecoration(
          hintText: textFieldName,
          border: OutlineInputBorder(
            borderSide: BorderSide(),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5)
            )
          ),
          prefixIcon: icon,
          suffixText: textFieldName == 'Keep alive interval'
            ? 'sec'
              : '',
          suffixIcon: textFieldName=='Password'
            ? Icon(Icons.remove_red_eye)
            : null
        ),


      ),
    );

  }

  void toCheckTextControllers(){

    if(brokerNameController.text.isEmpty || brokerAddressController.text.isEmpty ||
    brokerPortController.text.isEmpty || brokerClientIdController.text.isEmpty || brokerKeepAliveController.text.isEmpty){
      Fluttertoast.showToast(msg: 'Form field cant be empty');
      return ;
    }else{
      if(brokerList.isEmpty){
        brokers.brokerName = brokerNameController.text.trim() ;
        brokers.brokerAddress=brokerAddressController.text.trim();
        brokers.brokerPort = brokerPortController.text.trim();
        brokers.brokerClientId = brokerClientIdController.text.trim();
        brokers.brokerAliveInterval=brokerKeepAliveController.text.trim();
        // brokers.brokerProtectionCheck= jsonEncode(checkBox);
        brokers.userName = brokerUserNameController.text.trim();
        brokers.password=brokerPasswordController.text.trim();
      }

      for(int i = 0 ; i <brokerList.length;i++){
        if(brokerList[i].brokerName == brokerNameController.text && appBarTitle == 'Add Broker'){
          Fluttertoast.showToast(msg: 'The broker Name already exist');
          return ;
        }else{
          brokers.brokerName = brokerNameController.text.trim() ;
          brokers.brokerAddress=brokerAddressController.text.trim();
          brokers.brokerPort = brokerPortController.text.trim();
          brokers.brokerClientId = brokerClientIdController.text.trim();
          brokers.brokerAliveInterval=  brokerKeepAliveController.text;
          // brokers.brokerProtectionCheck= jsonEncode(checkBox);
          brokers.userName = brokerUserNameController.text.trim();
          brokers.password=brokerPasswordController.text.trim();
        }
      }

      _save(context);

    }



  }

  void _save(BuildContext context) async{
    Navigator.pop(context,true);

    brokers.date = DateFormat.yMMMd().format(DateTime.now());

    if(appBarTitle =='Edit Broker'){
      await databaseHelper.updateBroker(brokers);
    }else{
      await databaseHelper.insertBroker(brokers);
      Fluttertoast.showToast(msg: 'the broker is saved');
    }
  }






}