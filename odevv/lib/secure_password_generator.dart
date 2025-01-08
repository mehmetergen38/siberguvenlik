import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecurePasswordGeneratorPage extends StatefulWidget {
  @override
  _SecurePasswordGeneratorPageState createState() => _SecurePasswordGeneratorPageState();
}

class _SecurePasswordGeneratorPageState extends State<SecurePasswordGeneratorPage> {
  int _passwordLength = 12;
  bool _includeNumbers = true;
  bool _includeUppercase = true;
  bool _includeSpecialChars = true;
  String _generatedPassword = '';

  final Map<String, String> _securityLevels = {
    'Weak': '🟠 Zayıf',
    'Medium': '🟡 Orta',
    'Strong': '🟢 Güçlü'
  };

  String get _passwordStrength {
    if (_passwordLength < 8) return 'Weak';
    if (_passwordLength < 12) return 'Medium';
    return 'Strong';
  }

  void _generatePassword() {
    const String lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numbers = '0123456789';
    const String specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = lowerCaseLetters;
    if (_includeUppercase) chars += upperCaseLetters;
    if (_includeNumbers) chars += numbers;
    if (_includeSpecialChars) chars += specialChars;

    Random random = Random();
    String password = '';
    for (int i = 0; i < _passwordLength; i++) {
      password += chars[random.nextInt(chars.length)];
    }

    setState(() {
      _generatedPassword = password;
    });
  }

  void _copyToClipboard() {
    if (_generatedPassword.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _generatedPassword));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifre panoya kopyalandı!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🔒 Güvenli Şifre Oluşturucu'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.orange[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Şifre Uzunluğu: $_passwordLength', style: TextStyle(color: Colors.black, fontSize: 16)),
            Slider(
              value: _passwordLength.toDouble(),
              min: 6,
              max: 20,
              divisions: 14,
              label: _passwordLength.toString(),
              onChanged: (value) {
                setState(() {
                  _passwordLength = value.toInt();
                });
              },
              activeColor: Colors.orange,
              inactiveColor: Colors.orangeAccent,
            ),
            CheckboxListTile(
              title: Text('Sayılar Eklensin', style: TextStyle(color: Colors.black)),
              value: _includeNumbers,
              onChanged: (value) {
                setState(() {
                  _includeNumbers = value!;
                });
              },
              activeColor: Colors.orange,
            ),
            CheckboxListTile(
              title: Text('Büyük Harfler Eklensin', style: TextStyle(color: Colors.black)),
              value: _includeUppercase,
              onChanged: (value) {
                setState(() {
                  _includeUppercase = value!;
                });
              },
              activeColor: Colors.orange,
            ),
            CheckboxListTile(
              title: Text('Özel Karakterler Eklensin', style: TextStyle(color: Colors.black)),
              value: _includeSpecialChars,
              onChanged: (value) {
                setState(() {
                  _includeSpecialChars = value!;
                });
              },
              activeColor: Colors.orange,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _generatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('🔄 Şifre Oluştur'),
              ),
            ),
            SizedBox(height: 20),
            if (_generatedPassword.isNotEmpty)
              Column(
                children: [
                  Text(
                    'Oluşturulan Şifre:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  SelectableText(
                    _generatedPassword,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _copyToClipboard,
                    icon: Icon(Icons.copy),
                    label: Text('Kopyala'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: _passwordLength / 20,
                    backgroundColor: Colors.red,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        _passwordLength < 8
                            ? Colors.red
                            : _passwordLength < 12
                            ? Colors.yellow
                            : Colors.green),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Güvenlik Seviyesi: ${_securityLevels[_passwordStrength]}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _passwordStrength == 'Weak'
                          ? Colors.red
                          : _passwordStrength == 'Medium'
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
