import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:intl/intl.dart';
import 'package:task_flutter/controller/task_controller.dart';
import 'package:task_flutter/model/task.dart';
import 'package:task_flutter/ui/theme.dart';
import 'package:task_flutter/ui/widgets/button.dart';
import 'package:task_flutter/ui/widgets/input_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  final TaskController _taskController = Get.put(TaskController());

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "9:30 PM";
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20
  ];
  List <String> repeatList = [
    "None",
    "Daily",
    "weekly",
    "monthly"
  ];

  var _selectedRepeat = "None";
  int _selectedColor = 0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Task", style: headingStyle,),
                MyInputField(
                    title: "Title",
                    hint: "Enter your title",
                    textEditingController: _titleController,
                ),
                MyInputField(
                    title: "Note",
                    hint: "Enter your note",
                    textEditingController: _noteController,
                ),
                MyInputField(
                    title: "Date",
                    hint: DateFormat.yMd().format(_selectedDate),
                    widget: IconButton(
                      icon: Icon(Icons.calendar_today_outlined),
                      color: Colors.grey,
                      onPressed: (){
                        _getDateFromUser();
                      },
                    ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: MyInputField(
                          title: "Start Time",
                          hint: _startTime,
                          widget: IconButton(
                            onPressed: (){
                              _getTimeFromUser(isStartTime: true);
                            },
                            icon: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        )
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                        child: MyInputField(
                          title: "End Time",
                          hint: _endTime,
                          widget: IconButton(
                            onPressed: (){
                              _getTimeFromUser(isStartTime: false);
                            },
                            icon: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        )
                    )
                  ],
                ),
                MyInputField(
                    title: "Remind",
                    hint: "$_selectedRemind minutes early",
                    widget: DropdownButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subTitleStyle,
                      underline: Container(height: 0,),
                      items: remindList.map<DropdownMenuItem<String>>((int value){
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString()),
                        );
                    }).toList(),
                      onChanged: (String? newValue){
                        setState(() {
                          _selectedRemind = int.parse(newValue!);
                        });
                      },
                    )
                ),
                MyInputField(
                    title: "Repeat",
                    hint: _selectedRepeat,
                    widget: DropdownButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subTitleStyle,
                      underline: Container(height: 0,),
                      items: repeatList.map<DropdownMenuItem<String>>((String? value){
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value!,
                            style: TextStyle(
                              color: Colors.grey
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue){
                        setState(() {
                          _selectedRepeat = newValue!;
                        });
                      },
                    )
                ),
                SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPallete(),
                    MyButton(
                        label: "Create Task",
                        onTap: () => _validateData()
                    )
                  ],
                ),
                SizedBox(height: 40,)
              ],
            )
        ),
      ),
    );
  }


  _validateData(){

     if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
       _addTaskToDb();
       Get.back();
     }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
       Get.snackbar(
         "Required", "All fields are required",
         snackPosition: SnackPosition.BOTTOM,
         backgroundColor: Colors.white,
         colorText: pinkClr,
         icon: Icon(
             Icons.warning_amber_rounded,
             color: Colors.red,
         )
      );

    }
  }



  _addTaskToDb() async {
    int value = await _taskController.addTask(
        task: Task(
            note: _noteController.text,
            title: _titleController.text,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            remind: _selectedRemind,
            repeat: _selectedRepeat,
            color: _selectedColor,
            isCompleted: 0
        )
    );
    print("my id is $value");
  }

  _colorPallete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        SizedBox(height: 8.0,),
        Wrap(
            children: List<Widget>.generate(
                3,
                    (int index){
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _selectedColor = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: index == 0 ? primaryClr : index == 1? pinkClr : yellowClr,
                        child: _selectedColor == index ? Icon(
                          Icons.done,
                          color: white,
                          size: 16,
                        ): Container(),
                      ),
                    ),
                  );
                }
            )
        ),
      ],
    );
  }

  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon(
            Icons.arrow_back,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        Icon(
          Icons.person,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
        SizedBox(width: 20,)
      ],
    );
  }
  
  _getDateFromUser() async{
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2121)
    );
    if(_pickerDate != null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    }else{

    }
  }

  _getTimeFromUser({required bool isStartTime}) async{

   var pickedTime = await _showTimePicker();
   String _formatedTime = pickedTime.format(context);

   if(pickedTime == null){

   }else if(isStartTime == true){
      setState(() {
        _startTime = _formatedTime;
      });
   }else if(isStartTime == false){
      setState(() {
        _endTime = _formatedTime;
      });
   }

  }

  _showTimePicker() {
    return showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        )
    );
  }
}
