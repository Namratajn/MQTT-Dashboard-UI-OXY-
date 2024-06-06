import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_oxy_project/createnewgroupform.dart';
import 'package:first_oxy_project/edittoggle.dart';
import 'package:first_oxy_project/models/toggle_on_off.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:first_oxy_project/models/group.dart';
import 'package:first_oxy_project/utils/database_helpeer.dart';
import 'package:provider/single_child_widget.dart';

import 'package:sqflite/sqflite.dart';
import 'package:first_oxy_project/Providers/show_tiles_groups.dart';

import 'Brokers/manage_broker.dart';
import 'models/brokers_model.dart';

void main() {
  runApp(
      MultiProvider(providers: [
          ChangeNotifierProvider(
          create: (context) => ShowGroups()),
      ],
          child : MyApp()
      ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PopUp();
  }
}

class PopUp extends State {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "popup",
        home: MyHomePage(title: 'Flutter Basic Ui'));
  }
}

class MyHomePage extends StatefulWidget {


  final String title;


  MyHomePage({super.key, required this.title });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  bool _enable = false;

  int count = 0;

  var defaultValue ;

  //static var _priorities = ['High', 'Low'];

  bool _showData = false;

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Group> groupList = [];

  List<ToggleTile> toggleList = [];

  List<ToggleTile> addToggle = [];

  List<Brokers> brokerList =[] ;



  void conversionOfString(){

    List<dynamic> allTiles = [];

  for(int i = 0 ; i < groupList.length;i++){
     allTiles = jsonDecode(groupList[i].parentGroupOfTiles);
  }
  print(allTiles);
  print(allTiles.length);
  for(int i = 0 ; i < allTiles.length ;i++){

    print(allTiles[i]);
    print(allTiles[i][i]);

  }

  }



