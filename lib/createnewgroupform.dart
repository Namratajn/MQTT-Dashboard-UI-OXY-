import 'dart:convert';
import 'package:first_oxy_project/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first_oxy_project/models/group.dart';
import 'package:first_oxy_project/utils/database_helpeer.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'models/toggle_on_off.dart';
import 'package:provider/provider.dart';
import 'package:first_oxy_project/Providers/show_tiles_groups.dart';


class CreateNewGroupState extends StatefulWidget {
  final String appBarTitle;
  final Group group;
  final List<dynamic> xyz ;

  CreateNewGroupState(this.group,this.appBarTitle,this.xyz);

  @override
  CreateNewGroup createState() => CreateNewGroup(this.group,this.appBarTitle,this.xyz);
}


class CreateNewGroup extends State<CreateNewGroupState>  {

  final String appBarTitle;
  final Group group;
  final List<dynamic> xyz ;



  TextEditingController nameController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();

  int count = 0;

  CreateNewGroup(this.group, this.appBarTitle,this.xyz);

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Group> groupList = [];

  List<ToggleTile> toggleList = [];




  List<bool> _switchOnOffList = List<bool>.filled(30,false);

  List<ToggleTile> addToggle = [];



  // allTiles list is a list of list that will store the data of all type of tiles

  final _formKey = GlobalKey<FormState>();

  bool _showAllTiles = false;


