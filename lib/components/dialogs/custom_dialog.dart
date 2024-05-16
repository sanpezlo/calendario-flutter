import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/primary_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String? body;
  final Widget? content;
  final List<Widget>? actions;

  const CustomDialog(
      {super.key, required this.title, this.body, this.content, this.actions});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
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
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          content ??
              Text(
                body!,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
          const SizedBox(height: 16),
          actions == null
              ? PrimaryButton(
                  onPressed: () => Navigator.pop(context),
                  text: 'Aceptar',
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: actions!,
                ),
        ],
      ),
    );
  }

  static void show(
      {required BuildContext context,
      required String title,
      required String body,
      List<Widget>? actions}) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        body: body,
        actions: actions,
      ),
    );
  }
}
