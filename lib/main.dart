import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_list_app/provider/user_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => UserProvider(),
      child: MaterialApp(
        title: 'User List App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}