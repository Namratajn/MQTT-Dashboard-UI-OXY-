import 'package:first_oxy_project/main.dart';
import 'package:first_oxy_project/utils/database_helpeer.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/brokers_model.dart';
import 'create_edit_broker.dart';

class Broker extends StatefulWidget{
  @override
  State<Broker> createState() {
    return ManageBrokerState();
  }
}

class ManageBrokerState extends State<Broker>{

  //Brokers? brokers ;
  List<Brokers> brokerList = [];
  int count = 0 ;
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    // brokerList;
    updateBrokerList();
    _showbrokerList();
  }

  @override
  Widget build(BuildContext context) {

    if(brokerList == null){
      brokerList=[];
      updateBrokerList();
    }


    return Scaffold(
      appBar: AppBar(

        automaticallyImplyLeading: false,
        title: Text('Brokers',

        ),
      ),

      body: _showbrokerList(),
      //Center(child: Text('Brokers to be added')),



      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigateToCreateBroker('Add Broker',Brokers('','','','','','','',''));
        },
        backgroundColor: Colors.pink.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(95)
        ),
        child: Icon(Icons.add,size: 30,color: Colors.white,),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(

        notchMargin: 7,
          shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: Row(
          children: [
            IconButton(onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                         return MyHomePage(title: 'Xh');
                     } ) );
            },icon: Icon(Icons.arrow_back)

            )
          ],
        ),
      ),

    );
  }




  void navigateToCreateBroker(String title ,Brokers brokers) async{

    bool? result = await Navigator.push(context,
      MaterialPageRoute(builder: (context){
        return CreateManageBroker(title,brokers);
      }
      )
    );

    if(result == true){
      updateBrokerList();
    }
  }


  void updateBrokerList() async{
    final Future<Database> dbfuture = databaseHelper.initializeDatabase();
    dbfuture.then((database){
      Future<List<Brokers>> brokerListFuture = databaseHelper.getBrokerList();
      brokerListFuture.then((brokerList){
        setState(() {
          this.brokerList = brokerList;
          this.count = brokerList.length ;
        });
      });
    });
  }


  ListView _showbrokerList(){

    return ListView.builder(itemBuilder: (BuildContext context, int index){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(this.brokerList[index].brokerName),
              subtitle: Text(this.brokerList[index].brokerAddress),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: (){
                      navigateToCreateBroker('Edit Broker', this.brokerList[index]);
                      // Navigator.push(context, MaterialPageRoute(builder: (context){
                      //   return CreateManageBroker('Edit Broker', brokerList[index]);
                      // }));
                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: (){
                      _delete(brokerList[index]);
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),

            Divider(thickness: 1,)
          ],
        ),
      );
    },
    itemCount: brokerList.length
    );

  }

  void _delete(Brokers brokers) async{
    if(brokers.brokerId == null){
      Fluttertoast.showToast(msg: 'No broker has deleted');
    }
    int result = await databaseHelper.deleteBroker(brokers.brokerId);
    if(result != 0){
      Fluttertoast.showToast(msg: 'broker is deleted');
      updateBrokerList();
    }else{
      Fluttertoast.showToast(msg: 'error occured');
    }
  }

}