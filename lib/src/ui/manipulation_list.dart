import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do_list/src/utils/constants.dart';
import '../models/list_model.dart';
import '../utils/database_helper.dart';
import './editable_list.dart';

import 'landing_list.dart';

class ListManipulation extends StatefulWidget {
  @override
  _ListManipulationState createState() => new _ListManipulationState();
}
//This is the second screen of the app which will allow the user to save/update/delete tasks

class _ListManipulationState extends State<ListManipulation> {
  List<ListModel> items = new List();
  DatabaseHelper db = new DatabaseHelper();
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    getLists();
  }

  getLists() {
    items.clear();
    db.getAllTasks().then((tasks) {
      setState(() {
        tasks.forEach((task) {
          items.add(ListModel.fromMap(task));
          items.sort((b, a) => a.id.compareTo(b.id));
        });
      });
    });
  }

  Future<bool> _onBackPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LandingList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.topLeft,
                        colors: [Constants.darkTeal, Constants.lightTeal])),
                height: 150,
                child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      CircleAvatar(
                        backgroundColor: Constants.white,
                        radius: 25,
                        child: SvgPicture.asset(AssetUrls.editSvg,
                            width: 55, height: 30),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Edit Tasks!',
                        style: TextStyle(fontSize: 30, color: Constants.white),
                      )
                    ]))),
            Expanded(
                child: SizedBox(
                    child: Container(
              child: (items.length <= 0)
                  ? Container(
                      padding: EdgeInsets.fromLTRB(40, 150, 40, 100),
                      child: Column(children: [
                        Icon(
                          Icons.sentiment_dissatisfied,
                          color: Constants.lightBlue,
                          size: 70,
                        ),
                        SizedBox(height: 30),
                        Text(
                          'No Tasks',
                          style: TextStyle(
                            fontSize: 30,
                            color: Constants.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      padding: const EdgeInsets.all(15.0),
                      itemBuilder: (context, position) {
                        final keyValue = items[position].title;
                        return Dismissible(
                            // Specify the direction to swipe and delete
                            direction: DismissDirection.endToStart,
                            key: Key(keyValue),
                            onDismissed: (direction) {
                              // Removes that item the list on swipe

                              _deleteTask(context, items[position], position);

                              // Shows the information on Snackbar
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text("Task Deleted")));
                            },
                            background: Container(
                                color: Constants.teal,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('Delete',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Constants.white,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.delete,
                                        color: Constants.white,
                                      ),
                                      SizedBox(width: 10),
                                    ])),
                            child: Card(
                                child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        width: 8.0, color: Constants.teal)),
                              ),
                              child: ListTile(
                                title: Text('${items[position].title}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                subtitle: Text('${items[position].description}',
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                                trailing: Container(
                                  child: Column(
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _navigateToTask(
                                            context, items[position]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )));
                      }),
            ))),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Constants.teal,
                child: Text(
                  'Back',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Constants.white),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LandingList()),
                ),
              ),
              RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Constants.teal,
                  child: Text(
                    'Add',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Constants.white),
                  ),
                  onPressed: () => showBottomSheetToAddTask()),
            ])
          ],
        ),
      ),
    );
  }

  void _deleteTask(BuildContext context, ListModel task, int position) async {
    db.deleteTask(task.id).then((tasks) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToTask(BuildContext context, ListModel task) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditableListScreen(task)),
    );

    if (result == 'update') {
      db.getAllTasks().then((tasks) {
        setState(() {
          items.clear();
          tasks.forEach((task) {
            items.add(ListModel.fromMap(task));
          });
        });
      });
    }
  }

// Bottomsheet to add new task
  void showBottomSheetToAddTask() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (builder) {
          return Scaffold(
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                  child: Container(
                height: 500,
                decoration: BoxDecoration(
                    color: Constants.lightGrey,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(50.0),
                        topRight: const Radius.circular(50.0))),
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Add Task',
                      style: TextStyle(fontSize: 20, color: Constants.teal),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: titleController,
                      decoration: new InputDecoration(
                        filled: true,
                        fillColor: Constants.lightGrey,
                        labelText: "Title",
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: descriptionController,
                      decoration: new InputDecoration(
                        filled: true,
                        fillColor: Constants.lightGrey,
                        labelText: "Description",
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                    Padding(padding: new EdgeInsets.all(5.0)),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Constants.teal,
                      child: Text(
                        'Add',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Constants.white),
                      ),
                      onPressed: () {
                        db
                            .saveTask(ListModel(titleController.text,
                                descriptionController.text))
                            .then((_) {
                          Navigator.pop(context);
                          getLists();
                        });
                        titleController.clear();
                        descriptionController.clear();
                      },
                    ),
                  ],
                ),
              )));
        });
  }
}
