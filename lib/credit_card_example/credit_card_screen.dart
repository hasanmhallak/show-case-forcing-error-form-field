import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textfield_cases/credit_card_example/data_class.dart';
import 'package:textfield_cases/credit_card_example/service.dart';
import 'package:textfield_cases/utils/validators.dart';

class CreditCardScreen extends StatefulWidget {
  const CreditCardScreen({Key? key}) : super(key: key);
  @override
  State<CreditCardScreen> createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController creditCardController;
  late final RegistrationService service;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    creditCardController = TextEditingController();
    service = RegistrationService();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    creditCardController.dispose();
    service.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    // the approach I suggested won't let me register again when there is an error,
    // as the error would be forced to the [FormField] making the `validate` function return `false`.
    await service.register(
      username: usernameController.text,
      password: passwordController.text,
      creditCard: creditCardController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('checkout')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: service,
                builder: (context, value, child) {
                  final normalChild = _Field(
                    controller: usernameController,
                    label: 'User Name',
                    validator: Validators.notNull,
                  );

                  return value.maybeWhen(
                    orElse: () => normalChild,
                    error: (type, message) {
                      return switch (type) {
                        ErrorType.username => _Field(
                            controller: usernameController,
                            label: 'User Name',
                            validator: Validators.notNull,
                          ),
                        _ => normalChild,
                      };
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              _Field(
                controller: passwordController,
                label: 'Password',
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: service,
                builder: (context, value, child) {
                  final normalChild = _Field(
                    controller: creditCardController,
                    label: 'Credit Card',
                    validator: Validators.creditCard,
                  );

                  return value.maybeWhen(
                    orElse: () => normalChild,
                    error: (type, message) {
                      return switch (type) {
                        ErrorType.creditCard => _Field(
                            controller: creditCardController,
                            label: 'Credit Card',
                            validator: Validators.creditCard,
                            forceErrorText: message,
                          ),
                        _ => normalChild,
                      };
                    },
                  );
                },
              ),
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: service,
                builder: (context, value, child) {
                  return value.maybeWhen(
                    orElse: () {
                      return ElevatedButton(
                        onPressed: submit,
                        child: const Text('Submit'),
                      );
                    },
                    loading: () => const CupertinoActivityIndicator(),
                  );
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.forceErrorText,
  });

  final TextEditingController? controller;
  final String label;
  final String? Function(String?)? validator;

  /// Simulate introducing this property to flutter sdk.
  final String? forceErrorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        border: const OutlineInputBorder(),
        errorText: forceErrorText,
        errorMaxLines: 2,
      ),
      validator: validator,
    );
  }
}
