import 'package:gaadipart/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:gaadipart/data_model/cart_response.dart';
import 'package:gaadipart/data_model/cart_delete_response.dart';
import 'package:gaadipart/data_model/cart_process_response.dart';
import 'package:gaadipart/data_model/cart_add_response.dart';
import 'package:gaadipart/data_model/cart_summary_response.dart';
import 'package:gaadipart/helpers/shared_value_helper.dart';


class CartRepository{

  Future<List<CartResponse>> getCartResponseList(
      @required int user_id, ) async {
    print(user_id);

    final response = await http.post("${AppConfig.BASE_URL}/carts/$user_id",
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.value}"}, );
    print(response.body);
    return cartResponseFromJson(response.body);
  }

  Future<List<TempCartResponse>> getTempCartResponseList(
      @required String temp_user_id, ) async {
     print(temp_user_id);

    final response = await http.post("${AppConfig.BASE_URL}/carts/temp/$temp_user_id",
      headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.value}"}, );
    print(response.body);
    return tempCartResponseFromJson(response.body);
  }

  Future<CartDeleteResponse> getCartDeleteResponse(
      @required int cart_id, ) async {

    final response = await http.delete("${AppConfig.BASE_URL}/carts/$cart_id",
      headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.value}"}, );
    print(response.body);
    return cartDeleteResponseFromJson(response.body);
  }

  Future<TempCartDeleteResponse> getTempCartDeleteResponse(
      @required int cart_id, ) async {

    final response = await http.delete("${AppConfig.BASE_URL}/carts/temp/$cart_id",
      headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.value}"}, );
    print(response.body);
    return tempCartDeleteResponseFromJson(response.body);
  }

  Future<CartProcessResponse> getCartProcessResponse(
      @required String cart_ids, @required String cart_quantities ) async {

    var post_body = jsonEncode({"cart_ids": "${cart_ids}", "cart_quantities": "$cart_quantities"});
    final response = await http.post("${AppConfig.BASE_URL}/carts/process",
      headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.value}"},body: post_body );
    print(response.body);
    return cartProcessResponseFromJson(response.body);
  }

  Future<TempCartProcessResponse> getTempCartProcessResponse(
      @required String cart_ids, @required String cart_quantities ) async {

    var post_body = jsonEncode({"cart_ids": "${cart_ids}", "cart_quantities": "$cart_quantities"});
    final response = await http.post("${AppConfig.BASE_URL}/carts/temp/process",
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.value}"},body: post_body );
    print(response.body);
    return tempCartProcessResponseFromJson(response.body);
  }

  Future<CartAddResponse> getCartAddResponse(
      @required int id, @required String variant,@required int user_id,@required int quantity ) async {

    var post_body = jsonEncode({"id": "${id}", "variant": "$variant","user_id": "$user_id","quantity": "$quantity","cost_matrix": AppConfig.purchase_code});

    print(post_body.toString());

    final response = await http.post("${AppConfig.BASE_URL}/carts/add",
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.value}"},body: post_body );

  print(response.body.toString());
    return cartAddResponseFromJson(response.body);
  }
  Future<AddCartResponse> getAddCartResponse(
      @required int id, @required String variant,@required String temp_user_id,@required int quantity ) async {

    var post_body = jsonEncode({"id": "${id}", "variant": "$variant","temp_user_id": "$temp_user_id","quantity": "$quantity","cost_matrix": AppConfig.purchase_code});

    print(post_body.toString());

    final response = await http.post("${AppConfig.BASE_URL}/carts/addtocart",
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.value}"},body: post_body );

    print(response.body.toString());
    return addCartResponseFromJson(response.body);
  }

  Future<CartSummaryResponse> getCartSummaryResponse(@required owner_id) async {
    final response = await http.get("${AppConfig.BASE_URL}/cart-summary/${user_id.value}/${owner_id}",
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.value}"}, );

    return cartSummaryResponseFromJson(response.body);
  }

}

