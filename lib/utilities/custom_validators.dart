class CustomValidator {
  static String? email(String? value) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value!)) {
      return 'Email is Invalid';
    }
    return null;
  }

  static String? password(String? value) {
    if (value!.length < 6) {
      return 'Password should be greater then 6 digits';
    }
    return null;
  }

  // static String? username(
  //   BuildContext context,
  //   String? value,
  // ) {
  //   if (value == null) return 'Enter the username';
  //   if (value.length < 4) return 'Most be more then 3 words';
  //   if (!RegExp(r'^[A-Za-z_.]+$').hasMatch(value[0])) {
  //     return 'Must be start with Alphabet';
  //   }
  //   if (!RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._]+$').hasMatch(value.substring(1))) {
  //     return ''' Only '.' and '_' signs are allowed''';
  //   }
  //   if (Provider.of<UserProvider>(context, listen: false)
  //       .usernameExist(value: value)) {
  //     return 'Username already exist';
  //   }
  //   return null;
  // }
  static String? agency(String? value) {
    return (value!.length < 3) ? 'Enter more then 2 characters' : null;
  }

  static String? isEmpty(String? value) {
    return (value!.isEmpty) ? 'Field could not be empty' : null;
  }

  static String? lessThen2(String? value) {
    return (value!.length < 2) ? 'Enter more then 1 characters' : null;
  }

  static String? lessThen3(String? value) {
    return (value!.length < 3) ? 'Enter more then 2 characters' : null;
  }

  static String? lessThen4(String? value) {
    return (value!.length < 4) ? 'Enter more then 3 characters' : null;
  }

  static String? lessThen5(String? value) {
    return (value!.length < 5) ? 'Enter more then 4 characters' : null;
  }

  static String? greaterThen(String? input, double compairWith) {
    return ((double.tryParse(input ?? '0') ?? 0.0) > compairWith)
        ? null
        : 'New input must be greater then $compairWith';
  }

  static String? lessThen(String? input, double compairWith) {
    return ((double.tryParse(input ?? '0') ?? 0.0) < compairWith)
        ? null
        : 'New input must be Less then $compairWith';
  }

  static String? retaunNull(String? value) => null;
}