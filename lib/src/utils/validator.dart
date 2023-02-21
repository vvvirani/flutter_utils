class Validator {
  Validator._();

  static String? emailValidator(String? email) {
    if (email?.isNotEmpty ?? false) {
      if (isEmailValid(email)) {
        return null;
      } else {
        return 'Enter valid email address';
      }
    } else {
      return 'Please enter email address';
    }
  }

  static String? fullNameValidator(String? fullName) {
    if (fullName?.isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter full name';
    }
  }

  static String? firstNameValidator(String? firstName) {
    if (firstName?.isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter first name';
    }
  }

  static String? lastNameValidator(String? lastName) {
    if (lastName?.isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter last name';
    }
  }

  static String? phoneNumberValidator(String? number) {
    if (number?.isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter phone number';
    }
  }

  static String? passwordValidator(String? password, {bool isStrong = true}) {
    if (password?.isNotEmpty ?? false) {
      if (isStrong) {
        if (isPasswordValid(password)) {
          return null;
        } else {
          return 'Password must be At least 8 characters,\nAt least 1 upper case letter,\nAt least 1 lower case letter,\nAt least 1 number,\nAt least 1 special character';
        }
      } else {
        return null;
      }
    } else {
      return 'Please enter password';
    }
  }

  static String? newPasswordValidator(String? value, String oldPassword) {
    if (value?.isNotEmpty ?? false) {
      if (oldPassword == value) {
        return 'This new password is already used';
      } else {
        if (isPasswordValid(value)) {
          return null;
        } else {
          return 'Password must be At least 8 characters, At least 1 upper case letter, At least 1 lower case letter, At least 1 number, At least 1 special character';
        }
      }
    } else {
      return 'Please new enter password';
    }
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value?.isNotEmpty ?? false) {
      if (password == value) {
        return null;
      }
      return 'Password dose not match';
    } else {
      return 'Please re-enter your password';
    }
  }

  static bool isPasswordValid(String? password) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern.toString());
    return password != null ? regExp.hasMatch(password) : false;
  }

  static bool isEmailValid(String? email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern.toString());
    return email != null ? regExp.hasMatch(email) : false;
  }
}
