import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatefulWidget {
  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool dataCollectionEnabled = false;
  bool personalizedAdsEnabled = false;
  bool activityTrackingEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gizlilik Ayarları'),
        backgroundColor: Colors.orangeAccent, // Turuncu başlık
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.white, // Beyaz arka plan
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Veri Toplama ve Kullanım Şeffaflığı'),
              _buildInfoText(
                  '1. Toplanan Veriler:',
                  '   - IP Adresi\n   - Wi-Fi SSID\n   - DNS Durumu\n   - VPN Durumu'),
              SizedBox(height: 20),
              _buildInfoText(
                  '2. Verilerin Kullanım Amacı:',
                  '   - Kullanıcı deneyimini iyileştirmek\n   - VPN bağlantı güvenliği sağlamak\n   - Hız testi ve ağ bağlantısı durumu sağlamak'),
              SizedBox(height: 20),
              _buildInfoText(
                  '3. Verilerin Üçüncü Taraflarla Paylaşımı:',
                  '   - Kullanıcı bilgileri üçüncü taraflarla paylaşılmamaktadır.\n   - Veriler yalnızca güvenlik ve performans izleme amacıyla kullanılır.'),
              SizedBox(height: 20),
              _buildInfoText(
                  '4. Gizlilik Seçenekleri:',
                  '   - Verilerinizi silme veya düzenleme hakkına sahipsiniz.\n   - Gizlilik politikaları her zaman şeffaf olacaktır.'),
              SizedBox(height: 20),
              _buildSectionTitle('Gizlilik Ayarları'),
              _buildSwitchTile(
                'Veri Toplama İzni',
                dataCollectionEnabled,
                    (value) {
                  setState(() {
                    dataCollectionEnabled = value;
                  });
                },
              ),
              _buildSwitchTile(
                'Kişiselleştirilmiş Reklamlar',
                personalizedAdsEnabled,
                    (value) {
                  setState(() {
                    personalizedAdsEnabled = value;
                  });
                },
              ),
              _buildSwitchTile(
                'Etkinlik Takibi',
                activityTrackingEnabled,
                    (value) {
                  setState(() {
                    activityTrackingEnabled = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.orange, // Turuncu başlık
      ),
    );
  }

  Widget _buildInfoText(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, color: Colors.orange), // Turuncu başlık
        ),
        Text(
          content,
          style: TextStyle(fontSize: 16, color: Colors.black), // Siyah metin
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 18, color: Colors.orange), // Turuncu metin
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.orange, // Turuncu switch aktif rengi
      secondary: Icon(Icons.security, color: Colors.black), // Siyah ikon
    );
  }
}