  @override
  void initState(){
    super.initState();
    updateToggleListView();
    updateListView();
    print(xyz);
    print(toggleList);
    //_switchOnOffList;

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

    if(this.appBarTitle == 'Edit Note'){
      nameController.text = group.groupName;
      discriptionController.text = group.groupDescription;
    }


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(this.appBarTitle)
      ),
      body: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        // Set the radius here
                        color: Colors.grey
                            .shade300, // Set the background color here
                      ),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            prefixIcon: Icon(Icons.speaker_group_outlined),
                            hintText: 'Group name'
                        ),
                        //
                        // onChanged: (value){
                        //   updateGroupName();
                        // },

                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the name please';
                          }
                          if (value.contains(group.groupName)) {
                            'The group name already exists';
                          }
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        // Set the radius here
                        color: Colors.grey
                            .shade300, // Set the background color here
                      ),
                      child: TextFormField(
                        controller: discriptionController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            prefixIcon: Icon(Icons.notes),
                            hintText: 'Group description'
                        ),
                        // onChanged: (value){
                        //   debugPrint('Something changed in title text field');
                        //   updateGroupDesc();
                        // },
                      ),
                    ),
                  ),
                  Divider(height: 30, thickness: 1,),

                  Text('Tiles Content'),

                  Expanded(

                    child : toggleList.isEmpty
                        ? Container()
                        : getAllTileshere(),
                  ),
                ],
              ),
      ),



      floatingActionButton: FloatingActionButton(
        onPressed: () {



          for(int i = 0 ; i< groupList.length;i++){
            print(groupList[i].groupName);
          }

          for(int i = 0 ; i <addToggle.length;i++){
            print('this is the addtoggle tile ${addToggle[i].tileName}');
          }

          List<dynamic> allTiles = [];

          //allTiles.insert(0, addToggle);
          print(allTiles);


          for(int i = 0 ; i < addToggle.length;i++){
              allTiles.add([addToggle[i].tileName,
                addToggle[i].onValue,
                addToggle[i].offValue,
                addToggle[i].date]);
          }

          // for(int i = 0 ; i <allTiles.length;i++){
          //   print(allTiles);
          // }


          print(allTiles);


           String stringOfLists = jsonEncode(allTiles);
          //
          print('bhfrgvijberegtvpbgvtrgrvn $stringOfLists');
          //
          List<dynamic> listofList = jsonDecode(stringOfLists);

          print('bhfrgvvpbgvtrgrvn ${listofList}');



          if (nameController.text.isEmpty || discriptionController.text.isEmpty) {
            Fluttertoast.showToast(msg: 'The Form field should not be empty');
          } else {
            print(groupList);
            print(nameController.text);
            if(groupList.isEmpty){
              group.groupName = nameController.text;
              group.groupDescription = discriptionController.text;
            }
            for (int i = 0; i < groupList.length; i++) {
              print('the element in the  group list fab button at index $i is ${groupList[i]
                  .groupName}');
              if (groupList[i].groupName == nameController.text && appBarTitle == 'Add Group' ) {
                print('The item is matched with the groupname ${groupList[i]
                    .groupName} at this index $i');
                Fluttertoast.showToast(msg: 'The group already exist');
                return ;
              } else{
                group.groupName = nameController.text.trim();
                group.groupDescription = discriptionController.text.trim();
                group.parentGroupOfTiles = stringOfLists ;
                //_parentGroupToggle(group.id);
              }
            }
            _save(context);

          }

        },

        backgroundColor: Colors.pink.shade900,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(95.0)
        ),
        child: Icon(Icons.save, color: Colors.white, size: 30,),

      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        notchMargin: 5,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyHomePage(title: 'Xh');
                }));
              },
              icon: Icon(Icons.arrow_back_outlined, size: 30,),
            ),


            IconButton(
              onPressed: () {
                debugPrint("Delete button clicked");
              },
              icon: Icon(Icons.info_outline),
            )

          ],
        ),

      ),

    );
  }


  void updateGroupName() {
    group.groupName = nameController.text;
  }

  void updateGroupDesc() {
    group.groupDescription = discriptionController.text;
  }


  void _save(BuildContext context) async {


    Navigator.pop(context, true) ;

    // if(group.id != null){
    //   result = await databaseHelper.updateGroup(group);
    // }else{
    //   result = await databaseHelper.insertGroup(group);
    // }

    group.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    print("The app bar title is $appBarTitle");
    // print("the list is ${group.parentGroupOfTiles}");



    if (appBarTitle == 'Edit Note') {
      result = await databaseHelper.updateGroup(group);
    } else {
      result = await databaseHelper.insertGroup(group);

      Fluttertoast.showToast(
          msg: "Insert",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          fontSize: 10.0
      );
    }



    print("The Id is Which is saved in the database ${group.id}");

    // if(result != 0){
    //   Fluttertoast.showToast(
    //       msg: "Group Saved successfully",
    //       toastLength: Toast.LENGTH_SHORT,
    //       timeInSecForIosWeb: 1,
    //       fontSize: 10.0
    //   );
    // }else{
    //   Fluttertoast.showToast(
    //       msg: "Error occured while saving group",
    //       toastLength: Toast.LENGTH_SHORT,
    //       timeInSecForIosWeb: 1,
    //       fontSize: 10.0
    //   );
    // }
  }



    void _delete() async {
      if (group.id == null) {
        Fluttertoast.showToast(
            msg: "no group has deleted",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            fontSize: 10.0
        );
        return;
      }

      int result = await databaseHelper.deleteGroup(group.id);
      if (result != 0) {
        Fluttertoast.showToast(
            msg: "Group Deleted successfully",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            fontSize: 10.0
        );
      } else {
        Fluttertoast.showToast(
            msg: "Error occured while deleting group",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            fontSize: 10.0
        );
      }
    }



  List<bool> _tileAddCheckBox =  List<bool>.filled(30,false);
// bool s=false;
// bool ss1(bool tileAddCheckBox){
//   print(s);
//   for(int i = 0 ; i < toggleList.length;i++){
//     for(int j = 0 ; j < xyz.length;j++){
//       if(toggleList[i].tileName == xyz[j][0]) {
//         // {
//         // _tileAddCheckBox[i] = true;
//         s=true;
//         print("case match");
//         print(s);
//         // return true;
//       }else{
//         s=false;
//         print("case not match");
//         print(s);
//         // return false;
//       }
//         // print('yes you got it ${toggleList[i].tileName} is your equal to ${xyz[j][0]} ');
//
//       // }
//     }
//   }
//   return s;
// }

