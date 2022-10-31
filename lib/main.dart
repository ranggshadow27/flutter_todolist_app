// ignore_for_file: prefer_const_constructors, missing_return

import 'package:flutter/material.dart';
import 'package:flutter_todolist_app/db/db_provider.dart';
import 'package:flutter_todolist_app/model/task_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyTodoApp(),
    );
  }
}

class MyTodoApp extends StatefulWidget {
  const MyTodoApp({Key key}) : super(key: key);

  @override
  State<MyTodoApp> createState() => _MyTodoAppState();
}

class _MyTodoAppState extends State<MyTodoApp> {
  Color mainColor = Color(0xFF0d0952);
  Color secondColor = Color(0xFF212061);
  Color btnColor = Color(0xFFff955b);
  Color editorColor = Color(0xFF4044cc);

  TextEditingController inputController = TextEditingController();

  String newTaskTxt = "";

  //Getting all the List from Table
  getTask() async {
    final tasks = await DBProvider.dataBase.getTask();
    print(tasks);
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    //Step 1 : Adding the SQFLite and path Dependencies
    //**The db Folder Where we create the DBProvider class*//
    //**The model Folder Where we create the Tabel model class*//
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        title: Text("My To-Do!"),
      ),
      backgroundColor: mainColor,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getTask(),
              builder: (_, taskData) {
                switch (taskData.connectionState) {
                  case ConnectionState.waiting:
                    {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  case ConnectionState.done:
                    {
                      if (taskData.data != Null) {
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: taskData.data.length,
                            itemBuilder: (context, index) {
                              String task =
                                  taskData.data[index]['task'].toString();
                              String day = DateTime.parse(
                                      taskData.data[index]['creationDate'])
                                  .day
                                  .toString();
                              return Card(
                                color: secondColor,
                                child: InkWell(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 12),
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          day,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            task,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            "You have now Task today",
                            style: TextStyle(color: Colors.white54),
                          ),
                        );
                      }
                      break;
                    }
                  case ConnectionState.none:
                    // TODO: Handle this case.
                    break;
                  case ConnectionState.active:
                    // TODO: Handle this case.
                    break;
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            decoration: BoxDecoration(
              color: editorColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Type your new Task",
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                FlatButton.icon(
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text("Add Task"),
                  color: btnColor,
                  shape: StadiumBorder(),
                  textColor: Colors.white,
                  onPressed: () {
                    //Function for Insert Data to Tables
                    setState(() {
                      newTaskTxt = inputController.text.toString();
                      inputController.text = "";
                    });
                    Task newTask =
                        Task(task: newTaskTxt, dateTime: DateTime.now());
                    DBProvider.dataBase.addNewTask(newTask);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
