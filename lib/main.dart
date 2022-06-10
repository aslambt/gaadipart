import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gaadipart/my_theme.dart';
import 'package:gaadipart/screens/splash.dart';
import 'package:gaadipart/screens/main.dart';
import 'package:shared_value/shared_value.dart';
import 'package:gaadipart/helpers/shared_value_helper.dart';
import 'dart:async';
import 'package:gaadipart/repositories/auth_repository.dart';
import 'app_config.dart';


 main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseAuth.instance.verifyPhoneNumber(
  //   phoneNumber: '+91 9995 913 913',
  //   verificationCompleted: (phoneAuthCredential) {},
  //   verificationFailed: (verificationFailed) {},
  //   codeSent: (verificationId, resendingToken) {},
  //   codeAutoRetrievalTimeout: (verificationId) {},
  // );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  fetch_user() async{
    var userByTokenResponse =
    await AuthRepository().getUserByTokenResponse();

    if (userByTokenResponse.result == true) {
      is_logged_in.value  = true;
      user_id.value = userByTokenResponse.id;
      user_name.value = userByTokenResponse.name;
      user_email.value = userByTokenResponse.email;
      user_phone.value = userByTokenResponse.phone;
      avatar_original.value = userByTokenResponse.avatar_original;
    }
  }
  access_token.load().whenComplete(() {
    fetch_user();
  });










  /*is_logged_in.load();
  user_id.load();
  avatar_original.load();
  user_name.load();
  user_email.load();
  user_phone.load();*/

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));


  runApp(
    SharedValue.wrapApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // FirebaseAuth _auth;
  //
  // User _user;
  //
  // bool isLoading = true;
  //
  // @override
  // void initState(){
  //   super.initState();
  //   _auth = FirebaseAuth.instance;
  //   _user = _auth.currentUser;
  //   isLoading = false;
  // }
  //
  // final Future<FirebaseApp> initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {


    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: AppConfig.app_name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyTheme.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: MyTheme.accent_color,
        /*textTheme: TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(fontSize: 12.0),
          )*/
        //
        // the below code is getting fonts from http
        textTheme: GoogleFonts.sourceSansProTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.sourceSansPro(textStyle: textTheme.bodyText1),
          bodyText2: GoogleFonts.sourceSansPro(
              textStyle: textTheme.bodyText2, fontSize: 12),
        ),
      ),
      home: Splash(),
      //home: Main(),
    );
  }
}
