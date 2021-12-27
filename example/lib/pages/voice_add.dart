import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterspeechrecognizerifly_example/model/task.dart';
import 'package:flutterspeechrecognizerifly_example/utils/toast.dart';
import 'package:flutterspeechrecognizerifly_example/utils/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class VoiceAddPage extends StatefulWidget {
  final arguments;
  const VoiceAddPage({Key key, this.arguments}) : super(key: key);  //定义一个变量
  @override
  _VoiceAddPageState createState() => _VoiceAddPageState();
}

class _VoiceAddPageState extends State<VoiceAddPage> {
  String username1;
  TaskDao taskDao;
  Task addTask;
  TextEditingController contentController = TextEditingController();


  void getDataPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      contentController.text = pref.getString('context');
      addTask.endTime = DateTime.parse(pref.getString('time'));
      addTask.username = pref.getString('username');
      username1 = pref.getString('username');
    });
  }


  @override
  void initState() {
    super.initState();
    taskDao = TaskDao();
    addTask = Task(
      username: username1,
      endTime: DateTime.now(),
      isFinish: false,
    );
    getDataPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加任务"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              addTask.content = contentController.text;
              taskDao.insertTask(addTask);
              Toast.toast(context, msg: "添加成功成功！", position: ToastPostion.top);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  )).then((data) {
              });
              // Navigator.of(context).pop();
            },
          ),
          SizedBox(width: 5,)
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 8,),
            _buildContent(),
            SizedBox(height: 8,),
            _buildTime(context),
            // Divider(height:10.0,indent:0.0,color: Colors.grey[600]),
            // _buildIsFinsh(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return TextField(
      controller: contentController,
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        labelText: "内容",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTime(BuildContext context) {
    var _nowTime = TimeOfDay(
        hour: addTask.endTime.hour, minute: addTask.endTime.minute);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            child: Row(
              children: [
                Text(
                  "截止日期：${formatDate(
                      addTask.endTime, [yyyy, '-', mm, '-', dd])}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Icon(Icons.arrow_drop_down)
              ],
            ),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: addTask.endTime,
                firstDate: DateTime(2012),
                lastDate: DateTime(2050),
              ).then((value) {
                if (value != null) {
                  setState(() {
                    addTask.endTime = value;
                  });
                }
              });
            }
        ),
        InkWell(
            child: Row(
              children: [
                Text(
                  "${formatDate(addTask.endTime, [HH, ':', nn])}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Icon(Icons.arrow_drop_down)
              ],
            ),
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: _nowTime,
              ).then((value) {
                if (value != null) {
                  setState(() {
                    _nowTime = value;
                    addTask.endTime = DateTime(
                        addTask.endTime.year, addTask.endTime.month,
                        addTask.endTime.day, _nowTime.hour, _nowTime.minute);
                  });
                }
              });
            }
        )
      ],
    );
  }
}