  @override
  void initState(){
    super.initState();
    updateToggleListView();
    updateListView();
    getAllTileshere();
    updateBrokerList();
    _showbrokerList();
    //getGroupListView();
    //_switchOnOffList ;
    // fetchStringToTile();
    // _parentGroupToggle(0);
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



  double aa(){
    for(int i = 0 ; i < groupList.length;i++){
      if(_showExpBoolList[i]==true && toggleList.isNotEmpty){
        return groupList.length * 180 ;
      }

    }
      return groupList.length * 100;
  }

  @override
  Widget build(BuildContext context) {

    if (groupList == null) {
      groupList = [];
      updateListView();
    }

    if(brokerList == null){
      brokerList =[];
      updateBrokerList();
    }

    if(toggleList == null){
      toggleList = [];
      updateToggleListView();
    }

    // if(addToggle == null){
    //   addToggle = [];
    //   _parentGroupToggle(0);
    // }

    return Scaffold(
      resizeToAvoidBottomInset :false ,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Xh",
              style: TextStyle(fontSize: 20),
            )),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                    PopupMenuItem(child: Text("Import/export via Mqtt")),
                    PopupMenuItem(child: Text("Connect")),
                    PopupMenuItem(child: Text("Disconnect")),
                    PopupMenuItem(child: Text("Sort groups")),
                  ])
        ],
      ),


      // Body

      body: ListView(
        scrollDirection: Axis.vertical,

        children: [
          Container(
            height: aa(),
             child: getGroupListView(),
          ),


          // Expanded(
          //   //fit: FlexFit.tight,
          // child:
          InkWell(
              child: SingleChildScrollView(
                child: toggleList.isEmpty
                ? Container()
                : ExpansionTile(

                  title: Text('All Tiles',),
                  // write a condition about on and offvalue
                  trailing: Container(height: 40,
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(_showData ? Icons.arrow_downward
                            : Icons.arrow_forward_ios_rounded,
                        ),
                      ],
                    ),
                  ),
                  children: [
                    SingleChildScrollView(
                      child:Column(
                        children: [
                          Container(
                            height: 250,
                            child: getAllTileshere(),
                          ),
                        ],
                      ) ,
                    )


                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      _showData = expanded;
                    });
                  },

                ),
              ),
              onTap: () {
                debugPrint("ListTile Tapped");
                //navigateToDetail(this.groupList[position],'Edit Note');
              },
            ),
          //)
        ],
      ),





      floatingActionButton: FloatingActionButton(
        tooltip: 'save group details',
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: () {
                          // conversionOfString();


                          Navigator.pop(context); // done with it
                          navigateToDetail(
                              Group('', '', ''), 'Add Group');
                          for(int i =0;i<groupList.length;i++){
                            print('the element in the  group list at index $i is ${groupList[i].groupName}');
                          }
                        },

                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.select_all_outlined,
                                  size: 30,
                                ),

                                Text(
                                      'Create new group',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                Text('                          '),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 30,
                                ),
                              ]),
                        ),
                      ),

                      Divider(
                        height: 40,
                        thickness: 1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Standard',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            'Simple tiles, can send only one command at a time',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {

                                    Navigator.pop(context);
                                    var r = Random();
                                    const _chars = '1234567890';
                                    String expid= List.generate(8, (index) => _chars[r.nextInt(_chars.length)]).join();

                                    navigateToEditTile(ToggleTile.withId(int.parse(expid),'','','',''), 'Add Tile');
                                  },
                                  child: Card(
                                      margin: EdgeInsets.all(8),
                                      shadowColor: Colors.transparent,
                                      color: Colors.white,
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          children: [
                                            Icon(Icons.compare_arrows),
                                            Text('Toggle'),
                                          ],
                                        ),
                                      )),
                                ),
                                Card(
                                    margin: EdgeInsets.all(8),
                                    color: Colors.white,
                                    shadowColor: Colors.transparent,
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.touch_app_outlined),
                                          Text('Button'),
                                        ],
                                      ),
                                    )),
                                Card(
                                    margin: EdgeInsets.all(8),
                                    color: Colors.white,
                                    elevation: 10,
                                    shadowColor: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.text_fields_rounded),
                                          Text('Text'),
                                        ],
                                      ),
                                    )),
                                Card(
                                    margin: EdgeInsets.all(8),
                                    color: Colors.white,
                                    shadowColor: Colors.transparent,
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.onetwothree),
                                          Text('Progress'),
                                        ],
                                      ),
                                    )),
                                Card(
                                    margin: EdgeInsets.all(8),
                                    color: Colors.white,
                                    shadowColor: Colors.transparent,
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.compare_arrows),
                                          Text('Toggle'),
                                        ],
                                      ),
                                    )),
                                Card(
                                    elevation: 10,
                                    color: Colors.white,
                                    shadowColor: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.compare_arrows),
                                          Text('Toggle'),
                                        ],
                                      ),
                                    )),
                                Card(
                                    elevation: 10,
                                    color: Colors.white,
                                    shadowColor: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.compare_arrows),
                                          Text('Toggle'),
                                        ],
                                      ),
                                    )),
                                Card(
                                    elevation: 10,
                                    color: Colors.white,
                                    shadowColor: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.compare_arrows),
                                          Text('Toggle'),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 30,
                        thickness: 1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Compound',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            'Compound tiles combine multiple commands in one entity,allowing you to control your devices more easily. They work with JSON objects',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Row(
                            children: [
                              Card(
                                  color: Colors.white,
                                  elevation: 10,
                                  shadowColor: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Icon(Icons.lightbulb_outline),
                                        Text('Light'),
                                      ],
                                    ),
                                  )),
                              Card(
                                  elevation: 10,
                                  color: Colors.white,
                                  shadowColor: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Icon(Icons.thermostat),
                                        Text('Thermostat'),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );

            },
          );

          },
        backgroundColor: Colors.pink.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(95.0),
        ),
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
          child: SingleChildScrollView(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: _showBottomModelSheetMangaeBroker,
                    icon: Icon(Icons.dehaze)),

                Text("                "),
                Text("      "),

                IconButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: "Now You can Rearrange ",
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                          fontSize: 10.0);
                    },
                    icon: Icon(
                      Icons.lock_outline,
                    )),
                IconButton(onPressed: () {}, icon: Icon(Icons.notes))
              ],
                    ),
          ),
      ),
    );
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
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black,
                child: Text(this.brokerList[index].brokerName[0].toUpperCase() , style: TextStyle(color: Colors.white),) ,
              ),
              title: Text(this.brokerList[index].brokerName),
              subtitle: Text(this.brokerList[index].brokerAddress),
              // trailing: index == 0
              //     ? Text('')
              //     :OutlinedButton(onPressed: (){},child: Text('Pro',style: TextStyle(color: Colors.white),) ,style: ButtonStyle(
              //   backgroundColor: MaterialStateProperty.all(Colors.pink.shade900)
              // ),)
            ),

            // Divider(thickness: 1,)
          ],
        ),
      );
    },
        itemCount: brokerList.length
    );

  }


  //final key = GlobalKey();

  void _showBottomModelSheetMangaeBroker() {
    showModalBottomSheet(
      //onstraints: BoxConstraints(maxHeight: key.currentContext?.size),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
               mainAxisSize: MainAxisSize.min ,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                Container(
                  // height: brokerList.length * 80,
                  height: 160 ,
                  child:_showbrokerList(),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: OutlinedButton(
                    child: Text(
                      'Manage Brokers',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed:navigateToBrokerAdd,
                  ),
                ),
                Divider(
                  height: 30,
                  thickness: 1,
                ),
                Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text(
                        "Settings",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.support),
                      title: Text(
                        "Support the developer",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ListTile(
                        leading: Icon(Icons.dark_mode_outlined),
                        title: Text(
                          "Dark Mode",
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Switch(
                          value: _enable,
                          onChanged: (bool val) {
                            setState(() {
                              _enable = val;
                            });
                          },
                        ))
                  ],
                ),
                Divider(
                  height: 10,
                  thickness: 1,
                ),
                Row(
                  children: [
                    Text('                            Help  * '),
                    Text('About  * '),
                    Text('Unlock pro'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  void navigateToBrokerAdd(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return Broker();
    }) );
  }


  //bool _showExpTile = false ;

  

  List<bool> _showExpBoolList =  List<bool>.filled(30,false);  //





  ListView getGroupListView() {

    List<dynamic> allTiles = [];

    // for(int i = 0 ; i < groupList.length;i++){
    //   allTiles = jsonDecode(groupList[i].parentGroupOfTiles);
    // }

    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(

      scrollDirection: Axis.vertical,
      itemCount :groupList.length,
      itemBuilder: (BuildContext context, int position) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            color: Colors.white,
                        elevation: 2.0,
                        // child: InkWell(
                          child: ExpansionTile(
                            title: Text(
                                this.groupList[position].groupName,
                                style: titleStyle,
                              ),

                            subtitle: Text(this.groupList[position].groupDescription),
                            trailing: Container(
                              height: 40,
                              width: 120,

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(icon: Icon(Icons.edit),
                                  onPressed: (){

                                    navigateToDetail(this.groupList[position],'Edit Note');
                                    // if(groupList[position].parentGroupOfTiles != '5' && toggleList.isNotEmpty){
                                    //   _showAlertDialog();
                                    // }


                                  },) ,
                                  IconButton(icon: Icon(Icons.delete),
                                  onPressed: (){
                                    _delete(context, groupList[position]);
                                  },),
                                  Icon(
                                    _showExpBoolList[position] ? Icons.arrow_downward : Icons.arrow_forward_ios_rounded,
                                  ),

                                ],
                              ),
                            ),
                            children: [
                              Container(
                                height: 150,
                                ////implement the added tiles here
                                // child: groupList[position].parentGroupOfTiles!=null
                                child:
                                // true==true
                                //     ? Text('No tile is present')
                                 //   :
                              getTilesOfGroup(allTiles = jsonDecode(groupList[position].parentGroupOfTiles)),
                                ////
                                //child: ,
                              )
                            ],
                            onExpansionChanged: (bool expanded) {
                                     setState(() {
                                       _showExpBoolList[position] = expanded ;
                                    });
                            }


                          ),


                      ),


        );


      },

    );

  }

  ListView getTileListView() {
    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;

        return ListView.builder(
          itemCount :toggleList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int position) {
            return Card(
              color: Colors.white,
              elevation: 2.0,
              child: InkWell(
                child: ExpansionTile(

                  title: Text('All Tiles',
                    style: titleStyle,
                  ),
// write a condition about on and offvalue
                  trailing: Container(height: 40,
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(icon: Icon(Icons.delete),
                          onPressed: (){
                            _deleteTile(context, toggleList[position]);
                          },),
                        Icon(_showData ? Icons.arrow_downward
                            : Icons.arrow_forward_ios_rounded,
                        ),
                      ],
                    ),
                  ), children: [
                  Row(
                    children: [
                      Card(
                        margin: EdgeInsets.all(8),
                        color: Colors.white,
                        elevation: 10,
                        shadowColor: Colors.transparent,
                        child: Container(
                          width: 150,
                          child: ListTile(
                            leading: Icon(Icons.question_mark_outlined,color: Colors.grey,),
                            title: Text(
                              this.toggleList[position].tileName,
                              style: titleStyle,),
                            subtitle: Text(this.toggleList[position].onValue),//offvalue ke liye bhi condion lagani he

                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      _showData = expanded;
                    });
                  },


                ),
                onTap: () {
                  debugPrint("ListTile Tapped");
//navigateToDetail(this.groupList[position],'Edit Note');
                },
              ),
// else blank

            ) ;


          },

        );


  }


  void _delete(BuildContext context, Group group) async {
    int result = await databaseHelper.deleteGroup(group.id);
    if (result != 0) {
      Fluttertoast.showToast(
          msg: "group is deleted ",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          fontSize: 10.0);
      updateListView();
    }
  }

  void _deleteTile(BuildContext context,ToggleTile toggleTile) async{
    int ind = toggleList.indexOf(toggleTile);
    _switchOnOffList[ind] = _switchOnOffList[ind+1];

    int result = await databaseHelper.deleteToggle(toggleTile.id);
    if(result !=0){
      Fluttertoast.showToast(
          msg: "Tile is deleted ",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          fontSize: 10.0);
      updateToggleListView();
    }
  }

  void navigateToDetail(Group group, String title) async {
    List<dynamic> xyz = [];
    // if(group.parentGroupOfTiles.isEmpty){
    //   xyz=[[ ]];
    // }else {
      xyz = jsonDecode(group.parentGroupOfTiles);
    //}

      bool? result  =
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CreateNewGroupState(group, title,xyz);
      }));
      if (result == true) {
        updateListView();
      }
  }



  void _showAlertDialog(){
    showDialog(context: context,
      builder: (BuildContext context){
        return  AlertDialog(
          title: Text('Rule for updating your CHECKED tiles only'),
          content: Text('if you want your checked tile in your group then SINGLE TAP on it '
              'and if you want to remove that tile then LONG PRESS on it '),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('Ok'))
          ],
        );
      },);
  }

  void navigateToEditTile(ToggleTile toggleTile, String title) async{



    bool? result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return EditTileToggle(toggleTile, title);
    }));

    // this loop is to set the switch value of first one is false only
    for(int i = 0 ; i < toggleList.length;i++){
      // int ind = toggleList.indexOf(toggleTile);
      _switchOnOffList[i] = _switchOnOffList[i+1];
    }
    //
    //

    if (result == true) {
      updateToggleListView();
    }
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

  void updateToggleListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ToggleTile>> toggleListFuture = databaseHelper.getToggleList();
      toggleListFuture.then((toggleList) {
        setState(() {
          this.toggleList = toggleList;
          this.count = toggleList.length;
        });
      });
    });
  }



  List<bool> _switchOnOffList = List<bool>.filled(30,false);

  List<bool> _switchOnOffListinGroup =  List<bool>.filled(30,false);

  GridView getAllTileshere(){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisExtent: 120,
          mainAxisSpacing: 10
      ),
      itemBuilder: ( BuildContext context,int index){

        //_switchOnOffList.insert(index, false);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
              child: Card(
                  child: ListTile(
                   // leading: Icon(Icons.question_mark_outlined,color: Colors.grey),
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

                    trailing: PopupMenuButton(

                      onSelected: (value){
                        if(value==0){
                          navigateToEditTile(this.toggleList[index],'Edit Tile');
                        }else if(value ==1){
                          _deleteTile(context, toggleList[index]);
                        }
                      },
                      //icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                             child: Text("Edit"),
                             value: 0,
                          ),
                          PopupMenuItem(
                            child: Text("Delete"),
                            value: 1,
                          ),
                        ]) ,
                  ),
          
              ),
          
            ),
        );
      }, itemCount: toggleList.length,
    );
  }

  bool _checkValue = true ;
  GridView getTilesOfGroup(List<dynamic> allTiles) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisExtent: 120,
          mainAxisSpacing: 10
      ),
      itemBuilder: ((context, index) {
        return SingleChildScrollView(

          child: Column(
            children: [
              // Text('Toggle'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: allTiles[index][0] == '5'
                     ? Container()
                     : Card(
                  child: ListTile(
                    // leading: Icon(Icons.question_mark_outlined,color: Colors.grey),
                    leading: Text('Toggle'),
                    title: Text(allTiles[index][0]),
                    subtitle: Switch(
                      value: _switchOnOffListinGroup[index],
                      onChanged: (value) {
                        setState(() {
                          _switchOnOffListinGroup[index] = value;
                          value ?
                          Fluttertoast.showToast(
                              msg: 'the on value which is sent to the device is ${allTiles[index][1]}')
                              : Fluttertoast.showToast(
                              msg: 'the off value which is sent to the device is ${allTiles[index][2]}');
                        });
                      },
                    ),


                  ),

                ),

              ),
            ],
          ),
        );
      }),
      itemCount: allTiles.length,


    );
  }


}











//
// ListView.builder(
// itemBuilder: (context,index){
// return Card(
// child: ListTile(
// title: Text(
// allTiles[index][index]
// ),
// ),
// );
// }, itemCount:allTiles.length,
// )
//



// ListTile(
// leading: Icon(
// Icons.account_circle_rounded,
// size: 40,
// color: Colors.black,
// ),
// title: Text(
// 'Xh',
// style: TextStyle(color: Colors.black),
// ),
// subtitle: Text('tcp://103.151.107.44'),
// ),
// ListTile(
// leading: Icon(
// Icons.account_circle_rounded,
// size: 40,
// color: Colors.black,
// ),
// title: Text(
// 'TF',
// style: TextStyle(color: Colors.black),
// ),
// subtitle: Text('tcp://f'),
// trailing: ElevatedButton(
// child: Text('Pro'),
// onPressed: () {
// print('Button pressed');
// },
// ),
// ),
//
