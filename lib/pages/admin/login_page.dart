import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/text_fields/email_text_field.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/text_fields/password_text_field.dart';
import 'package:calendario_flutter/components/buttons/secondary_button.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/pages/admin/programs_page.dart';
import 'package:calendario_flutter/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class AdminLoginPage extends StatefulWidget {
  static const String id = "/admin-login";

  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              alignment: Alignment.center,
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
                  (value) async {
                    if (value != null) {
                      try {
                        await FirebaseAuthService().getUserModel().then(
                          (userModel) {
                            Navigator.pop(context);
                            if (userModel != null && userModel.isAdmin) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  AdminProgramsPage.id, (route) => false);
                            } else {
                              FirebaseAuthService().signOut();
                              ErrorDialog.show(
                                context: context,
                                errorModel: ErrorModel(
                                  message:
                                      'No tienes permisos de administrador',
                                ),
                              );
                            }
                          },
                        );
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          ErrorDialog.show(
                              context: context,
                              errorModel: e is ErrorModel ? e : null);
                        }
                      }
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
        ],
      ),
    );
  }
}
