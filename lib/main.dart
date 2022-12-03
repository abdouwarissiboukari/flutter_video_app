import 'package:flutter/material.dart';
import 'package:learn_video/controller/list_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.light, primarySwatch: Colors.deepOrange),
      darkTheme: ThemeData.dark(),
      home: ListController(),
    );
  }
}
