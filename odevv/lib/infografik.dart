import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gelişmiş Siber Güvenlik Infografiği',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InfographicPage(),
    );
  }
}

class InfographicPage extends StatelessWidget {
  final List<String> imageUrls = [
    'https://spaksu.com/wp-content/uploads/2023/07/Siber-Guvenlik-Terimler-2-Spaksu-scaled.jpg',
    'https://www.aa.com.tr/uploads/userFiles/52f7c4d2-852f-4a9e-b343-be9ef8b66754/2019%2F03%2Fsiber_saldiri_1120.jpg',
    'https://pbs.twimg.com/media/CheFJucUUAEh0If.jpg:large',
  ];

  // TAM EKRAN GÖRÜNTÜLEME FONKSİYONU
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4.0,
          child: Stack(
            children: [
              Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Siber Güvenlik Infografiği'),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.orange[50],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Siber Güvenlik: Dijital Dünyada Güvenli Kalmanın Yolları',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Siber güvenlik, dijital ortamda kişisel ve kurumsal verileri korumak için hayati öneme sahiptir. '
                  'Bu infografikte, farklı güvenlik önlemleri, tehdit türleri ve bu tehditlerden korunma yollarını öğreneceksiniz.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              'Infografik Görselleri',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: imageUrls
                  .map(
                    (url) => GestureDetector(
                  onTap: () => _showFullScreenImage(context, url),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        url,
                        height: 200,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              'Resim yüklenirken hata oluştu!',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Güvenlik Önlemleri',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                _buildSecurityCard(
                  icon: Icons.lock,
                  title: 'Güçlü Şifreler',
                  description:
                  'Şifrelerinizin karmaşık ve tahmin edilmesi zor olduğundan emin olun.',
                ),
                _buildSecurityCard(
                  icon: Icons.security,
                  title: 'VPN Kullanımı',
                  description:
                  'Çevrimiçi aktivitelerinizi şifreleyin ve anonim olarak gezinin.',
                ),
                _buildSecurityCard(
                  icon: Icons.update,
                  title: 'Yazılım Güncellemeleri',
                  description:
                  'Güncellemeler, bilinen güvenlik açıklarını kapatır ve cihazınızı korur.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.orangeAccent),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }
}
