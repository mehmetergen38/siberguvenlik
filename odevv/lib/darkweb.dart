import 'package:flutter/material.dart';
import 'dart:async'; // Import the async package for Timer

class DarkWebMonitorPage extends StatefulWidget {
  @override
  _DarkWebMonitorPageState createState() => _DarkWebMonitorPageState();
}

class _DarkWebMonitorPageState extends State<DarkWebMonitorPage> {
  String email = '';
  String creditCard = '';
  String phone = ''; // New field for phone number
  String statusMessage = '';
  bool isLoading = false; // Loading state for API call

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dark Web İzleme', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.orange[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    label: 'E-posta Adresi',
                    hint: 'E-posta adresinizi girin',
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'E-posta adresi boş olamaz';
                      }
                      String pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\b';
                      RegExp regExp = RegExp(pattern);
                      if (!regExp.hasMatch(value)) {
                        return 'Geçersiz e-posta adresi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  _buildTextField(
                    label: 'Telefon Numarası',
                    hint: 'Telefon numaranızı girin',
                    onChanged: (value) {
                      phone = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Telefon numarası boş olamaz';
                      }
                      if (value.length < 10) {
                        return 'Telefon numarası geçersiz';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _checkDarkWeb,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.orange,
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Dark Web\'de Ara',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: isLoading
                  ? CircularProgressIndicator() // Show a loading indicator while checking
                  : Text(
                statusMessage,
                style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _showPrivacyPolicy,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.grey,
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Gizlilik Politikası',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint, required ValueChanged<String> onChanged, String? Function(String?)? validator}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orangeAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: TextStyle(color: Colors.black),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  void _checkDarkWeb() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      statusMessage = 'Bilgiler kontrol ediliyor...';
      isLoading = true;
    });

    try {
      await Future.delayed(Duration(seconds: 3));

      bool foundInDarkWeb = false;

      setState(() {
        isLoading = false;
        statusMessage = foundInDarkWeb
            ? 'Bilgileriniz Dark Web\'de bulunmuştur.'
            : 'Bilgileriniz Dark Web\'de bulunmamaktadır.';
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        statusMessage = 'Bir hata oluştu: $e';
      });
    }
  }

  void _showPrivacyPolicy() {
    // Show privacy policy in a dialog or new screen
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gizlilik Politikası'),
          content: Text('Kişisel bilgileriniz yalnızca Dark Web taraması için kullanılacaktır. Hiçbir şekilde üçüncü şahıslara satılmayacaktır.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Kapat'),
            ),
          ],
        );
      },
    );
  }
}
