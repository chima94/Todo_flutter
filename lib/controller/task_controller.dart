import 'package:get/get.dart';
import 'package:task_flutter/db/db_helper.dart';
import 'package:task_flutter/model/task.dart';

class TaskController extends GetxController{


  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async{
    return await DBHelper.insert(task);
  }

  void getTasks() async{
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }


  void delete(Task task){
    DBHelper.delete(task);
  }

  void updateTask(int id) async{
    await DBHelper.updateTask(id);
  }
}