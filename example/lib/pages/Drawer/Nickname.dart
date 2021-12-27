import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterspeechrecognizerifly_example/utils/db_helper.dart';
import 'package:flutterspeechrecognizerifly_example/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_page.dart';

class Nicknamepage extends StatefulWidget {
  @override
  _NicknamepageState createState() => _NicknamepageState();
}

class _NicknamepageState extends State<Nicknamepage> {
  TextEditingController _nicknameController = TextEditingController();
  DatabaseHelper db = DatabaseHelper();
  String nickname;
  String username;
  void getDataPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username');
    var result = await db.userinfo(username);
    setState(() {
      nickname=result.nickname;
    });
  }
  void submitupdate() async {
    if(nickname==_nicknameController.text){
      Toast.toast(context, msg: "新旧昵称不能相同！", position: ToastPostion.center);
      return ;
    }
    else if(_nicknameController.text==''){
      Toast.toast(context, msg: "昵称不能为空！", position: ToastPostion.center);
      return ;
    }
    var result = await db.upnickname(_nicknameController.text, username);
    if (result ==1) {
      Toast.toast(context, msg: "昵称修改成功！", position: ToastPostion.center);
      setState(() {
        nickname=_nicknameController.text;
      });
      _nicknameController.clear();
      Navigator.pushNamed(context, '/home');
    }
  }
  @override
  void initState() {
    getDataPref();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("修改昵称"),
        leading: new IconButton(
          tooltip: '返回上一页',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                )).then((data) {
            });
          },
        ),
      ),
      body:Column(
        children: [
          SizedBox(height: 50),
          Text(
              "你的昵称：$nickname",
              style: TextStyle(
              fontSize: 24,
              )
          ),
          SizedBox(height: 30),
          TextFormField(
            controller: _nicknameController,
            validator: (e) {
              return e.toLowerCase().trim().isEmpty
                  ? '昵称不能为空'
                  : null;
            },
            onChanged: (e) {
              return e.toLowerCase().trim().isEmpty
                  ? '昵称不能为空'
                  : null;
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: '昵称',
              prefixIcon: Icon(
                Icons.face,
              ),
            ),
          ),
          SizedBox(height: 50),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child:Text('确认更改'),
            // 背景颜色
            color:Colors.blue,
            // 文字颜色
            textColor: Colors.white,
            // 按钮阴影
            elevation: 10,
            onPressed: (){
              submitupdate();
            },
          ),
        ],
      ),
    );
  }
}
