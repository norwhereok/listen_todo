import 'package:flutter/material.dart';
import 'package:flutterspeechrecognizerifly_example/utils/db_helper.dart';
import 'package:flutterspeechrecognizerifly_example/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_page.dart';

class Emailpage extends StatefulWidget {
  @override
  _EmailpageState createState() => _EmailpageState();
}

class _EmailpageState extends State<Emailpage> {
  TextEditingController _emailController = TextEditingController();
  DatabaseHelper db = DatabaseHelper();
  String email;
  String username;

  void getDataPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username');
    var result = await db.userinfo(username);
    setState(() {
      email = result.email;
    });
  }

  void submitupdate() async {
    final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if(_emailController.text==''){
      Toast.toast(context, msg: "邮箱不能为空！", position: ToastPostion.center);
      return ;
    }
    else if(!emailValidatorRegExp.hasMatch(_emailController.text)){
      Toast.toast(context, msg: "请输入正确的邮箱！", position: ToastPostion.center);
      return ;
    }
    else if(email==_emailController.text){
      Toast.toast(context, msg: "新旧邮箱不能相同！", position: ToastPostion.center);
      return ;
    }

    int result = await db.upemail(_emailController.text, username);
    if (result == 1) {
      Toast.toast(context, msg: "邮箱更新成功！", position: ToastPostion.center);
      setState(() {
        email = _emailController.text;
      });
      _emailController.clear();
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
        title: Text("修改邮箱"),
        leading: new IconButton(
          tooltip: '返回上一页',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                )).then((data) {});
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Text(
              "你的邮箱：$email",
              style: TextStyle(
                fontSize: 24,
              )
          ),
          SizedBox(height: 30),
          TextFormField(
            controller: _emailController,
            validator: (e) {
              return e.toLowerCase().trim().isEmpty ? '请输入邮箱' : null;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: '邮箱',
              prefixIcon: Icon(
                Icons.email,
              ),
            ),
          ),
          SizedBox(height: 50),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('确认更改'),
            color: Colors.blue,
            textColor: Colors.white,
            elevation: 10,
            onPressed: () {
              submitupdate();
            },
          ),
        ],
      ),
    );
  }
}
