import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gaadipart/my_theme.dart';
import 'package:gaadipart/screens/splash.dart';
import 'package:gaadipart/screens/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // SharedPreferences sharedPreferences;
  // bool checkValue = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   getCredential();
  // }
  //
  // _onChanged(bool value) async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     checkValue = value;
  //     sharedPreferences.setBool("check", checkValue);
  //     sharedPreferences.setInt("temp_user_id", temp_user_id.value);
  //     sharedPreferences.commit();
  //     getCredential();
  //   });
  // }
  // getCredential() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     checkValue = sharedPreferences.getBool("check");
  //     if (checkValue != null) {
  //       if (checkValue) {
  //         temp_user_id.value = sharedPreferences.getInt("temp_user_id");
  //
  //       } else {
  //         sharedPreferences.clear();
  //       }
  //     } else {
  //       checkValue = false;
  //     }
  //   });
  // }

  // SharedPreferences prefs;
  //
  // getSharedPreferences () async
  // {
  //   prefs = await SharedPreferences.getInstance();
  // }
  // prefs = await SharedPreferences.getInstance();
  // int users = prefs.getInt('temp_user_id') ?? 0;
  //
  // saveTempValue () async
  // {
  //   prefs = await SharedPreferences.getInstance();
  //   prefs.setInt('temp_user_id', 1);
  // }
  //
  // retrieveIntValue () async
  // {
  //   prefs = await SharedPreferences.getInstance();
  //   int value = prefs.getInt('temp_user_id');
  //   print(value);
  // }
  // saveTemp() async
  // {
  //   prefs = await SharedPreferences.getInstance();
  //   prefs.setInt('temp_user_id', temp_user_id.value);
  //   print(temp_user_id.value);
  // }









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

class MyApp extends StatelessWidget {
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
