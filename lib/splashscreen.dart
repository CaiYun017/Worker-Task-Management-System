import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wtms/mainscreen.dart';
import 'package:wtms/model/worker.dart';
import 'package:wtms/myconfig.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadUserCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber.shade900,
              Colors.purple.shade600,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png", scale: 3.5),
              const CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadUserCredentials() async {
    await Future.delayed(const Duration(seconds: 2)); // 添加延迟
    print("HELLOOO");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool rem = (prefs.getBool('remember')) ?? false;

    print("EMAIL: $email");
    print("PASSWORD: $password");
    print("ISCHECKED: $rem");
    if (rem == true) {
      http.post(Uri.parse("http://192.168.68.109/wtms/login_worker.php"), body: {
        "email": email,
        "password": password,
      }).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          var jsondata = json.decode(response.body);
          if (jsondata['status'] == 'success') {
            var workerdata = jsondata['data'];
            Worker worker = Worker.fromJson(workerdata[0]);
            print(worker.full_name);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen(worker: worker)),
            );
          } else {
            Worker worker = Worker(
              id:0,
              full_name: "Guest",
              email: "",
              phone: "",
              address: "",
              password: "",
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen(worker: worker)),
            );
          }
        }
      });
    } else {
      Worker worker = Worker(
              id:0,
              full_name: "Guest",
              email: "",
              phone: "",
              address: "",
              password: "",
            );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(worker: worker)),
      );
    }
  }
}