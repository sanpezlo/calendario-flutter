import 'package:calendario_flutter/components/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          color: AppColor.alternative,
        ),
        const SizedBox(height: 16),
        Text(
          'Cargando...',
          style: TextStyle(fontSize: 16, color: AppColor.alternative),
        ),
      ],
    );
  }

  static void show({required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PopScope(
        canPop: false,
        child: LoadingDialog(),
      ),
    );
  }
}
