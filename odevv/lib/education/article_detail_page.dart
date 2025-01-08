import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ArticleDetailPage extends StatelessWidget {
  final String title;
  final String filePath;

  const ArticleDetailPage({
    Key? key,
    required this.title,
    required this.filePath,
  }) : super(key: key);


  Future<String> loadContent() async {
    return await rootBundle.loadString(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.orange[50],
      body: FutureBuilder<String>(
        future: loadContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Text(
                snapshot.data ?? '',
                style: TextStyle(fontSize: 16, color: Colors.black), // Metin rengi
              ),
            );
          }
        },
      ),
    );
  }
}
