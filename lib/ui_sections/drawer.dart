import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gaadipart/my_theme.dart';
import 'package:gaadipart/screens/home.dart';
import 'package:gaadipart/screens/main.dart';
import 'package:gaadipart/screens/profile.dart';
import 'package:gaadipart/screens/order_list.dart';
import 'package:gaadipart/screens/wishlist.dart';
import 'package:gaadipart/screens/shipping_info.dart';
import 'package:gaadipart/screens/checkout.dart';
import 'package:gaadipart/screens/registration.dart';
import 'package:gaadipart/screens/login.dart';
import 'package:gaadipart/screens/messenger_list.dart';
import 'package:gaadipart/screens/wallet.dart';
import 'package:gaadipart/helpers/shared_value_helper.dart';
import 'package:gaadipart/app_config.dart';
import 'package:gaadipart/helpers/auth_helper.dart';
import 'package:gaadipart/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:gaadipart/repositories/auth_repository.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  onTapLogout(context) async {
    AuthHelper().clearUserData();

    /*
    var logoutResponse = await AuthRepository()
            .getLogoutResponse();


    if(logoutResponse.result == true){
         ToastComponent.showDialog(logoutResponse.message, context,
                   gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
         }
         */
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              is_logged_in.value == true
                  ? ListTile(
                      leading: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(
                          AppConfig.BASE_PATH + "${avatar_original.value}",
                        ),
                      ),
                      title: Text("${user_name.value}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                      subtitle:
                          user_email.value != "" && user_email.value != null
                              ? Text("${user_email.value}",style: TextStyle(fontWeight: FontWeight.bold),)
                              : Text("${user_phone.value}"))
                  : Text('Not logged in',
                      style: TextStyle(
                          color: MyTheme.font_color,
                          fontSize: 18)),
              Divider(),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset("assets/home.png",
                      height: 16,  color: MyTheme.theme_color,),
                  title: Text('Home',
                      style: TextStyle(
                          color: MyTheme.font_color,
                          fontSize: 18)),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) => Main()), (route) => false);
                  }),
              is_logged_in.value == true
                  ? ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset("assets/profile.png",
                          height: 16,   color: MyTheme.theme_color,),
                      title: Text('Profile',
                          style: TextStyle(
                              color: MyTheme.font_color,
                              fontSize: 18)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Profile(show_back_button: true);
                        }));
                      })
                  : Container(),
              is_logged_in.value == true
                  ? ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset("assets/order.png",
                          height: 16,  color: MyTheme.theme_color,),
                      title: Text('Orders',
                          style: TextStyle(
                              color: MyTheme.font_color,                              fontSize: 18)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return OrderList(from_checkout: false);
                        }));
                      })
                  : Container(),
              is_logged_in.value == true
                  ? ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset("assets/heart.png",
                          height: 16,  color: MyTheme.theme_color,),
                      title: Text('My Wishlist',
                          style: TextStyle(
                              color: MyTheme.font_color,                              fontSize: 18)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Wishlist();
                        }));
                      })
                  : Container(),
              (is_logged_in.value == true)
                  ? ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset("assets/chat.png",
                          height: 16,    color: MyTheme.theme_color,),
                      title: Text('Messages',
                          style: TextStyle(
                              color: MyTheme.font_color,                              fontSize: 18)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MessengerList();
                        }));
                      })
                  : Container(),
              is_logged_in.value == true
                  ? ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset("assets/wallet.png",
                          height: 16,    color: MyTheme.theme_color,),
                      title: Text('Wallet',
                          style: TextStyle(
                              color: MyTheme.font_color,                              fontSize: 18)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Wallet();
                        }));
                      })
                  : Container(),
              Divider(height: 24),
              is_logged_in.value == false
                  ? ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset("assets/login.png",
                          height: 16,  color: MyTheme.theme_color,),
                      title: Text('Login',
                          style: TextStyle(
                              color: MyTheme.font_color,                              fontSize: 18)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Login();
                        }));
                      })
                  : Container(),
              is_logged_in.value == true
                  ? ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset("assets/logout.png",
                          height: 16,  color: Colors.red,),
                      title: Text('Logout',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18)),
                      onTap: () {
                        onTapLogout(context);
                      })
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
