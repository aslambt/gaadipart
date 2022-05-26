// To parse this JSON data, do
//
//     final signupResponse = signupResponseFromJson(jsonString);

import 'dart:convert';

SignupResponse signupResponseFromJson(String str) => SignupResponse.fromJson(json.decode(str));

String signupResponseToJson(SignupResponse data) => json.encode(data.toJson());

class SignupResponse {
  SignupResponse({
    this.result,
    this.message,
    this.user_id,
  });

  bool result;
  String message;
  int user_id;

  factory SignupResponse.fromJson(Map<String, dynamic> json) => SignupResponse(
    result: json["result"],
    message: json["message"],
    user_id: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "user_id": user_id,
  };
}

// TempSignupResponse tempSignupResponseFromJson(String str) => TempSignupResponse.fromJson(json.decode(str));
//
// String tempSignupResponseToJson(TempSignupResponse data) => json.encode(data.toJson());
//
// class TempSignupResponse {
//   TempSignupResponse({
//     this.result,
//     this.message,
//     this.temp_user_id,
//   });
//
//   bool result;
//   String message;
//   int temp_user_id;
//
//   factory TempSignupResponse.fromJson(Map<String, dynamic> json) => TempSignupResponse(
//     result: json["result"],
//     message: json["message"],
//     temp_user_id: json["user_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "result": result,
//     "message": message,
//     "user_id": temp_user_id,
//   };
// }