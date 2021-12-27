import 'package:flutter/material.dart';
import 'package:flutterspeechrecognizerifly_example/utils/db_helper.dart';
import 'package:flutterspeechrecognizerifly_example/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class Pwdpage extends StatefulWidget {
  @override
  _PwdpageState createState() => _PwdpageState();
}

class _PwdpageState extends State<Pwdpage> {
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _pwdController2 = TextEditingController();
  DatabaseHelper db = DatabaseHelper();
  String pwd;
  String username;
  void getDataPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username');
    var result = await db.userinfo(username);
    setState(() {
      pwd=result.password;
    });
  }
  void submitupdate() async {
    if(_pwdController.text==''){
      Toast.toast(context, msg: "密码不能为空！", position: ToastPostion.center);
      return ;
    }
    if(_pwdController2.text==''){
      Toast.toast(context, msg: "重复密码不能为空！", position: ToastPostion.center);
      return ;
    }
    if(_pwdController.text!=_pwdController2.text){
      Toast.toast(context, msg: "两次输入密码必须一致！", position: ToastPostion.center);
      return ;
    }
    var result = await db.uppwd(_pwdController.text, username);
    if (result ==1) {
      Toast.toast(context, msg: "密码更新成功！", position: ToastPostion.center);
      setState(() {
        pwd=_pwdController.text;
      });
      _pwdController.clear();
      _pwdController2.clear();
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
        title: Text("修改密码"),
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
          // Text("你的邮箱：xx"),
          TextFormField(
            controller: _pwdController,
            validator: (e) {
              return e.toLowerCase().trim().isEmpty
                  ? '请输入密码'
                  : null;
            },
            obscureText: true,
            decoration: InputDecoration(
              labelText: '密码',
              prefixIcon: Icon(
                Icons.lock,
              ),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _pwdController2,
            validator: (e) {
              if (e.toLowerCase().trim().isEmpty)
                return '请输入确认密码';
              if (_pwdController2.text.toLowerCase().trim() != _pwdController.text.toLowerCase().trim()) {
                return '两次输入密码必须一致';
              }
              return null;
            },
            obscureText: true,
            decoration: InputDecoration(
              labelText: '确认密码',
              prefixIcon: Icon(
                Icons.lock,
              ),
            ),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child:Text('确认更改'),
            color:Colors.blue,
            textColor: Colors.white,
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
