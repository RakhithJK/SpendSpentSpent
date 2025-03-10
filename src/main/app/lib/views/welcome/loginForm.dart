import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/Compatibility.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/config.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';
import 'package:spend_spent_spent/views/login.dart';

class LoginForm extends StatefulWidget {
  Function showSignUp, logIn, showResetPassword;
  Config? config;
  TextEditingController urlController;
  Key key;
  String error;

  LoginForm({required this.showResetPassword, required this.error, required this.key, this.config, required this.showSignUp, required this.logIn, required this.urlController});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> with AfterLayoutMixin<LoginForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  double getIconSize(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return min(150, height / 3);
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return AutofillGroup(
      child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(50.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: defaultBorder,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Padding(padding: const EdgeInsets.all(8.0), child: getIcon('groceries_bag', size: getIconSize(context), color: colors.iconOnMain)),
                            Visibility(
                              visible: (kIsWeb && !kReleaseMode) || !kIsWeb,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(alignment: Alignment.centerLeft, child: Text('Server URL', style: TextStyle(color: colors.textOnMain))),
                              ),
                            ),
                            Visibility(
                              visible: (kIsWeb && !kReleaseMode) || !kIsWeb,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PlatformTextField(
                                    showCursor: true,
                                    controller: widget.urlController,
                                    keyboardType: TextInputType.url,
                                    autocorrect: false,
                                    material: (_, __) => MaterialTextFieldData(decoration: getFieldDecoration("", "https://sss-server.example.com", colors)),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(alignment: Alignment.centerLeft, child: Text('Email', style: TextStyle(color: colors.textOnMain))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PlatformTextField(
                                controller: usernameController,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: [AutofillHints.username],
                                autocorrect: false,
                                material: (_, __) => MaterialTextFieldData(decoration: getFieldDecoration("Email", "user@example.org", colors)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(alignment: Alignment.centerLeft, child: Text('Password', style: TextStyle(color: colors.textOnMain))),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PlatformTextField(
                                  controller: passwordController,
                                  autofillHints: [AutofillHints.password],
                                  obscureText: true,
                                  material: (_, __) => MaterialTextFieldData(decoration: getFieldDecoration("Password", "", colors)),
                                )),
                            Visibility(
                              visible: widget.error.length > 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(borderRadius: defaultBorder, color: Colors.red.shade400),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(widget.error),
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: PlatformElevatedButton(
                                      color: colors.mainDark,
                                        onPressed: () => widget.logIn(usernameController.text.trim(), passwordController.text.trim()), child: Text('Log in')),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: widget.config?.allowSignup ?? false,
                              child: TextButton(
                                  onPressed: () => widget.showSignUp(),
                                  child: Text(
                                    'or Sign Up',
                                    style: TextStyle(color: colors.text),
                                  )),
                            ),
                            Visibility(
                              visible: widget.config?.canResetPassword ?? false,
                              child: TextButton(
                                  onPressed: () => widget.showResetPassword(),
                                  child: Text(
                                    'Forgot password ?',
                                    style: TextStyle(color: colors.text),
                                  )),
                            )
                          ],
                        ))),
              )
            ],
          )),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {}
}
