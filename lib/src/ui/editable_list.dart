import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_list/src/ui/manipulation_list.dart';
import 'package:to_do_list/src/utils/constants.dart';
import '../models/list_model.dart';
import '../utils/database_helper.dart';

class EditableListScreen extends StatefulWidget {
  final ListModel task;
  EditableListScreen(this.task);

  @override
  State<StatefulWidget> createState() => new _EditableListScreenState();
}
//This screen allows the user to edit the selected task

class _EditableListScreenState extends State<EditableListScreen> {
  DatabaseHelper db = new DatabaseHelper();

  TextEditingController _titleController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _titleController = new TextEditingController(text: widget.task.title);
    _descriptionController =
        new TextEditingController(text: widget.task.description);
  }

  Future<bool> _onBackPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListManipulation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(15),
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
                          child: SvgPicture.asset(AssetUrls.updateSvg,
                              width: 55, height: 30),
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Update!',
                          style:
                              TextStyle(fontSize: 30, color: Constants.white),
                        )
                      ]))),
              SizedBox(height: 30),
              Container(
                  padding: new EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      SizedBox(height: 5),
                      TextField(
                        controller: _titleController,
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
                        decoration: new InputDecoration(
                          filled: true,
                          fillColor: Constants.lightGrey,
                          labelText: "Description",
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        controller: _descriptionController,
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Constants.teal,
                        child: Text(
                          'Update',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Constants.white),
                        ),
                        onPressed: () {
                          // Updates the task in database
                          db
                              .updateTask(ListModel.fromMap({
                            'id': widget.task.id,
                            'title': _titleController.text,
                            'description': _descriptionController.text
                          }))
                              .then((_) {
                            Navigator.pop(context, 'update');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListManipulation()),
                            );
                          });
                        },
                      )
                    ],
                  ))),
            ],
          ),
        ));
  }
}
