import 'package:flutter/material.dart';
import 'package:flutterspeechrecognizerifly_example/model/user.dart';
import 'package:flutterspeechrecognizerifly_example/utils/db_helper.dart';
import 'package:flutterspeechrecognizerifly_example/utils/toast.dart';
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}
final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp phoneValidatorRegExp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _rePasswordController = TextEditingController();

  DatabaseHelper db = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();

  void check() async{
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      var result1 = await db.checkusername(
        _usernameController.text,
      );
      if (result1 != null) {
        Toast.toast(context, msg: "用户名重复！", position: ToastPostion.center);
        return ;
      }
      submitDataRegister();
    }
  }

  void checkusername()async{
    var result1 = await db.checkusername(
      _usernameController.text,
    );
    if (result1 != null) {
      Toast.toast(context, msg: "用户名重复！", position: ToastPostion.center);
    }
  }
  void submitDataRegister() async {
    var result = await db.saveUser(
      user.fromMap({
        'username': _usernameController.text,
        'nickname': _nicknameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text,
      }),
    );
    if (result != null) {
      Toast.toast(context, msg: "注册成功！", position: ToastPostion.bottom);
      Navigator.pushNamed(context,'/');
      _usernameController.clear();
      _nicknameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _phoneController.clear();
      _rePasswordController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              validator: (e) {
                                if(e.toLowerCase().trim().isEmpty)
                                    return '用户名不能为空';
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: '用户名',
                                prefixIcon: Icon(
                                  Icons.person,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _nicknameController,
                              validator: (e) {
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
                            TextFormField(
                              controller: _emailController,
                              validator: (e) {
                                if(e.toLowerCase().trim().isEmpty)
                                  return '邮箱不能为空';
                                else if(!emailValidatorRegExp.hasMatch(e))
                                  return '请输入正确的邮箱';
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: '邮箱',
                                prefixIcon: Icon(
                                  Icons.email,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _phoneController,
                              validator: (e) {
                                if(e.toLowerCase().trim().isEmpty)
                                  return '手机号不能为空';
                                else if(!phoneValidatorRegExp.hasMatch(e))
                                  return '请输入正确的手机号';
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: '手机号',
                                prefixIcon: Icon(
                                  Icons.phone,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              validator: (e) {
                                return e.toLowerCase().trim().isEmpty
                                    ? '密码不能为空'
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
                            TextFormField(
                              controller: _rePasswordController,
                              validator: (e) {
                                if (e.toLowerCase().trim().isEmpty)
                                  return '密码不能为空';
                                if (_rePasswordController.text.toLowerCase().trim() != _passwordController.text.toLowerCase().trim()) {
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
                            SizedBox(height: 10),
                            RaisedButton(
                              onPressed: check,
                              child: Text('注册'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "已经有账号? ",
                        style: TextStyle(
                          letterSpacing: 2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "登陆",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}