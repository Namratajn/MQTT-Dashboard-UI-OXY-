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

  CreateNewGroupState(this.group,this.appBarTitle);

  @override
  CreateNewGroup createState() => CreateNewGroup(this.group,this.appBarTitle);
}


class CreateNewGroup extends State<CreateNewGroupState>  {

  final String appBarTitle;
  final Group group;



  TextEditingController nameController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();

  int count = 0;

  CreateNewGroup(this.group, this.appBarTitle);

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Group> groupList = [];

  List<ToggleTile> toggleList = [];


  List<List<ToggleTile>> allTiles = [];



  final _formKey = GlobalKey<FormState>();

  bool _showAllTiles = false;

  @override
  void initState(){
    super.initState();
    updateToggleListView();
    updateListView();
    // _parentGroupToggle(group.id);
  }


  // void _parentGroupToggle(int gid) async{
  //   final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  //   dbFuture.then((database) {
  //     Future<List<ToggleTile>> parentToggleListFuture = databaseHelper.fetchGroupToggle(gid);
  //     parentToggleListFuture.then((addGroupToggleList) {
  //       setState(() {
  //         this.addToggle = addGroupToggleList;
  //         this.count = addGroupToggleList.length;
  //       });
  //     });
  //   });
  // }

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
    nameController.text = group.groupName;
    discriptionController.text = group.groupDescription;



    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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

                  Text('Group Content'),

                  Expanded(
                    child: getAllTileshere(),
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

          allTiles.insert(0, addToggle);
          print(allTiles);



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
                group.groupName = nameController.text;
                group.groupDescription = discriptionController.text;
                // group.groupName=addToggle.toString();

                //_parentGroupToggle(group.id);
              }
            }
            _save(context);

          }


          // for(int i = 0 ; i <addToggle.length;i++){
          //   print('this is the addtoggle tile ${addToggle[i].parentGroupId}    bfuebfhc ${addToggle[i].tileName}');
          // }

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



    if (appBarTitle == 'Edit Note') {
      result = await databaseHelper.updateGroup(group);
    } else {
      result = await databaseHelper.insertGroup(group);
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



  GridView getAllTileshere() {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisExtent: 120,
            mainAxisSpacing: 10
        ),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: ListTile(
                leading: Checkbox(
                  value : _tileAddCheckBox[index],
                  activeColor: Colors.green,
                  onChanged:(value){
                    setState(() {
                          _tileAddCheckBox[index] = value! ;
                          if(_tileAddCheckBox[index]==true){
                            addToggle.add(toggleList[index]);
                          }else{
                            addToggle.remove(toggleList[index]);
                          }
                    });
                  }
                ),


                title: Text(this.toggleList[index].tileName),

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
        }, itemCount: toggleList.length,
      );
    }





  List<bool> _switchOnOffList =  List<bool>.filled(30,false);

  List<ToggleTile> addToggle = [];




}

