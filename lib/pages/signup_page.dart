import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/custom_rich_text.dart';
import 'package:calendario_flutter/components/text_fields/email_text_field.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/text_fields/password_text_field.dart';
import 'package:calendario_flutter/components/text_fields/custom_text_field.dart';
import 'package:calendario_flutter/components/buttons/secondary_button.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/pages/home_page.dart';
import 'package:calendario_flutter/pages/login_page.dart';
import 'package:calendario_flutter/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  static const String id = "/signup";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
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
            padding:
                const EdgeInsets.only(top: 32, right: 32, bottom: 16, left: 32),
            alignment: Alignment.topLeft,
            child: Text(
              'Registraté',
              style: TextStyle(
                fontSize: 32,
                color: AppColor.text,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: 358,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
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
        ]),
      ),
    );
  }

  Form _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          CustomRichText(
              title:
                  'Parece que no tienes una cuenta.                                        ',
              subtitle: 'Creemos una nueva cuenta para ti.',
              subtitleTextStyle: TextStyle(
                color: AppColor.primary,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              onTab: () {}),
          const SizedBox(
            height: 24,
          ),
          CustomTextField(
            hintText: 'Nombre completo',
            controller: nameController,
          ),
          const SizedBox(
            height: 16,
          ),
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
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: TextStyle(
                color: AppColor.text,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              children: [
                const TextSpan(
                  text: 'Al seleccionar Crear cuenta a continuación,',
                ),
                const TextSpan(
                  text: ' Acepto los ',
                ),
                TextSpan(
                  text: 'Términos de servicio',
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text: ' & ',
                ),
                TextSpan(
                  text: 'Política de privacidad',
                  style: TextStyle(
                    color: AppColor.kPrimary,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
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
                    .signUpWithEmailAndPassword(
                        name: nameController.text,
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
            text: 'Crear cuenta',
          ),
          const SizedBox(
            height: 24,
          ),
          CustomRichText(
            title: '¿Ya tienes una cuenta?',
            subtitle: ' Iniciar sesión',
            subtitleTextStyle: TextStyle(
              color: AppColor.kPrimary,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
            onTab: () {
              Navigator.pushReplacementNamed(context, LoginPage.id);
            },
          )
        ],
      ),
    );
  }
}
