import 'package:gaadipart/helpers/shared_value_helper.dart';

class TempHelper {
  setTempUserData(AddCartResponse) {
    if (AddCartResponse.result == false) {
      is_logged_in.value = false;
      // access_token.value = loginResponse.access_token;
      temp_user_id.value = AddCartResponse.temp_user_id;
      // user_id.value = loginResponse.user.id;
      // user_name.value = loginResponse.user.name;
      // user_email.value = loginResponse.user.email;
      // user_phone.value = loginResponse.user.phone;
      // avatar_original.value = loginResponse.user.avatar_original;

    }
  }


}
