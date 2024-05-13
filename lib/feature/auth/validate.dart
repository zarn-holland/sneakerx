class Validate {
  static String? validateName(String? formName) {
    if (formName == null || formName.isEmpty) {
      return 'UserName is required';
    }
    return null;
  }
  static String? validateAddress(String? formAddress) {
    if (formAddress == null || formAddress.isEmpty) {
      return 'Address is required';
    }
    return null;
  }

  static String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      return 'Email address is required';
    }

    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) return 'Invalid Email Address Format';

    return null;
  }

  static String? validatePassword(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty) {
      return 'Password is required';
    }

    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formPassword)) {
      return '''
Password must be at least 8 characters,
include an uppercase letter, number and symbol.
      ''';
    }

    return null;
  }
}
