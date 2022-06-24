import 'package:gaadipart/helpers/shared_value_helper.dart';

class TempHelper {
  setTempUserData(AddCartResponse) {
    if (AddCartResponse.result == true) {
      is_logged_in.value = false;
      print(AddCartResponse.temp_user_id);
      temp_user_id.value = AddCartResponse.temp_user_id;


    }
  }


}
