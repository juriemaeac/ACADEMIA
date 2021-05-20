import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sample1/todolist/addTaskScreen.dart';
import 'package:sample1/todolist/databaseHelpers.dart';
import 'package:sample1/todolist/taskModel.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");

  @override
  void initState() { 
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Widget _buildTask (Task task){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                decoration: task.status == 0 
                ? TextDecoration.none
                : TextDecoration.lineThrough,
              ),
            ),
            subtitle: Text('${_dateFormatter.format(task.date)} ● ${task.priority}\n${task.description}',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  decoration: task.status == 0 
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
              ),
            ),
            isThreeLine: true,
            trailing: Checkbox(
              onChanged: (value){
                task.status = value ? 1 : 0;
                DatabaseHelper.instance.updateTask(task);
                _updateTaskList();
              },
              activeColor: Colors.red,
              value: task.status == 1 ? true : false,
            ),
            onTap: ()=> Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (_) => AddTaskScreen(
                  updateTaskList: _updateTaskList,
                  task: task,
                ),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: Color(0xFFCDB193),
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (_)=> AddTaskScreen(
              updateTaskList: _updateTaskList,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _taskList,
        builder: (context, snapshot) {
          if (!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),
            );
          }

          final int completedTaskCount = snapshot.data
          .where((Task task) => task.status == 1)
          .toList()
          .length;

          return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 0),
          itemCount: 1 + snapshot.data.length,
          itemBuilder: (BuildContext context, int index){
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40, 
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center (
                    child: Text("My Tasks", 
                      style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,  
                      )
                    ),
                    ),
                    SizedBox(height: 10),
                    Center( 
                      child: Text('$completedTaskCount of ${snapshot.data.length}',
                      style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20, 
                      fontWeight: FontWeight.w600,  
                      ),
                    ),
                    ),
                  ]
                ),
              );
            }
            // return Container(
            //   margin: EdgeInsets.all(3),
            //   height: 100, 
            //   width: double.infinity, 
            //   color: Colors.red,
            // );
            return _buildTask(snapshot.data[index-1]);
          },
        );
        },
      ),
    );
  }
}