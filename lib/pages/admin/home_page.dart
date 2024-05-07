import 'package:calendario_flutter/components/admin/custom_scaffold.dart';
import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/models/navigation_model.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  static const String id = "/admin-home";

  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: FlexibleGridView(
        axisCount: GridLayoutEnum.fourElementsInRow,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: CustomScaffold.adminNavigations
            .map((navigationModel) => CustomCard(
                  navigationModel: navigationModel,
                ))
            .toList(),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final NavigationModel navigationModel;

  const CustomCard({
    super.key,
    required this.navigationModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.alternative,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushReplacementNamed(context, navigationModel.id);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Expanded(
            child: Row(
              children: [
                Icon(navigationModel.icon, size: 64),
                const SizedBox(width: 16),
                Text(
                  navigationModel.title,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Inter',
                    color: AppColor.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
