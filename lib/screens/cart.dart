import 'package:gaadipart/screens/shipping_info.dart';
import 'package:flutter/material.dart';
import 'package:gaadipart/my_theme.dart';
import 'package:gaadipart/ui_sections/drawer.dart';
import 'package:flutter/widgets.dart';
import 'package:gaadipart/repositories/cart_repository.dart';
import 'package:gaadipart/helpers/shared_value_helper.dart';
import 'package:gaadipart/helpers/shimmer_helper.dart';
import 'package:gaadipart/app_config.dart';
import 'package:gaadipart/custom/toast_component.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'login.dart';

class Cart extends StatefulWidget {
  Cart({Key key, this.has_bottomnav}) : super(key: key);
  final bool has_bottomnav;
  int id;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _mainScrollController = ScrollController();
  var _chosenOwnerId = 0;
  var _shopList = [];
  bool _isInitial = true;
  var _cartTotal = 0.00;
  var _cartTotalString = ". . .";
  var _variant = "";
  int _quantity = 1;
  int owner_id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print("user data");
    // print(is_logged_in.value);
    // print(access_token.value);
    // print(user_id.value);
    // print(user_name.value);

    if (is_logged_in.value == true) {
      fetchData();
    }
    else{
      if (is_logged_in.value == false) {
         fetchTempData();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  fetchData() async {

  var cartResponseList =
        await CartRepository().getCartResponseList(user_id.value);

    if (cartResponseList != null && cartResponseList.length > 0) {
      print(widget.id);
      print(_variant);
      print(user_id.value);
      print(_quantity);

      _shopList = cartResponseList;
      _chosenOwnerId = cartResponseList[0].owner_id;
    }
    _isInitial = false;
    getSetCartTotal();
    setState(() {});
  }

  fetchTempData() async {

    var tempCartResponseList =
          await CartRepository().getTempCartResponseList(temp_user_id.value);

    if (tempCartResponseList != null && tempCartResponseList.length > 0) {

      print(widget.id);
      print(_variant);
      print(temp_user_id.value);
      print(_quantity);

      _shopList = tempCartResponseList;
      _chosenOwnerId = tempCartResponseList[0].owner_id;
    }
    _isInitial = false;
    getSetCartTotal();
    setState(() {});

  }



  getSetCartTotal() {
    _cartTotal = 0.00;
    if (_shopList.length > 0) {
      _shopList.forEach((shop) {
        if (shop.cart_items.length > 0) {
          shop.cart_items.forEach((cart_item) {
            _cartTotal +=
                (cart_item.price + cart_item.tax) * cart_item.quantity;
            _cartTotalString = "${cart_item.currency_symbol}${_cartTotal}";
          });
        }
      });
    }

    setState(() {});
  }

  partialTotalString(index) {
    var partialTotal = 0.00;
    var partialTotalString = "";
    if (_shopList[index].cart_items.length > 0) {
      _shopList[index].cart_items.forEach((cart_item) {
        partialTotal += (cart_item.price + cart_item.tax) * cart_item.quantity;
        partialTotalString = "${cart_item.currency_symbol}${partialTotal}";
      });
    }

    return partialTotalString;
  }

  onQuantityIncrease(seller_index, item_index) {
    if (_shopList[seller_index].cart_items[item_index].quantity <
        _shopList[seller_index].cart_items[item_index].upper_limit) {
      _shopList[seller_index].cart_items[item_index].quantity++;
      getSetCartTotal();
      setState(() {});
      onPressUpdate();
    } else {
      ToastComponent.showDialog(
          "Cannot order more than ${_shopList[seller_index].cart_items[item_index].upper_limit} item(s) of this",
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }
  }

  onQuantityDecrease(seller_index, item_index) {
    if (_shopList[seller_index].cart_items[item_index].quantity >
        _shopList[seller_index].cart_items[item_index].lower_limit) {
      _shopList[seller_index].cart_items[item_index].quantity--;
      getSetCartTotal();
      setState(() {});
      onPressUpdate();
    } else {
      ToastComponent.showDialog(
          "Cannot order less than ${_shopList[seller_index].cart_items[item_index].lower_limit} item(s) of this",
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }
  }

  onPressDelete(cart_id) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  "Are you sure to remove this item",
                  maxLines: 3,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
                ),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: MyTheme.medium_grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  color: MyTheme.soft_accent_color,
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: MyTheme.dark_grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    confirmDelete(cart_id);
                  },
                ),
              ],
            ));
  }

  confirmDelete(cart_id) async {
    if (is_logged_in.value == true) {
      var cartDeleteResponse =
      await CartRepository().getCartDeleteResponse(cart_id);

      if (cartDeleteResponse.result == true) {
        ToastComponent.showDialog(cartDeleteResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

        reset();
        fetchData();
      } else {
        ToastComponent.showDialog(cartDeleteResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    }else {
      if (is_logged_in.value == false) {
        // print(temp_user_id.value);
        var tempCartDeleteResponse =
        await CartRepository().getTempCartDeleteResponse(cart_id);

        if (tempCartDeleteResponse.result == true) {
          ToastComponent.showDialog(tempCartDeleteResponse.message, context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

          reset();
          fetchTempData();
        } else {
          ToastComponent.showDialog(tempCartDeleteResponse.message, context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        }
      }
    }
  }

  onPressUpdate() {
    process(mode: "update");
  }

  onPressProceedToShipping() {
    process(mode: "proceed_to_shipping");
  }
  onPressLogin() {
    process(mode: "login");
  }

  process({mode}) async {
    var cart_ids = [];
    var cart_quantities = [];
    if (_shopList.length > 0) {
      _shopList.forEach((shop) {
        if (shop.cart_items.length > 0) {
          shop.cart_items.forEach((cart_item) {
            cart_ids.add(cart_item.id);
            cart_quantities.add(cart_item.quantity);
          });
        }
      });
    }

    if (cart_ids.length == 0) {
      ToastComponent.showDialog("Cart is empty", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    var cart_ids_string = cart_ids.join(',').toString();
    var cart_quantities_string = cart_quantities.join(',').toString();

    print(cart_ids_string);
    print(cart_quantities_string);

   if(is_logged_in.value == true){
     var cartProcessResponse = await CartRepository()
         .getCartProcessResponse(cart_ids_string, cart_quantities_string);

     if (cartProcessResponse.result == false) {
       ToastComponent.showDialog(cartProcessResponse.message, context,
           gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
     }  else {
       ToastComponent.showDialog(cartProcessResponse.message, context,
           gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

       if (mode == "update") {
         reset();
         fetchData();
       } else if (mode == "proceed_to_shipping") {
         Navigator.push(context, MaterialPageRoute(builder: (context) {
           return ShippingInfo(
             owner_id: _chosenOwnerId,
           );
         })).then((value) {
           onPopped(value);
         });
       }
     }
   }else {
     var tempCartProcessResponse = await CartRepository()
         .getTempCartProcessResponse(cart_ids_string, cart_quantities_string);

     if (tempCartProcessResponse.result == false) {
       ToastComponent.showDialog(tempCartProcessResponse.message, context,
           gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
     }
     else {
       ToastComponent.showDialog(tempCartProcessResponse.message, context,
           gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

       if (mode == "update") {
         reset();
         fetchTempData();
       } else if (mode == "login") {
         // Navigator.push(context, MaterialPageRoute(builder: (context) {
         //   return Login(
         //       // owner_id: _chosenOwnerId
         //   );
         // })).then((value) {
         //   onPopped(value);
         // });
         showAlert(context);
       }
     }
   }
  }



  reset() {
    _chosenOwnerId = 0;
    _shopList = [];
    _isInitial = true;
    _cartTotal = 0.00;
    _cartTotalString = ". . .";

    setState(() {});
  }

  Future<void> _onRefresh() async {
    if (is_logged_in.value == false) {
      reset();
      fetchTempData();
    }
      else{
      reset();
        fetchData();
    }
    }

  onPopped(value) async {
    if (is_logged_in.value == false) {
      reset();
      fetchTempData();
    }
    else{
      reset();
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.has_bottomnav);
    return Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer(),
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            RefreshIndicator(
              color: MyTheme.font_color,
              backgroundColor: Colors.white,
              onRefresh: _onRefresh,
              displacement: 0,
              child: CustomScrollView(
                controller: _mainScrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: buildCartSellerList(),
                      ),
                      Container(
                        height: widget.has_bottomnav ? 140 : 100,
                      )
                    ]),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildBottomContainer(),
            )
          ],
        ));
  }

  Container buildBottomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        /*border: Border(
                  top: BorderSide(color: MyTheme.light_grey,width: 1.0),
                )*/
      ),

      height: widget.has_bottomnav ? 200 : 120,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 38,
              width: 350,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                  color: MyTheme.soft_accent_color),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "Total Amount",
                        style:
                            TextStyle(color: MyTheme.font_grey, fontSize: 14),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text("$_cartTotalString",
                          style: TextStyle(
                              color: MyTheme.font_color,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,),
              child: Container(
                // width: (MediaQuery.of(context).size.width - 32) * (2 / 3),
                width:350,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: MyTheme.textfield_grey, width: 1),
                    borderRadius: const BorderRadius.only(
                      topLeft: const Radius.circular(9.0),
                      bottomLeft: const Radius.circular(9.0),
                      topRight: const Radius.circular(9.0),
                      bottomRight: const Radius.circular(9.0),
                    )),
                child: FlatButton(
                  minWidth: MediaQuery.of(context).size.width,
                  //height: 50,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(9.0),
                    bottomLeft: const Radius.circular(9.0),
                    topRight: const Radius.circular(9.0),
                    bottomRight: const Radius.circular(9.0),
                  )),
                  child: Text(
                    "PROCEED TO SHIPPING",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
               if (is_logged_in.value == false) {
                         // showAlert(context);
                 onPressLogin();
                      } else {
                        onPressProceedToShipping();
                      }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState.openDrawer();
        },
        child: Builder(
          builder: (context) => Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0.0),
            child: Container(
              child: Image.asset(
                'assets/hamburger.png',
                height: 16,
                color: MyTheme.dark_grey,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        "Shopping Cart",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  void _handleSellerRadioValueChange(value) {
    setState(() {
      _chosenOwnerId = value;
    });
  }

  buildCartSellerList() {
    if (is_logged_in.value == false && _shopList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            "Cart is empty",
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }else
      if (is_logged_in.value == false && _shopList.length > 0) {
        return SingleChildScrollView(
          child: ListView.builder(
            itemCount: _shopList.length,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0, top: 16.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SizedBox(
                              height: 36,
                              width: 36,
                              child: Transform.scale(
                                scale: .75,
                                child: Radio(
                                  value: _shopList[index].owner_id,
                                  groupValue: _chosenOwnerId,
                                  activeColor: MyTheme.accent_color,
                                  onChanged: _handleSellerRadioValueChange,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            _shopList[index].name,
                            style: TextStyle(color: MyTheme.font_grey),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              partialTotalString(index),
                              style: TextStyle(
                                  color: MyTheme.font_color, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    buildCartSellerItemList(index),
                  ],
                ),
              );
            },
          ),
        );
      }
     else
    if (_isInitial && _shopList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    }
    else if (_shopList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _shopList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.0, top: 16.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            height: 36,
                            width: 36,
                            child: Transform.scale(
                              scale: .75,
                              child: Radio(
                                value: _shopList[index].owner_id,
                                groupValue: _chosenOwnerId,
                                activeColor: MyTheme.accent_color,
                                onChanged: _handleSellerRadioValueChange,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          _shopList[index].name,
                          style: TextStyle(color: MyTheme.font_grey),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            partialTotalString(index),
                            style: TextStyle(
                                color: MyTheme.font_color, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildCartSellerItemList(index),
                ],
              ),
            );
          },
        ),
      );
    }
    else if (!_isInitial && _shopList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            "Cart is empty",
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  SingleChildScrollView buildCartSellerItemList(seller_index) {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: _shopList[seller_index].cart_items.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: buildCartSellerItemCard(seller_index, index),
          );
        },
      ),
    );
  }

  buildCartSellerItemCard(seller_index, item_index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            width: 100,
            height: 100,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: AppConfig.BASE_PATH +
                      _shopList[seller_index]
                          .cart_items[item_index]
                          .product_thumbnail_image,
                  fit: BoxFit.fitWidth,
                ))),
        Container(
          width: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _shopList[seller_index]
                          .cart_items[item_index]
                          .product_name,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w400),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _shopList[seller_index]
                                    .cart_items[item_index]
                                    .currency_symbol +
                                (_shopList[seller_index]
                                            .cart_items[item_index]
                                            .price *
                                        _shopList[seller_index]
                                            .cart_items[item_index]
                                            .quantity +
                                    _shopList[seller_index]
                                        .cart_items[item_index].tax)
                                    .toString(),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          height: 28,
                          child: InkWell(
                            onTap: () {},
                            child: IconButton(
                              onPressed: () {
                                onPressDelete(_shopList[seller_index]
                                    .cart_items[item_index]
                                    .id);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: MyTheme.medium_grey,
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Text("Incl GST(" + _shopList[seller_index]
                        .cart_items[item_index].tax.toString() +"%)"
                         ,style: TextStyle(
                        color: Colors.black),),
                  ],
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Icon(
                    Icons.add,
                    color: MyTheme.font_color,
                    size: 18,
                  ),
                  shape: CircleBorder(
                    side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    onQuantityIncrease(seller_index, item_index);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  _shopList[seller_index]
                      .cart_items[item_index]
                      .quantity
                      .toString(),
                  style: TextStyle(color: MyTheme.accent_color, fontSize: 16),
                ),
              ),
              SizedBox(
                width: 28,
                height: 28,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Icon(
                    Icons.remove,
                    color: MyTheme.font_color,
                    size: 18,
                  ),
                  height: 30,
                  shape: CircleBorder(
                    side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    onQuantityDecrease(seller_index, item_index);
                  },
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          // backgroundColor: Colors.transparent,
          title: new Text('you are not logged in!'),
          actions: <Widget>[
            Row(
              children: [
                FlatButton(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 15),
                FlatButton(
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: new Text("Login"),
                  onPressed: () {
                    print(temp_user_id.value);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                          return Login();
                        }));
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class Constants{
  Constants._();
  static const double padding =20;
}
