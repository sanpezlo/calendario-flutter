import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/pages/admin/home_page.dart';
import 'package:calendario_flutter/pages/admin/login_page.dart';
import 'package:calendario_flutter/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class AdminSplashPage extends StatefulWidget {
  static const String id = "/admin-splash";

  const AdminSplashPage({super.key});

  @override
  State<AdminSplashPage> createState() => _AdminSplashPageState();
}

class _AdminSplashPageState extends State<AdminSplashPage> {
  void handleAuth() {
    if (FirebaseAuthService().currentUser != null) {
      Future.delayed(
        const Duration(seconds: 0),
        () {
          Navigator.pushReplacementNamed(context, AdminHomePage.id);
        },
      );
    } else {
      Future.delayed(
        const Duration(seconds: 0),
        () {
          Navigator.pushReplacementNamed(context, AdminLoginPage.id);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    handleAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month,
              size: 80,
              color: AppColor.secondary,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Calendario académico",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
