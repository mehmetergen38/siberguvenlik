import 'package:flutter/material.dart';
import 'main.dart';  // Ana ekranı buraya import edin

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3 saniye sonra ana sayfaya yönlendirme
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VpnCheckPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Arka plan rengini belirleyebilirsiniz
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/vpn.png'),
            fit: BoxFit.cover, // BoxFit.cover görseli ekrana tam sığacak şekilde ölçekler
          ),
        ),
      ),
    );

  }
}