bool sss=false;
bool sssss= false ;

  GridView getAllTileshere() {

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisExtent: 120,
            mainAxisSpacing: 10
        ),



        itemBuilder: (BuildContext context, int index ) {


       if(sss==false){
         sss=true;
          for(int i = 0 ; i < toggleList.length;i++){
            for(int j = 0 ; j < xyz.length;j++){
              if(toggleList[i].tileName == xyz[j][0]){
                _tileAddCheckBox[i] = true;
                print('yes you got it ${toggleList[i].tileName} is your equal to ${xyz[j][0]} ');

              }
            }
          }}


       // if(sssss=false){
       //   sssss=true ;
         if(_tileAddCheckBox[index]==true){
           if(addToggle.contains(toggleList[index])==false){
             print(xyz);
             print(addToggle);
             addToggle.add(toggleList[index]);
           }
           //   else{
           //   addToggle.remove(toggleList[index]);
           // }
         }
       // }




          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: ListTile(
                leading:
          // InkWell(child:
                     Checkbox(
                      value : _tileAddCheckBox[index] ,
                      // value : ss1(_tileAddCheckBox[index]) ,

                      // = true
                      //     ? _tileAddCheckBox[index] = false
                      //     : _tileAddCheckBox[index] ,
                      activeColor: Colors.green,

                      onChanged:(newvalue){
                        setState(() {
                          print(newvalue);
                          print(_tileAddCheckBox[index].toString());

                          // Update the state of the checkbox
                          _tileAddCheckBox[index] = newvalue!;

                          if(_tileAddCheckBox[index] == true){
                            //if(xyz.contains(toggleList[index])==false){
                              addToggle.add(toggleList[index]);
                            //}
                            //addToggle.add(toggleList[index]);
                          }else{
                            //xyz.removeAt(index);
                            addToggle.remove(toggleList[index]);
                          }
                          print(addToggle);
                          print(xyz);
                           for(int i = 0 ; i <addToggle.length;i++){
                             print('your tile name is ${addToggle[i].tileName}');
                           }

                          // if(_tileAddCheckBox[index] == false){
                          //   addToggle.add(toggleList[index]);
                          //   print(addToggle[index]);
                          // }

                          print(newvalue);
                          print(_tileAddCheckBox[index].toString());


                        });
                      }
                  ),
                  // onLongPress: (){
                  //   print(addToggle);
                  //   addToggle.remove(toggleList[index]);
                  // },
                // ),


                title: Text(index < toggleList.length ? toggleList[index].tileName : ''),

                subtitle: Switch(
                  value: _switchOnOffList[index],
                  onChanged: (value){
                    setState(() {
                      _switchOnOffList[index] = value ;
                      value ?
                      Fluttertoast.showToast(msg: 'the on value which is sent to the device is ${this.toggleList[index].onValue}')
                          : Fluttertoast.showToast(msg: 'the off value which is sent to the device is ${this.toggleList[index].offValue}');
                    });
                  },
                ),
              ),

            ),

          );
        }, itemCount: toggleList.length > xyz.length
          ? toggleList.length
          : xyz.length,
      );


    }


}

//var parGroupId= this.group.id;
// if(addToggle.isNotEmpty){
//   for(int i = 0 ; i < addToggle.length;i++){
//     await databaseHelper.insertToggle(ToggleTile(
//         addToggle[i].tileName,
//         addToggle[i].onValue,
//        addToggle[i].offValue,
//         addToggle[i].date,
//         //addToggle[i].parentGroupId=parGroupId
//         ));
//   }
//
//   List<Map<String,dynamic>> childrenToggle = await databaseHelper.getToggleMapList();
//   for(var child in childrenToggle){
//     print('This is the child $child');
//   }

//}
