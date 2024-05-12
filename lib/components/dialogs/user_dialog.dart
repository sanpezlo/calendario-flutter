import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/primary_button.dart';
import 'package:calendario_flutter/components/buttons/secondary_button.dart';
import 'package:calendario_flutter/models/user_model.dart';
import 'package:calendario_flutter/pages/admin/login_page.dart';
import 'package:calendario_flutter/pages/login_page.dart';
import 'package:calendario_flutter/services/firebase_auth_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class UserDialog extends StatelessWidget {
  final UserModel userModel;

  const UserDialog({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: AppColor.transparent,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return Container(
      width: kIsWeb ? 400 : null,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: AppColor.alternative,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                child: Text(userModel.name[0]),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  userModel.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            userModel.email,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            onPressed: () {
              Navigator.pop(context);
              FirebaseAuthService().signOut();
              Navigator.pushNamedAndRemoveUntil(context,
                  kIsWeb ? AdminLoginPage.id : LoginPage.id, (route) => false);
            },
            text: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
          ),
          kIsWeb
              ? const SizedBox(
                  height: 16,
                )
              : const SizedBox.shrink(),
          PrimaryButton(
            onPressed: () => Navigator.pop(context),
            text: 'Aceptar',
          ),
        ],
      ),
    );
  }

  static void show(
      {required BuildContext context, required UserModel userModel}) {
    showDialog(
      context: context,
      builder: (context) => UserDialog(userModel: userModel),
    );
  }
}
