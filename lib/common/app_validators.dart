class AppValidation {
  static emailValidate(String email) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])*$");
    final validation = regex.hasMatch(email);
    return validation;
  }

  static mobileNumberValidate(String mobileNumber) {
    RegExp regex = RegExp(r'(^(?:[+0]9)?[0-9]{1,12}$)');
    final validation = regex.hasMatch(mobileNumber);
    return validation;
  }
}
