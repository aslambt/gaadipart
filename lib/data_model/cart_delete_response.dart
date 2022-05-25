// To parse this JSON data, do
//
//     final cartDeleteResponse = cartDeleteResponseFromJson(jsonString);

import 'dart:convert';

CartDeleteResponse cartDeleteResponseFromJson(String str) => CartDeleteResponse.fromJson(json.decode(str));

String cartDeleteResponseToJson(CartDeleteResponse data) => json.encode(data.toJson());

class CartDeleteResponse {
  CartDeleteResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory CartDeleteResponse.fromJson(Map<String, dynamic> json) => CartDeleteResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
///////////////////////////////////////////////////////////////////////
TempCartDeleteResponse tempCartDeleteResponseFromJson(String str) => TempCartDeleteResponse.fromJson(json.decode(str));

String tempCartDeleteResponseToJson(TempCartDeleteResponse data) => json.encode(data.toJson());

class TempCartDeleteResponse {
  TempCartDeleteResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory TempCartDeleteResponse.fromJson(Map<String, dynamic> json) => TempCartDeleteResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}