import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/dialogs/user_dialog.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/program_model.dart';
import 'package:calendario_flutter/models/user_model.dart';
import 'package:calendario_flutter/services/firebase_auth_service.dart';
import 'package:calendario_flutter/services/firebase_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomePage extends StatelessWidget {
  static const String id = "/home";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          FirebaseAuthService().getUserModel(),
          FirebaseFirestoreService().getPrograms(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: AppColor.grey,
              body: const LoadingDialog(),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: AppColor.grey,
              body: ErrorDialog(
                errorModel: ErrorModel(),
                onPress: () {},
              ),
            );
          }

          final UserModel userModel = snapshot.data![0] as UserModel;
          final List<ProgramModel> programModels =
              snapshot.data![1] as List<ProgramModel>;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Calendario'),
              actions: [
                IconButton(
                  onPressed: () {
                    UserDialog.show(context: context, userModel: userModel);
                  },
                  icon: CircleAvatar(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.white,
                    child: Text(snapshot.data != null ? userModel.name[0] : ""),
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
                      color: AppColor.primary,
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
                    title: const Text('Eventos'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Horarios'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            body: SfCalendar(
              
            ),
          );
        });
  }
}
