import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do_list/src/utils/constants.dart';
import '../models/list_model.dart';
import '../utils/database_helper.dart';
import '../ui/manipulation_list.dart';

class LandingList extends StatefulWidget {
  @override
  _LandingListState createState() => _LandingListState();
}

//This is the first page of the app

class _LandingListState extends State<LandingList> {
  List<ListModel> items = new List();
  DatabaseHelper db = new DatabaseHelper();

  @override
  void initState() {
    super.initState();

    db.getAllTasks().then((tasks) {
      setState(() {
        tasks.forEach((task) {
          items.add(ListModel.fromMap(task));
          items.sort((b, a) => a.id.compareTo(b.id));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Constants.teal,
          child: Icon(
            Icons.add,
            size: 50,
          ),

          //Navigated to editable screen to add new task

          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListManipulation()),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,
                  colors: [Constants.darkTeal, Constants.lightTeal])),
          child: Column(children: [
            Container(
                height: 200,
                child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      SvgPicture.asset(AssetUrls.listSvg,
                          width: 70, height: 70),
                      Text(
                        'To Do List!',
                        style: TextStyle(fontSize: 30, color: Constants.white),
                      )
                    ]))),
            Container(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                height: MediaQuery.of(context).size.height - 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(100.0),
                        topRight: const Radius.circular(100.0))),
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
                        //User can view all the tasks in a list view

                        : Center(
                            child: ListView.builder(
                                itemCount: items.length,
                                padding: const EdgeInsets.all(15.0),
                                itemBuilder: (context, position) {
                                  return Card(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    width: 8.0,
                                                    color: Constants.teal)),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              ListTile(
                                                title: Text(
                                                    '${items[position].title}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1),
                                                subtitle: Text(
                                                    '${items[position].description}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2),
                                                onTap: () {},
                                              ),
                                            ],
                                          )));
                                }),
                          ))),
          ]),
        ));
  }
}
