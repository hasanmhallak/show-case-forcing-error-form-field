import 'package:flutter/material.dart';

import 'data_class.dart';

class RegistrationService extends ValueNotifier<ResgitserState> {
  RegistrationService() : super(const ResgitserState.init());

  Future<void> register({
    required String username,
    required String password,
    required String creditCard,
  }) async {
    value = const ResgitserState.loading();
    await Future.delayed(const Duration(seconds: 3));

    // backend return an error relating to a credit card not being valid.
    value = const ResgitserState.error(ErrorType.creditCard,
        "your saved card does not support this type of purchase");
  }
}
