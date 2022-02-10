import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_flutter/controller/task_controller.dart';
import 'package:task_flutter/model/task.dart';
import 'package:task_flutter/services/notification_services.dart';
import 'package:task_flutter/services/theme_services.dart';
import 'package:task_flutter/ui/add_task_screen.dart';
import 'package:task_flutter/ui/theme.dart';
import 'package:task_flutter/ui/widgets/button.dart';
import 'package:task_flutter/ui/widgets/task_tile.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  final TaskController _taskController = Get.put(TaskController());
  var notifyHelper;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10,),
          _showTasks()
        ]
      ),
    );
  }

  _showTasks(){
    return Expanded(
      child: Obx((){
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index){
              Task task = _taskController.taskList[index];
              if(task.repeat == 'Daily') {
                DateTime date = DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.scheduledNotification(
                  int.parse(myTime.toString().split(":")[0]),
                  int.parse(myTime.toString().split(":")[1]),
                  task
                );
                return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                _showBottomSheet(
                                    context,
                                    _taskController.taskList[index]
                                );
                              },
                              child: TaskTile(task: _taskController.taskList[index],),
                            )
                          ],
                        ),
                      ),
                    )
                );
              }
              if(task.date == DateFormat.yMd().format(_selectedDate)){
                return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                _showBottomSheet(
                                    context,
                                    _taskController.taskList[index]
                                );
                              },
                              child: TaskTile(task: _taskController.taskList[index],),
                            )
                          ],
                        ),
                      ),
                    )
                );
              }else{
                return Container();
              }
            }
        );
      }),
    );
  }



  _showBottomSheet(BuildContext, Task task){
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.only(top: 4),
          height: task.isCompleted == 1
              ? MediaQuery.of(context).size.height * 0.24
              : MediaQuery.of(context).size.height * 0.32,
          color: Get.isDarkMode ? darkGreyClr : white,
          child: Column(
            children: [
              Container(
                height: 0,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600]: Colors.grey[300]
                ),
              ),
              Spacer(),
              task.isCompleted == 1 ? Container() : _bottomSheetButton(
                  label: "Task Completed",
                  onTap: (){
                    _taskController.updateTask(task.id!);
                    _taskController.getTasks();
                    Get.back();
                  },
                  clr: primaryClr,
                  context: context
              ),
              SizedBox(height: 10,),
              _bottomSheetButton(
                  label: "Delete Task",
                  onTap: (){
                    _taskController.delete(task);
                    _taskController.getTasks();
                    Get.back();
                  },
                  clr: Colors.red[300]!,
                  context: context
              ),
                SizedBox(height: 20,),
              _bottomSheetButton(
                  label: "close",
                  onTap: (){
                    Get.back();
                  },
                  clr: white,
                  context: context,
                  isClose: true
              ),
            ],
          ),
        )
      );
  }


  _bottomSheetButton({
      required String label,
      required Function()? onTap,
      required Color clr,
      bool isClose = false,
      required BuildContext context
  }){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose == true ? Get.isDarkMode ?
              Colors.grey[600]!: Colors.grey[300]!: clr
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(color: white),
        )),
      ),
    );
  }



  _addDateBar(){
    return Container(
        margin: const EdgeInsets.only(top: 20, left: 20),
        child: DatePicker(
          DateTime.now(),
          height: 100,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: primaryClr,
          selectedTextColor: white,
          dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            ),
          ),
          dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            ),
          ),
          monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            ),
          ),
          onDateChange: (date){
            setState(() {
              _selectedDate = date;
            });
          },
        )
    );
  }

  _addTaskBar(){
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async{
                await Get.to(() => AddTaskScreen());
                _taskController.getTasks();
              }
          )
        ],
      ),
    );
  }

  _appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode ? "Light mode Activated" : "Dark mode Activated"
          );
        },
        child: Icon(
          Get.isDarkMode ?Icons.wb_sunny_outlined :Icons.nightlight_outlined,
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
}
