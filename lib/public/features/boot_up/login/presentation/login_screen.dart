import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_with_meaning/public/common_widgets/errors/snack_bar.dart';
import 'package:read_with_meaning/public/constants/app_sizes.dart';
import 'package:read_with_meaning/public/features/experience/data/realm_repository.dart';
import 'package:realm/realm.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _privateKeyController = TextEditingController();
  final _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Consumer(builder: (context, ref, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  textInputAction: TextInputAction.done,
                ),
                TextFormField(
                  controller: _privateKeyController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onFieldSubmitted: (_) {
                    _submit(ref);
                  },
                  textInputAction: TextInputAction.done,
                ),
                gapH12,
                ElevatedButton(
                  onPressed: () {
                    _submit(ref);
                  },
                  child: const Text('Submit'),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  _submit(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      final app = ref.read(appProvider);
      try {
        User? user = app.currentUser ??
            await app.logIn(Credentials.emailPassword(
                _emailController.text.trim(),
                _privateKeyController.text.trim()));
        //ref.read(currentUserProvider.notifier).state = user;
        //ref.refresh(currentUserProvider);
        ref.read(userProvider.notifier).init(user, ref);

/*         await secureStorage.write(key: 'authStatus', value: "loggedIn");
        await secureStorage.write(
            key: 'authToken', value: _privateKeyController.text.trim());
        await secureStorage.write(
            key: 'email', value: _emailController.text.trim()); */
      } on Exception catch (e, stackTrace) {
        snackBar(context, "Invalid credentials.");
        Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
    }
  }

  @override
  void dispose() {
    _privateKeyController.dispose();
    super.dispose();
  }
}
