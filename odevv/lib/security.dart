import 'package:flutter/material.dart';

class pishingPage extends StatefulWidget {
  @override
  _pishingPageState createState() => _pishingPageState();
}

class _pishingPageState extends State<pishingPage> {
  final TextEditingController _controller = TextEditingController();
  String _message = 'Güvenli';
  List<String> _history = [];

  // URL kontrolü
  void _checkUrl(String url) {
    if (url.isEmpty) {
      setState(() {
        _message = 'URL boş olamaz!';
      });
      return;
    }

    if (url.contains('phishing') || url.contains('malware')) {
      setState(() {
        _message = 'Kötü Amaçlı URL Tespit Edildi!';
      });
    } else {
      setState(() {
        _message = 'Güvenli';
      });
    }
    // URL'yi ve sonucu geçmişe ekle
    _history.add('URL: $url - Sonuç: $_message');
  }

  // Geçmişi temizleme fonksiyonu
  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  // Başlangıçta, tarihçeyi 5 öğe ile sınırlı tutma (isteğe bağlı)
  List<String> get limitedHistory {
    if (_history.length > 5) {
      return _history.sublist(_history.length - 5);
    }
    return _history;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kötü Amaçlı Yazılım ve Phishing Koruması',style: TextStyle(
          fontSize: 18,fontWeight: FontWeight.bold
        ),),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.orange[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'URL Giriniz',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link, color: Colors.orangeAccent),
                hintStyle: TextStyle(color: Colors.black54),
                labelStyle: TextStyle(color: Colors.black),
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
              keyboardType: TextInputType.url,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _checkUrl(_controller.text),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), backgroundColor: Colors.orange,
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Kontrol Et'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                _message,
                style: TextStyle(
                  color: _message == 'Güvenli' ? Colors.green : Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _clearHistory,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), backgroundColor: Colors.orange,
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Geçmişi Temizle'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Geçmiş:',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: limitedHistory.map((url) {
                  return ListTile(
                    title: Text(
                      url,
                      style: TextStyle(color: Colors.black54),
                    ),
                    leading: Icon(Icons.history, color: Colors.black54),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
