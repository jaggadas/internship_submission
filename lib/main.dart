import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_internship_submission/Homepage.dart';
import 'package:flutter_internship_submission/LoginPage.dart';


void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:LoginPage(),
        routes: {
          LoginPage.id:(context)=>LoginPage(),
          HomePage.id:(context)=>HomePage()
        } );


  }
}
