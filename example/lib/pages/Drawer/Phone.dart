import 'package:flutter/material.dart';
import 'package:flutterspeechrecognizerifly_example/utils/db_helper.dart';
import 'package:flutterspeechrecognizerifly_example/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class Phonepage extends StatefulWidget {
  @override
  _PhonepageState createState() => _PhonepageState();
}

class _PhonepageState extends State<Phonepage> {
  TextEditingController _phoneController = TextEditingController();
  DatabaseHelper db = DatabaseHelper();
  String phone;
  String username;
  void getDataPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username');
    var result = await db.userinfo(username);
    setState(() {
      phone=result.phone;
    });
  }
  void submitupdate() async {
    final RegExp phoneValidatorRegExp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    if(!phoneValidatorRegExp.hasMatch(_phoneController.text)){
      Toast.toast(context, msg: "请输入正确的手机号！", position: ToastPostion.center);
      return ;
    }
    else if(phone==_phoneController.text){
      Toast.toast(context, msg: "新旧手机号不能相同！", position: ToastPostion.center);
      return ;
    }
    else if(_phoneController.text==''){
      Toast.toast(context, msg: "手机号不能为空！", position: ToastPostion.center);
      return ;
    }
    var result = await db.upphone(_phoneController.text, username);
    if (result ==1) {
      Toast.toast(context, msg: "手机号更新成功！", position: ToastPostion.center);
      setState(() {
        phone=_phoneController.text;
      });
      _phoneController.clear();
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
        title: Text("修改手机号"),
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
              "你的手机号：$phone",
              style: TextStyle(
                fontSize: 24,
              )
          ),
          SizedBox(height: 30),
          TextFormField(
            controller: _phoneController,
            validator: (e) {
              return e.toLowerCase().trim().isEmpty
                  ? '请输入手机号'
                  : null;
            },
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: '手机号',
              prefixIcon: Icon(
                Icons.phone,
              ),
            ),
          ),
          SizedBox(height: 50),
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
