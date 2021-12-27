import 'package:flutterspeechrecognizerifly_example/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutterspeechrecognizerifly_example/model/task.dart';

class TaskDao{
  Future<Database> get database async{
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE task(id INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT, content TEXT, endTime TEXT, isFinish INT2)",
        );
      },
      version: 1,
    );
    return database;
  }

  Future<List<Task>> tasks(String username) async {
    final Database db = await database;
  print('username');
  print(username);
    final List<Map<String, dynamic>> maps = await db.query(
      'task',
      orderBy: 'endTime asc',
      where: "username = ?",
      whereArgs: [username]
    );
    print('1111');
    print(maps);
    List<Task> tasks = List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
    return tasks;
  }
  Future<List<Task>> tasksWhere(int whereArg,String username) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'task',
      orderBy: 'endTime asc',
      where: "isFinish = ? AND username = ?",
      whereArgs: [whereArg,username]
    );
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Future<Task> getTask(int id,String username) async {
  //   final Database db = await database;
  //
  //   List<Map> maps = await db.query('task',
  //     where: 'id = ?AND username = ?',
  //     whereArgs: [id,username]
  //   );
  //   if (maps.length > 0) {
  //     return Task.fromMap(maps.first);
  //   }
  //   return null;
  // }

  Future<void> insertTask(Task task) async {
    final Database db = await database;

    await db.insert(
      'task',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Task task,String username) async {
    final db = await database;

    await db.update(
      'task',
      task.toMap(),
      where: "id = ?AND username = ?",
      whereArgs: [task.id,username],
    );
  }
  Future<void> deleteTask(int id,String username) async {
    final db = await database;

    await db.delete(
      'task',
      where: "id = ?AND username = ?",
      whereArgs: [id,username],
    );
  }
}