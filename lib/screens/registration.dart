import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gaadipart/app_config.dart';
import 'package:gaadipart/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaadipart/custom/input_decorations.dart';
import 'package:gaadipart/custom/intl_phone_input.dart';
import 'package:gaadipart/screens/main.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:gaadipart/addon_config.dart';
import 'package:gaadipart/screens/otp.dart';
import 'package:gaadipart/screens/login.dart';
import 'package:gaadipart/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:gaadipart/repositories/auth_repository.dart';

// enum MobileVerificationState{
//   SHOW_MOBILE_FORM_STATE,
//   SHOW_OTP_FORM_STATE
// }

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String _register_by = "phone"; //phone or email
  String initialCountry = 'IN';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'IN', dialCode: "91");
  String _phone = "phone";

  // MobileVerificationState currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;


  //controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  // FirebaseAuth _auth = FirebaseAuth.instance;
  // String VerificationId;
  // bool ShowLoading = false;
  //
  // void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async{
  //   setState(() {
  //     ShowLoading=true;
  //   });
  //   try {
  //     final authCredential = await _auth.signInWithCredential(phoneAuthCredential);
  //     setState(() {
  //       ShowLoading = false;
  //     });
  //
  //     if (authCredential?.user != null){
  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>Main()));
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       ShowLoading = true;
  //     });
  //     _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(e.message)));
  //   }
  // }


  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressSignUp() async {
    var name = _nameController.text.toString();
    var email = _emailController.text.toString();
     var phone = _phoneNumberController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();

    // if(_register_by == _phone){
    //   setState(() {
    //     ShowLoading = true;
    //   });
    //
    //   FirebaseAuth _auth = FirebaseAuth.instance;
    //   FirebaseFirestore db = FirebaseFirestore.instance;
    //
    //   await _auth.verifyPhoneNumber(
    //     phoneNumber: _phoneNumberController.text,
    //     verificationCompleted: (phoneAuthCredential )async{
    //       setState(() {
    //         ShowLoading = false;
    //         // await _auth.signInWithCredential(credential);
    //       });
    //       // signUpWithPhoneAuthCredential(phoneAuthCredential);
    //     },
    //     verificationFailed: (verificationFailed) async{
    //       setState(() {
    //         ShowLoading = false;
    //       });
    //       _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(verificationFailed.message)));
    //     },
    //     codeSent: (verificationId, resendingToken)async{
    //       setState(() {
    //         ShowLoading = false;
    //         currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
    //         this.VerificationId = VerificationId;
    //       });
    //     },
    //     codeAutoRetrievalTimeout: (verificationId) async{
    //
    //     },
    //   );
    // }else

    if (name == "") {
      ToastComponent.showDialog("Enter your name", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (_register_by == 'email' && email == "") {
      ToastComponent.showDialog("Enter email", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (_register_by == 'phone' && _phone == "") {
      ToastComponent.showDialog("Enter phone number", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (password == "") {
      ToastComponent.showDialog("Enter password", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (password_confirm == "") {
      ToastComponent.showDialog("Confirm your password", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (password.length < 6) {
      ToastComponent.showDialog(
          "Password must contain atleast 6 characters", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (password != password_confirm) {
      ToastComponent.showDialog("Passwords do not match", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
    // print("FROM SIGNUP");
    // print("${AppConfig.BASE_URL}/auth/signup");
    print(_phoneNumberController.value);
    print(_register_by);

    var signupResponse = await AuthRepository().getSignupResponse(
        name,
        _register_by == 'email' ? email : _phone,
        password,
        password_confirm,
        _register_by);
    print("User registered by" +_register_by);

    if (signupResponse.result == false) {
      ToastComponent.showDialog(signupResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(signupResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Otp(
          verify_by: _register_by,
          user_id: signupResponse.user_id,
        );
      }));
    }
  }
 final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0, bottom: 0),
                      //   child: Container(
                      //     width: 150,
                      //     height: 130,
                      //     child: Image.asset('assets/logo.png'),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          "Join " + AppConfig.app_name,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 35,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 60),
                      Container(
                        width: _screen_width * (3 / 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 4.0),
                            //   child: Text(
                            //     "Name",
                            //     style: TextStyle(
                            //         color: MyTheme.font_color,
                            //         fontSize: 19,fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 8.0),
                            //   child: Container(
                            //     height: 40,
                            //     child: TextField(
                            //       controller: _nameController,
                            //       autofocus: false,
                            //       decoration: InputDecorations.buildInputDecoration_1(
                            //           hint_text: "John Doe"),
                            //     ),
                            //   ),
                            // ),
                            Container(
                              width: size.width * 0.8,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: TextFormField(
                                  controller: _nameController,
                                  // autofocus: false,
                                  // autofocus: false,
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                    prefixIcon: Icon(Icons.person,color: Colors.blueGrey),
                                    // focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black) ),
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 4.0),
                            //   child: Text(
                            //     _register_by == "email" ? "Email" : "Phone",
                            //     style: TextStyle(
                            //         color: MyTheme.font_color,
                            //         fontSize: 19,fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                            if (_register_by == "email")
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Container(
                                    //   height: 40,
                                    //   child: TextField(
                                    //     controller: _emailController,
                                    //     autofocus: false,
                                    //     decoration:
                                    //         InputDecorations.buildInputDecoration_1(
                                    //             hint_text: "johndoe@example.com"),
                                    //   ),
                                    // ),
                                    SizedBox(height: 15),
                                    Container(
                                      width: size.width * 0.8,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30.0),
                                        child: TextFormField(
                                          controller: _emailController,
                                          autofocus: false,
                                          // autofocus: false,
                                          decoration: InputDecoration(
                                            hintText: "Email",
                                            prefixIcon: Icon(Icons.email,color: Colors.blueGrey),
                                          ),
                                        ),
                                      ),
                                    ),
                                    AddonConfig.otp_addon_installed
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _register_by = "phone";
                                              });
                                            },
                                            child: Text(
                                              "or, Register with phone",
                                              style: TextStyle(
                                                decoration: TextDecoration.underline,
                                                  color: MyTheme.font_color,
                                              ),
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 36,
                                      child: CustomInternationalPhoneNumberInput(
                                        onInputChanged: (PhoneNumber number) {
                                          print(number.phoneNumber);
                                          setState(() {
                                            _phone = number.phoneNumber;
                                          });
                                        },
                                        onInputValidated: (bool value) {
                                          print(value);
                                        },
                                        selectorConfig: SelectorConfig(
                                          selectorType: PhoneInputSelectorType.DIALOG,
                                        ),
                                        ignoreBlank: false,
                                        autoValidateMode: AutovalidateMode.disabled,
                                        selectorTextStyle:
                                            TextStyle(color: MyTheme.font_grey),
                                        initialValue: phoneCode,
                                        textFieldController: _phoneNumberController,
                                        formatInput: true,
                                        keyboardType: TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                        inputDecoration: InputDecorations
                                            .buildInputDecoration_phone(
                                                ),
                                        onSaved: (PhoneNumber number) {
                                          //print('On Saved: $number');
                                        },
                                      ),
                                    ),
                                    AddonConfig.otp_addon_installed
                                   ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _register_by = "email";
                                        });
                                      },
                                      child: Text(
                                        "or, Register with an email",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: MyTheme.font_color,
                                          ),
                                      ),
                                    )
                                        : Container()
                                  ],
                                ),
                              ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 4.0),
                            //   child: Text(
                            //     "Password",
                            //     style: TextStyle(
                            //         color: MyTheme.font_color,
                            //         fontWeight: FontWeight.bold,fontSize: 19),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Container(
                                  //   height: 40,
                                  //   child: TextField(
                                  //     controller: _passwordController,
                                  //     autofocus: false,
                                  //     obscureText: true,
                                  //     enableSuggestions: false,
                                  //     autocorrect: false,
                                  //     decoration:
                                  //         InputDecorations.buildInputDecoration_1(
                                  //             hint_text: "• • • • • • • •"),
                                  //   ),
                                  // ),
                                  SizedBox(height: 15),


                                  Container(
                                    width: size.width * 0.8,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        autofocus: false,
                                        obscureText: true,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        // autofocus: false,
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          prefixIcon: Icon(Icons.lock,color: Colors.blueGrey)
                                        ),
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 4.0),
                            //   child: Text(
                            //     "Confirm Password",
                            //     style: TextStyle(
                            //         color: MyTheme.font_color,
                            //         fontWeight: FontWeight.bold,fontSize: 19),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 8.0),
                            //   child: Container(
                            //     height: 40,
                            //     child: TextField(
                            //       controller: _passwordConfirmController,
                            //       autofocus: false,
                            //       obscureText: true,
                            //       enableSuggestions: false,
                            //       autocorrect: false,
                            //       decoration: InputDecorations.buildInputDecoration_1(
                            //           hint_text: "* * * * * * *"),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(height: 15),
                            Container(
                              width: size.width * 0.8,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: TextFormField(
                                  controller: _passwordConfirmController,
                                  autofocus: false,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  // autofocus: false,
                                  decoration: InputDecoration(
                                    hintText: "Confirm Password",
                                    prefixIcon: Icon(Icons.lock,color: Colors.blueGrey),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MyTheme.textfield_grey, width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: FlatButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  //height: 50,
                                  color: MyTheme.accent_color,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0))),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () {
                                    onPressSignUp();
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Center(
                                  child: Text(
                                "Already have an Account ?",
                                style: TextStyle(
                                    color: MyTheme.font_color, fontSize: 12),
                              )),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MyTheme.textfield_grey, width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: FlatButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  //height: 50,
                                  color: MyTheme.theme_color,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0))),
                                  child: Text(
                                    "Log in",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Login();
                                    }));
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
