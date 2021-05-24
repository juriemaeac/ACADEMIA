import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sample1/reviewer/reviewerModel.dart';
import 'package:sample1/reviewer/topicModel.dart';
import 'package:sample1/todolist/taskModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String taskstables = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colStatus = 'status';
  String reviewerTable = 'reviewer_table';
  String colIdReviewer = 'idReviewer';
  String colTitleReviewer = 'titleReviewer';
  String colDescriptionReviewer = 'descriptionReviewer';
  String colStatusReviewer = 'statusReviewer';
  String topicTable = 'topic_table';
  String colIdTopic = 'idTopic';
  String colTitleTopic = 'titleTopic';
  String colStatusTopic = 'statusTopic';

  //Task Tables
  //Id | Title | Date | Description | Priority | Status
  // 0    ''      ''        ''          ''         0
  // 1    ''      ''        ''          ''         0
  // 2    ''      ''        ''          ''         0
  // 3    ''      ''        ''          ''         0

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir =  await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_list.db';
    final todoListDb = await openDatabase(
      path, 
      version: 2,
      onCreate: _createDb,
    );
    return todoListDb;
  }
  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $taskstables($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate TEXT, $colDescription TEXT, $colPriority TEXT, $colStatus INTEGER)',
    );
    await db.execute(
      'CREATE TABLE $reviewerTable($colIdReviewer INTEGER PRIMARY KEY AUTOINCREMENT, $colTitleReviewer TEXT, $colDescriptionReviewer TEXT, $colStatusReviewer INTEGER)',
    );
    await db.execute(
      'CREATE TABLE $topicTable($colIdTopic INTEGER PRIMARY KEY AUTOINCREMENT, $colTitleTopic TEXT, $colStatusTopic INTEGER)',
    );
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(taskstables);
    return result;
  }

  Future <List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });

    //sorting task list by date
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }
  //when u add ask to the db
  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int result = await db.insert(taskstables, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    final int result = await db.update(
      taskstables, 
      task.toMap(), 
      where: '$colId = ?', 
      whereArgs: [task.id],
    );
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result =  await db.delete(
      taskstables, 
      where: '$colId = ?', 
      whereArgs: [id],
    );
    return result;
  }
////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> getReviewerMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(reviewerTable);
    return result;
  }

  Future <List<Reviewer>> getReviewerList() async {
    final List<Map<String, dynamic>> reviewerMapList = await getReviewerMapList();
    final List<Reviewer> reviewerList = [];
    reviewerMapList.forEach((reviewerMap) {
      reviewerList.add(Reviewer.fromMap(reviewerMap));
    });
    return reviewerList;

  }
  //when u add reviewer to the db
  Future<int> insertReviewer(Reviewer reviewer) async {
    Database db = await this.db;
    final int result = await db.insert(reviewerTable, reviewer.toMap());
    return result;
  }

  Future<int> updateReviewer(Reviewer reviewer) async {
    Database db = await this.db;
    final int result = await db.update(
      reviewerTable, 
      reviewer.toMap(), 
      where: '$colIdReviewer = ?', 
      whereArgs: [reviewer.idReviewer],
    );
    return result;
  }

  Future<int> deleteReviewer(int idReviewer) async {
    Database db = await this.db;
    final int result =  await db.delete(
      reviewerTable, 
      where: '$colIdReviewer = ?', 
      whereArgs: [idReviewer],
    );
    return result;
  }
///////////////////////////////////////////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> getTopicMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(topicTable);
    return result;
  }

  Future <List<Topic>> getTopicList() async {
    final List<Map<String, dynamic>> topicMapList = await getTopicMapList();
    final List<Topic> topicList = [];
    topicMapList.forEach((topicMap) {
      topicList.add(Topic.fromMap(topicMap));
    });
    return topicList;

  }
  //when u add topic to the db
  Future<int> insertTopic(Topic topic) async {
    Database db = await this.db;
    final int result = await db.insert(topicTable, topic.toMap());
    return result;
  }

  Future<int> updateTopic(Topic topic) async {
    Database db = await this.db;
    final int result = await db.update(
      topicTable, 
      topic.toMap(), 
      where: '$colIdTopic = ?', 
      whereArgs: [topic.idTopic],
    );
    return result;
  }

  Future<int> deleteTopic(int idTopic) async {
    Database db = await this.db;
    final int result =  await db.delete(
      topicTable, 
      where: '$colIdTopic = ?', 
      whereArgs: [idTopic],
    );
    return result;
  }


}
