import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterspeechrecognizerifly_example/utils/db_helper.dart';
import 'package:flutterspeechrecognizerifly_example/pages/sign_in/register.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  DatabaseHelper db = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void check() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      isLoading = true;
      setState(() {});
      submitDataLogin();
    }
  }

  void submitDataLogin() async {
    var result = await db.checkLogin(
      _usernameController.text,
      _passwordController.text,
    );
    setState(() {
      isLoading = false;
    });

    if (result != null) {
      saveDataPref(result.username,result.password);
      print("登陆成功 username:"+ result.password);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      print("登陆失败");
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('密码错误'),
        ),
      );
    }
  }

  void saveDataPref(String username, String password) async {//利用SharedPreferences储存用户名和密码
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('login', 1);
    pref.setString('username', username);
    pref.setString('password', password);
  }

  @override
  void initState() {//初始化
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      key: _scaffoldKey,
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
                  Center(
                    child:
                    Image(
                      image: AssetImage("assets/logo.png"),
                      width: 150,
                      height: 150,
                    ),
                  ),
                  SizedBox(height: 20),
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
                                return e.toLowerCase().trim().isEmpty
                                    ? '请输入用户名'
                                    : null;
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
                              controller: _passwordController,
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
                            RaisedButton(
                              onPressed:check,
                              child: Text('登陆'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "没有账号? ",
                        style: TextStyle(
                          letterSpacing: 2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          "注册",
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