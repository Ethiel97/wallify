import 'package:get/get.dart';

String? passwordValidator(String? value) {
  if (value!.length < 6) {
    return "The password must contain at least 6 characters";
  } else {
    return null;
  }
}

String? validator(String? value) {
  if (value!.isEmpty) {
    return "This field cannot be empty";
  } else {
    return null;
  }
}

String? usernameValidator(String? value) {
  if (value!.length< 4) {
    return "The username must contain at least 4 characters";
  } else {
    return null;
  }
}

String? emailValidator(String? value) {
  if (value!.isEmpty || !value.isEmail) {
    return "Please enter a valid email";
  } else {
    return null;
  }
}
