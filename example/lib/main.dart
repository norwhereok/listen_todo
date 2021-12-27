
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutterspeechrecognizerifly_example/pages/home_page.dart';
import 'package:flutterspeechrecognizerifly_example/routes/Routes.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      locale: Locale('zh'),
      title: "Flutter Demo",
      theme: ThemeData(
        highlightColor: Colors.transparent,//不显示点击button之类的一圈阴影效果
      ),
      // home: HomePage(),
      initialRoute: '/',     //初始化的时候加载的路由
      debugShowCheckedModeBanner: false,
      onGenerateRoute: onGenerateRoute,
    );
  }
}

