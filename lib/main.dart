import 'package:calendario_flutter/pages/admin/home_page.dart';
import 'package:calendario_flutter/pages/admin/login_page.dart';
import 'package:calendario_flutter/pages/admin/professors_page.dart';
import 'package:calendario_flutter/pages/admin/programs_page.dart';
import 'package:calendario_flutter/pages/admin/schedules_page.dart';
import 'package:calendario_flutter/pages/admin/splash_page.dart';
import 'package:calendario_flutter/pages/admin/subjects_page.dart';
import 'package:calendario_flutter/pages/forgot_password_page.dart';
import 'package:calendario_flutter/pages/home_page.dart';
import 'package:calendario_flutter/pages/login_page.dart';
import 'package:calendario_flutter/pages/on_boarding_page.dart';
import 'package:calendario_flutter/pages/signup_page.dart';
import 'package:calendario_flutter/pages/splash_page.dart';
import 'package:calendario_flutter/pages/test_page.dart';
import 'package:calendario_flutter/services/firebase_messaging_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) await FirebaseMessagingService().initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.grey.withOpacity(0.5),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: kIsWeb ? AdminSplashPage.id : SplashPage.id,
      routes: {
        SplashPage.id: (context) => const SplashPage(),
        OnBoardingPage.id: (context) => const OnBoardingPage(),
        LoginPage.id: (context) => LoginPage(),
        SignUpScreen.id: (context) => SignUpScreen(),
        HomePage.id: (context) => const HomePage(),
        '/test': (context) => const TaskDetailView(),
        ForgotPasswordPage.id: (context) => ForgotPasswordPage(),
        AdminSplashPage.id: (context) => const AdminSplashPage(),
        AdminLoginPage.id: (context) => AdminLoginPage(),
        AdminHomePage.id: (context) => const AdminHomePage(),
        AdminProgramsPage.id: (context) => const AdminProgramsPage(),
        AdminProfessorsPage.id: (context) => const AdminProfessorsPage(),
        AdminSubjectsPage.id: (context) => const AdminSubjectsPage(),
        AdminSchedulesPage.id: (context) => const AdminSchedulesPage(),
      },
    );
  }
}
