import 'package:flutter/material.dart';
import 'package:flutterspeechrecognizerifly_example/pages/voice_add.dart';

import '../pages/home_page.dart';
import '../pages/Drawer/Nickname.dart';
import '../pages/Drawer/Phone.dart';
import '../pages/Drawer/Email.dart';
import '../pages/Drawer/Pwd.dart';
import 'package:flutterspeechrecognizerifly_example/pages/sign_in/login.dart';
//配置路由
final Map<String,Function> routes={
  '/home':(context)=>HomePage(),
  '/nickname':(context)=>Nicknamepage(),
  '/email':(context)=>Emailpage(),
  '/phone':(context)=>Phonepage(),
  '/pwd':(context)=>Pwdpage(),
  '/':(context)=>LoginPage(),
  '/add':(context,{arguments})=>VoiceAddPage(arguments:arguments),
};

//固定写法
var onGenerateRoute=(RouteSettings settings) {
  // 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    }else{
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context));
      return route;
    }
  }
};