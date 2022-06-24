// To parse this JSON data, do
//
//     final cartAddResponse = cartAddResponseFromJson(jsonString);

import 'dart:convert';

CartAddResponse cartAddResponseFromJson(String str) => CartAddResponse.fromJson(json.decode(str));

String cartAddResponseToJson(CartAddResponse data) => json.encode(data.toJson());

class CartAddResponse {
  CartAddResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory CartAddResponse.fromJson(Map<String, dynamic> json) => CartAddResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
AddCartResponse addCartResponseFromJson(String str) => AddCartResponse.fromJson(json.decode(str));

String addCartResponseToJson(AddCartResponse data) => json.encode(data.toJson());


class AddCartResponse {
  AddCartResponse({
    this.result,
    this.message,
    this.temp_user_id,
  });

  bool result;
  String message;
  String temp_user_id;

  factory AddCartResponse.fromJson(Map<String, dynamic> json) => AddCartResponse(
    result: json["result"],
    message: json["message"],
     temp_user_id:json["temp_user_id"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "temp_user_id":temp_user_id,
  };
}