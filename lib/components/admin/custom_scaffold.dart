import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/dialogs/user_dialog.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/navigation_model.dart';
import 'package:calendario_flutter/pages/admin/home_page.dart';
import 'package:calendario_flutter/pages/admin/login_page.dart';
import 'package:calendario_flutter/pages/admin/professors_page.dart';
import 'package:calendario_flutter/pages/admin/programs_page.dart';
import 'package:calendario_flutter/pages/admin/schedules_page.dart';
import 'package:calendario_flutter/pages/admin/subjects_page.dart';
import 'package:calendario_flutter/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatefulWidget {
  final Widget body;
  final FloatingActionButton? floatingActionButton;

  static final adminNavigations = [
    NavigationModel(
      id: AdminProgramsPage.id,
      icon: Icons.school,
      title: "Programas",
    ),
    NavigationModel(
      id: AdminProfessorsPage.id,
      icon: Icons.people,
      title: "Profesores",
    ),
    NavigationModel(
      id: AdminSubjectsPage.id,
      icon: Icons.book,
      title: "Materias",
    ),
    NavigationModel(
      id: AdminSchedulesPage.id,
      icon: Icons.schedule,
      title: "Horarios",
    ),
    NavigationModel(
      id: "/admin-events",
      icon: Icons.event,
      title: "Eventos",
    ),
  ];

  const CustomScaffold(
      {super.key, required this.body, this.floatingActionButton});

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  bool _isLoadingFuture = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuthService().getUserModel(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          Future.delayed(
            Duration.zero,
            () => LoadingDialog.show(context: context),
          );

          return Scaffold(backgroundColor: AppColor.background);
        }

        if (futureSnapshot.hasError) {
          Future.delayed(
            Duration.zero,
            () => ErrorDialog.show(
              context: context,
              errorModel: ErrorModel(),
            ),
          );

          return Scaffold(backgroundColor: AppColor.background);
        }

        if (!futureSnapshot.hasData) {
          Future.delayed(
            Duration.zero,
            () => ErrorDialog.show(
              context: context,
              errorModel: ErrorModel(
                message: "No se pudo obtener la información del usuario",
              ),
            ),
          );

          return Scaffold(backgroundColor: AppColor.background);
        }

        if (_isLoadingFuture) {
          _isLoadingFuture = false;
          Future.delayed(Duration.zero, () => Navigator.pop(context));
        }

        return Scaffold(
          backgroundColor: AppColor.background,
          floatingActionButton: widget.floatingActionButton,
          appBar: AppBar(
            backgroundColor: AppColor.alternative,
            title: const Text('Administrador'),
            actions: [
              IconButton(
                onPressed: () {
                  UserDialog.show(
                      context: context, userModel: futureSnapshot.data!);
                },
                icon: CircleAvatar(
                  backgroundColor: AppColor.secondary,
                  foregroundColor: AppColor.white,
                  child: Text(futureSnapshot.data!.name[0]),
                ),
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColor.secondary,
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Image.asset(
                        "assets/logo_blanco_unicesmag.png",
                        scale: 1.5,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Inicio'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, AdminHomePage.id);
                  },
                ),
                ...CustomScaffold.adminNavigations.map(
                  (card) => ListTile(
                    leading: Icon(card.icon),
                    title: Text(card.title),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, card.id);
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  textColor: AppColor.secondary,
                  iconColor: AppColor.secondary,
                  title: const Text('Cerrar sesión'),
                  onTap: () {
                    FirebaseAuthService().signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, AdminLoginPage.id, (route) => false);
                  },
                ),
              ],
            ),
          ),
          body: widget.body,
        );
      },
    );
  }
}
