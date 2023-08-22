class Validators {
  /// Checks whether [value] equals to `null`.
  ///
  /// Returns an error message if `false`, otherwise `null`.
  static String? notNull<T>(T? value) {
    // considring an empty string as null, because the user
    // did not write anything.
    if (value == null || (value is String && value.isEmpty)) {
      return 'This field is required!';
    }
    return null;
  }

  /// Checks whether if [value] satisfy a valid credit card number.
  ///
  /// Returns an error message if `false`, otherwise `null`.
  static String? creditCard<T>(T? value) {
    if (value == null || value is! String) {
      return 'This field is required!';
    }
    if (value.length < 4) {
      return 'Invalid Credit Card';
    }
    return null;
  }
}
