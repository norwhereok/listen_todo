import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterspeechrecognizerifly_example/model/task.dart';
import 'package:flutterspeechrecognizerifly_example/utils/toast.dart';
import 'package:flutterspeechrecognizerifly_example/utils/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  TaskDao taskDao;
  Task task;
  DetailPage(this.taskDao, this.task);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController contentController = TextEditingController();
  String username = '';
  Task tmpTask;


  void getDataPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username');
  }

  @override
  void initState() {
    super.initState();
    getDataPref();
    tmpTask = Task(
      id: widget.task.id,
      content: widget.task.content,
      endTime: widget.task.endTime,
      isFinish: widget.task.isFinish,
    );
    setState(() {
      contentController.text = tmpTask.content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("详情"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){
              tmpTask.content = contentController.text;
              widget.taskDao.updateTask(tmpTask,username);
              Toast.toast(context,msg: "修改成功！",position: ToastPostion.top);
              Navigator.of(context).pop();
            },
          ),
          SizedBox(width: 15,)
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
            Divider(height:10.0,indent:0.0,color: Colors.grey[600]),
            _buildIsFinsh(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(){
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

  Widget _buildEndTime(BuildContext context){
    return GestureDetector(
      onTap: (){
        showDatePicker(
          context: context,
          initialDate: tmpTask.endTime,
          firstDate: DateTime(2012),
          lastDate: DateTime(2050),
        ).then((value) {
          if(value!=null){
            setState(() {
              tmpTask.endTime = value;
            });
          }
        });
      },
      child: Row(
        children: <Widget>[
          Text(
            " 截止时间:  ${tmpTask.endTimeStr}   ",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Icon(Icons.date_range,color: Colors.blue[500],)
        ],
      ),
    );
  }
  Widget _buildTime(BuildContext context){
    var _nowTime = TimeOfDay(hour: tmpTask.endTime.hour, minute: tmpTask.endTime.minute);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            child: Row(
              children: [
                Text(
                  "截止日期：${formatDate(tmpTask.endTime, [yyyy, '-', mm, '-', dd])}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Icon(Icons.arrow_drop_down)
              ],
            ),
            onTap:(){
              showDatePicker(
                context: context,
                initialDate: tmpTask.endTime,
                firstDate: DateTime(2012),
                lastDate: DateTime(2050),
              ).then((value) {
                if(value!=null){
                  setState(() {
                    tmpTask.endTime = value;
                  });
                }
              });
            }
        ),
        InkWell(
            child: Row(
              children: [
                Text(
                  "${formatDate(tmpTask.endTime, [HH, ':', nn])}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Icon(Icons.arrow_drop_down)
              ],
            ),
            onTap:(){
              showTimePicker(
                context: context,
                initialTime: _nowTime,
              ).then((value) {
                if(value!=null){
                  setState(() {
                    _nowTime=value;
                    tmpTask.endTime = DateTime(tmpTask.endTime.year,tmpTask.endTime.month,tmpTask.endTime.day,_nowTime.hour,_nowTime.minute);

                  });

                }
              });
            }
        )
      ],
    );
  }
  Widget _buildIsFinsh(){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(" 是否已完成",style: TextStyle(fontSize: 18),),
        Switch(
          value: tmpTask.isFinish,//当前状态
          onChanged:(value){
            //重新构建页面
            setState(() {
              tmpTask.isFinish=value;
            });
          },
        ),
      ],
    );
  }
}
