import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fooddeliveryapp/admin/home_admin.dart';
import 'package:fooddeliveryapp/pages/bottomnav.dart';
import 'package:fooddeliveryapp/pages/home.dart';
import 'package:fooddeliveryapp/pages/login.dart';
import 'package:fooddeliveryapp/pages/onboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fooddeliveryapp/pages/signup.dart';
import 'package:fooddeliveryapp/widgets/app_constant.dart';

import 'admin/admin_login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishablekey;
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyA83fKojDYqR3HqlDJQmrOPVjn_3Ue_Iow',
        appId: '1:1054145175159:android:b2c03fc38a1233e6a47072',
        messagingSenderId: '1054145175159',
        projectId: 'fooddeliveryapp-52037',
      storageBucket: 'fooddeliveryapp-52037.appspot.com'
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AdminLogin(),
    );
  }
}

