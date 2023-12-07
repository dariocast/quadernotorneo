import 'package:flutter/material.dart';
import 'package:quaderno_flutter/ui/ui.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String routeName = '/signup';
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.signupPageTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          SupaEmailAuth(
            redirectTo: '/login',
            onSignUpComplete: (_) {
              Navigator.of(context).pushReplacement(LoginPage.route());
            },
            onSignInComplete: (_) {},
            onError: (error) {
              final auth_error = error as AuthException;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(auth_error.message),
                duration: const Duration(seconds: 1),
              ));
            },
            metadataFields: [
              MetaDataField(
                prefixIcon: const Icon(Icons.person),
                label: AppLocalizations.of(context)!.signupFormUsernameLabel,
                key: 'username',
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return AppLocalizations.of(context)!
                        .signupFormUsernameErrorLabel;
                  }
                  return null;
                },
              ),
            ],
          ),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.signupFormSigninTextButtonLabel,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.push(context, LoginPage.route());
            },
          ),
        ],
      ),
    );
  }
}
