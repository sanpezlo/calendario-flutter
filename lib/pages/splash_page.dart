import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/secondary_button.dart';
import 'package:calendario_flutter/pages/home_page.dart';
import 'package:calendario_flutter/pages/login_page.dart';
import 'package:calendario_flutter/pages/on_boarding_page.dart';
import 'package:calendario_flutter/services/firebase_auth_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  static const String id = "/splash";

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<List<ConnectivityResult>> connectivity =
      Connectivity().checkConnectivity();

  Future<void> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) return handleAuth();

    await prefs.setBool('seen', true);

    if (mounted) {
      Navigator.pushReplacementNamed(context, OnBoardingPage.id);
    }
  }

  void handleAuth() {
    if (FirebaseAuthService().currentUser != null) {
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Navigator.pushReplacementNamed(context, LoginPage.id);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: connectivity,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.contains(ConnectivityResult.none)) {
              return Center(
                child: noInternet(),
              );
            } else {
              Future.delayed(Duration.zero, () async {
                await checkFirstSeen();
              });
            }
          }

          return Center(
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
                    "UniTime",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget noInternet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.wifi_off,
          size: 80,
          color: AppColor.secondary,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            "Sin conexión a internet",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
        SecondaryButton(
          onPressed: () {
            setState(() {
              connectivity = Connectivity().checkConnectivity();
            });
          },
          text: "Recargar",
          fullWidth: false,
        )
      ],
    );
  }
}
