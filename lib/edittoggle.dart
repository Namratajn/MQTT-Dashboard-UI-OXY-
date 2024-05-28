import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:first_oxy_project/models/toggle_on_off.dart';
import 'package:first_oxy_project/utils/database_helpeer.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:first_oxy_project/models/group.dart';

class EditTileToggle extends StatefulWidget {
  final String appBarTitle;
  final ToggleTile toggle;

  EditTileToggle(this.toggle,this.appBarTitle);

  @override
  EditTileToggleState createState() => EditTileToggleState(this.toggle,this.appBarTitle);
}


class EditTileToggleState extends State<EditTileToggle>{



  final String appBarTitle ;
  final ToggleTile toggle ;


  TextEditingController tileNameController  = TextEditingController();
  TextEditingController onController=TextEditingController();
  TextEditingController offController=TextEditingController();

  EditTileToggleState(this.toggle,this.appBarTitle);

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<ToggleTile> toggleList = [];


  List<Group> groupList = [];

  int count = 0 ;




  @override
  void initState(){
    super.initState();
    updateToggleListView();
    updateListView();
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Group>> groupListFuture = databaseHelper.getGroupList();
      groupListFuture.then((groupList) {
        setState(() {
          this.groupList = groupList;
          this.count = groupList.length;
        });
      });
    });
  }


  void updateToggleListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ToggleTile>> toggleListFuture = databaseHelper
          .getToggleList();
      toggleListFuture.then((toggleList) {
        setState(() {
          this.toggleList = toggleList;
          this.count = toggleList.length;
        });
      });
    });
  }



  @override
  Widget build(BuildContext context) {



    tileNameController.text=toggle.tileName;
    onController.text=toggle.onValue;
    offController.text=toggle.offValue;



    return Scaffold(
      resizeToAvoidBottomInset :false ,
      appBar: AppBar(
        title: Text(this.appBarTitle),
      ),
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade400,
                        ),
                        child: Icon(Icons.question_mark_outlined),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        height: 60,
                        width: 280,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                          ),
                        ),
                        child: TextFormField(
                          controller: tileNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            prefixIcon: Icon(Icons.speaker_group_outlined),
                            hintText: 'Tile name'
                          ),
                          // onChanged: (value){
                          //   debugPrint('Something changed in title text field');
                          //   updateTileName();
                          // },
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal ,
                    child: Row(
                      children: [
                        Card(
                          color:Colors.grey.shade400,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Show as shortcut'),
                            ),
                          ),
                        Card(
                          color:Colors.grey.shade400,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('compact layout'),
                          ),
                        ),
                        Card(
                          color:Colors.grey.shade400,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Paint camera'),
                          ),
                        ),
                        Card(
                          color:Colors.grey.shade400,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Show as shortcut'),
                          ),
                        ),
                        Card(
                          color:Colors.grey.shade400,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Show as shortcut'),
                          ),
                        )
                      ],
                    ),
                  ),

                  Divider(height:10,thickness: 1,) ,

                  Container(
                    margin: EdgeInsets.only(bottom: 10,top: 10),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          prefixIcon: Icon(Icons.download_sharp),
                          hintText: 'Subscribe topic'
                      ),
                    ),
                  ),


                  Container(
                    margin: EdgeInsets.only(bottom: 10,top: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          prefixIcon: Icon(Icons.publish_rounded),
                          hintText: 'Publish topic',
                         suffixIcon: Icon(Icons.copy)
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Card(
                        color: Colors.grey.shade300,
                        margin: EdgeInsets.only(bottom: 10,top: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:  Row(
                             children: [
                               Icon(Icons.check_circle),
                               Text('  '),
                               Text('Enable publishing'),
                             ],
                           ),
                        ),
                      ),
                      Card(

                        color: Colors.grey.shade300,
                        margin: EdgeInsets.only(bottom: 10,top: 10,left: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Confirm publishing'),
                        ),
                      )
                    ],
                  ),

                  Text('Warning ,the tile status gets updated only on incoming messages on the subscribe topic; if you plan to use a different publish topic the tile probably wont be updated.'),
                  Divider(height:10,thickness: 1,) ,


                  Container(
                    height: 10,
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade400,
                        ),
                        child: Icon(Icons.question_mark_outlined),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        height: 60,
                        width: 280,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: TextFormField(
                          controller: onController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              prefixIcon: Icon(Icons.chat_bubble_outline),
                              hintText: 'On Value'
                          ),



                          // onChanged: (value){
                          // debugPrint('Something changed in title text field');
                          // updateOnValue();
                          //
                        //},

                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade400,
                        ),
                        child: Icon(Icons.question_mark_outlined),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        height: 60,
                        width: 280,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: TextFormField(
                          controller: offController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              prefixIcon: Icon(Icons.chat_bubble_outline),
                              hintText: 'Off value'
                          ),


                          // onChanged: (value){
                          //   debugPrint('Something changed in title text field');
                          //   updateOffValue();
                          // },



                        ),
                      )
                    ],
                  ),

                  Container(
                    height: 10,
                  ),
                  Divider(height:10,thickness: 1,) ,

                  Container(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(Icons.equalizer),
                      Text('      '),
                      Text('Quality of Service',style: TextStyle(fontSize: 20),),
                      Text('                              '),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),


                  Container(
                    height: 10,
                  ),
                  Divider(height:10,thickness: 1,) ,

                  Container(
                    height: 10,
                  ),

                  Row(
                    children: [
                      Icon(Icons.code),
                      Text('      '),
                      Text('JSON extraction',style: TextStyle(fontSize: 20),),
                      Text('                                  '),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),

                  Container(
                    height: 10,
                  ),

                  Divider(height:10,thickness: 1,) ,

                  Container(
                    height: 10,
                  ),

                  Row(
                    children: [
                      Icon(Icons.notes),
                      Text('      '),
                      Text('Edit output Template',style: TextStyle(fontSize: 20),),
                      Text('                        '),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),

                  Container(
                    height: 10,
                  ),

                  Divider(height:10,thickness: 1,) ,

                  Container(
                    height: 10,
                  ),

                  Row(
                    children: [
                      Icon(Icons.notifications_outlined),
                      Text('      '),
                      Text('Notification settings',style: TextStyle(fontSize: 20),),
                      Text('                        '),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),

                  Container(
                    height: 10,
                  ),

                  Divider(height:10,thickness: 1,) ,

                  Container(
                    height: 10,
                  ),

                  Row(
                    children: [
                      Icon(Icons.edit),
                      Text('      '),
                      Text('Tunable parameters',style: TextStyle(fontSize: 20),),
                      Text('                         '),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),

                  Container(
                    height: 20,
                  ),
                ],
              )


            ],
          ),
        ),
      ),

      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(95.0)
        ),
        onPressed: (){


          if (tileNameController.text.isEmpty || onController.text.isEmpty  || offController.text.isEmpty) {
            Fluttertoast.showToast(msg: 'The Form field should not be empty');
          } else {
            print(toggleList);
            print(tileNameController.text);
            if(toggleList.isEmpty){
              toggle.tileName = tileNameController.text;
              toggle.onValue = onController.text;
              toggle.offValue = offController.text;
            }
            for (int i = 0; i < toggleList.length; i++) {
              print('the element in the  group list fab button at index $i is ${toggleList[i]
                  .tileName}');
              if (toggleList[i].tileName == tileNameController.text && appBarTitle == 'Add Tile') {
                print('The item is matched with the groupname ${toggleList[i]
                    .tileName} at this index $i');
                Fluttertoast.showToast(msg: 'The Tile already exist');
                return ;
              } else{
                    toggle.tileName = tileNameController.text;
                    toggle.onValue = onController.text;
                    toggle.offValue = offController.text;
              }
            }
            _save(context);
          }

          //Navigator.pop(context,true);

          //_save(context);


        },
        child: Icon(Icons.save,size: 30,color:Colors.white,),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        notchMargin: 5,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.arrow_back_outlined),
            Icon(Icons.info_outline)

          ],
        ),
      ),
      
    );
  }


  void updateTileName(){
    toggle.tileName = tileNameController.text;
  }
  void updateOnValue(){
    toggle.onValue=onController.text;
  }

  void updateOffValue(){
    toggle.offValue=offController.text;
  }




  void _save(BuildContext context) async{

      Navigator.pop(context,true);


    toggle.date = DateFormat.yMMMd().format(DateTime.now());

    int result ;
    // if(toggleList[toggleList.length].tileName.contains(toggle.tileName)){
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Group Name already exists'),
    //     ),
    //   );
    //   return ;
    // }


      if (appBarTitle == 'Edit Tile') {
        result = await databaseHelper.updateToggle(toggle);
      } else {
        result = await databaseHelper.insertToggle(toggle);
        Fluttertoast.showToast(
            msg: "Insert",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            fontSize: 10.0
        );
      }

    //result = await databaseHelper.insertToggle(toggle);


    print("The Id is Which is saved in the database ${toggle.tileName}");


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data saved into database'),
      ),
    );

    if(result != 0){

      Fluttertoast.showToast(
          msg: "tile Saved successfully",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          fontSize: 10.0
      );
    }
    else{

      Fluttertoast.showToast(
          msg: "Error occured while saving tile",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          fontSize: 10.0
      );
    }

  }


  void _delete(BuildContext context) async{
    if(toggle.id == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No tile Was deleted'),
        ),
      );
      return ;
    }

    int result = await databaseHelper.deleteToggle(toggle.id);
    if(result != 0 ){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('tile Was deleted'),
        ),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occured'),
        ),
      );
    }

  }



}