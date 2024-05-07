import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/custom_rich_text.dart';
import 'package:calendario_flutter/components/text_fields/email_text_field.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/text_fields/password_text_field.dart';
import 'package:calendario_flutter/components/buttons/primary_text_button.dart';
import 'package:calendario_flutter/components/buttons/secondary_button.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/pages/forgot_password_page.dart';
import 'package:calendario_flutter/pages/home_page.dart';
import 'package:calendario_flutter/pages/signup_page.dart';
import 'package:calendario_flutter/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  static const String id = "/login";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Image.asset(
                  "assets/logo_negro_unicesmag.png",
                  scale: 1.5,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 32, bottom: 16, left: 32, right: 32),
              alignment: Alignment.topLeft,
              child: Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: AppColor.text,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: 358,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor.alternative,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.alternative,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Container(
                  color: Colors.transparent,
                  child: _form(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Form _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          EmailTextField(
            controller: emailController,
          ),
          const SizedBox(
            height: 16,
          ),
          PasswordTextField(
            controller: passwordController,
          ),
          const SizedBox(
            height: 16,
          ),
          SecondaryButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              LoadingDialog.show(context: context);

              try {
                await FirebaseAuthService()
                    .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text)
                    .then(
                  (value) {
                    Navigator.pop(context);
                    if (value != null) {
                      Navigator.pushReplacementNamed(context, HomePage.id);
                    }
                  },
                );
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ErrorDialog.show(
                      context: context, errorModel: e is ErrorModel ? e : null);
                }
              }
            },
            text: 'Iniciar sesión',
          ),
          const SizedBox(
            height: 8,
          ),
          PrimaryTextButton(
            title: '¿Olvidaste tu contraseña?',
            onPressed: () {
              Navigator.pushNamed(context, ForgotPasswordPage.id);
            },
          ),
          const SizedBox(height: 16),
          CustomRichText(
            title: '¿No tienes una cuenta?',
            subtitle: ' Regístrate',
            subtitleTextStyle: TextStyle(
              color: AppColor.primary,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
            onTab: () {
              Navigator.pushReplacementNamed(context, SignUpScreen.id);
            },
          )
        ],
      ),
    );
  }
}
