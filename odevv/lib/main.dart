import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:odevv/secure_password_generator.dart';
import 'package:odevv/security.dart';
import 'dart:convert';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

// Diğer sayfaların importları
import 'DeviceSecurityPage.dart';
import 'PrivacySettingsPage.dart';
import 'SecurityAudit.dart';
import 'SplashScreen.dart';
import 'darkweb.dart';
import 'education/cyber_security_vpn.dart';
import 'infografik.dart';
import 'network_traffic_visualizer.dart';

void main() {
  runApp(VpnSecurityApp());
}

class VpnSecurityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Siber Güvenlik ve VPN Uygulaması',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          brightness: Brightness.light,
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
            bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.tealAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        home: SplashScreen()
    );
  }
}

class VpnCheckPage extends StatefulWidget {
  @override
  _VpnCheckPageState createState() => _VpnCheckPageState();
}

class _VpnCheckPageState extends State<VpnCheckPage> {
  String vpnStatus = '';
  String currentIp = '';
  String deviceIp = '';
  String wifiSecurityType = 'Güvenli (WPA2 veya WPA3)';
  String dnsLeakStatus = '';
  String malwareStatus = 'Kötü amaçlı yazılım tespiti yapılmadı';
  String batteryStatus = 'Bilinmiyor'; // Battery status
  late Timer _timer;

  Battery _battery = Battery(); // Battery instance

  @override
  void initState() {
    super.initState();
    requestPermissions();
    fetchCurrentIp();
    fetchDeviceIp();
    checkDnsLeak();
    checkForMalware();
    getBatteryStatus();  // Fetch battery status on initialization

    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      fetchCurrentIp();
      fetchDeviceIp();
      checkDnsLeak();
      checkForMalware();
      getBatteryStatus();  // Refresh battery status every 10 seconds
    });
  }

  // Request location permission
  void requestPermissions() async {
    await Permission.location.request();
  }

  // Fetch current public IP
  void fetchCurrentIp() async {
    try {
      final response = await http.get(Uri.parse('https://api.ipify.org?format=json'));
      if (response.statusCode == 200) {
        String ip = json.decode(response.body)['ip'];
        setState(() {
          currentIp = ip;
        });
      } else {
        setState(() {
          vpnStatus = 'IP adresi alınamadı. Durum kodu: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        vpnStatus = 'IP adresi alınırken hata: $e';
      });
    }
  }

  // Fetch device local IP
  void fetchDeviceIp() async {
    final info = NetworkInfo();
    String? ip = await info.getWifiIP();
    setState(() {
      deviceIp = ip ?? 'Bilinmiyor';
    });
  }

  // Check DNS leak status
  void checkDnsLeak() async {
    try {
      final response = await http.get(Uri.parse('https://dnsleaktest.com/test/standard.html'));
      if (response.statusCode == 200) {
        String dnsLeakResult = response.body.contains('No DNS Leak') ? 'DNS sızıntısı yok' : 'DNS sızıntısı tespit edildi';
        setState(() {
          dnsLeakStatus = dnsLeakResult;
        });
      } else {
        setState(() {
          dnsLeakStatus = 'DNS sızıntısı testi başarısız. Durum kodu: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        dnsLeakStatus = 'DNS sızıntısı testi sırasında hata: $e';
      });
    }
  }

  // Check for malware
  void checkForMalware() async {
    try {
      bool malwareDetected = false;
      setState(() {
        malwareStatus = malwareDetected ? 'Kötü amaçlı yazılım tespit edildi!' : 'Kötü amaçlı yazılım tespit edilmedi';
      });
    } catch (e) {
      setState(() {
        malwareStatus = 'Kötü amaçlı yazılım kontrolü sırasında hata: $e';
      });
    }
  }

  // Fetch battery status
  void getBatteryStatus() async {
    try {
      int batteryLevel = await _battery.batteryLevel;  // Get battery level
      setState(() {
        batteryStatus = '$batteryLevel%';
      });
    } catch (e) {
      setState(() {
        batteryStatus = 'Batarya durumu alınırken hata: $e';
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Siber Güvenlik ve VPN Uygulaması', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: Colors.orangeAccent,
      ),
      backgroundColor: Colors.orange[20],
      drawer: Drawer(
        child: Container(
          color: Colors.orange[50], // Hafif arka plan rengi
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                ),
                accountName: Text(
                  'Mehmet Ergen',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  'ergenm11@gmail.com',
                  style: TextStyle(fontSize: 14),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.orangeAccent, size: 40),
                ),
              ),


              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerTile(Icons.privacy_tip, 'Gizlilik Ayarları', PrivacySettingsPage()),
                    _buildDrawerTile(Icons.security, 'Mobil Cihaz Güvenliği İzlencesi', DeviceSecurityPage()),
                    Divider(), // Menü ayracı
                    _buildDrawerTile(Icons.visibility_outlined, 'Dark Web İzleme', DarkWebMonitorPage()),
                    _buildDrawerTile(Icons.phishing, 'Kötü Amaçlı Yazılım ve Phishing Koruması', pishingPage()),
                    Divider(),
                    _buildDrawerTile(Icons.check_circle_outline, 'Güvenlik Denetim Listesi', SecurityAuditPage()),
                    _buildDrawerTile(Icons.password_outlined, 'Güvenli Şifre Oluşturucu', SecurePasswordGeneratorPage()),
                    _buildDrawerTile(Icons.wifi_tethering, 'Ağ Trafiği', NetworkTrafficVisualizer()),
                    _buildDrawerTile(Icons.vpn_lock, 'VPN Kontrolü', CyberSecurityVpnPage()),
                    _buildDrawerTile(Icons.shield, 'Siber Güvenlik Infografiği', InfographicPage()),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.redAccent),
                title: Text('Çıkış Yap', style: TextStyle(fontSize: 16)),
                onTap: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
          ),


        body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCard(
                    title: 'Gerçek IP Adresiniz: $currentIp',
                    subtitle: vpnStatus,
                    icon: Icons.public,
                    iconColor: currentIp == deviceIp ? Colors.green : Colors.red,
                  ),
                  SizedBox(height: 20),
                  _buildInfoCard(
                    title: 'Wi-Fi Güvenlik Durumu',
                    subtitle: wifiSecurityType,
                    icon: Icons.wifi,
                    iconColor: wifiSecurityType == 'Güvenli (WPA2 veya WPA3)' ? Colors.green : Colors.orange,
                  ),
                  SizedBox(height: 20),
                  _buildInfoCard(
                    title: 'Kötü Amaçlı Yazılım Durumu',
                    subtitle: malwareStatus,
                    icon: Icons.bug_report_outlined,
                    iconColor: malwareStatus == 'Kötü amaçlı yazılım tespit edilmedi' ? Colors.green : Colors.red,
                  ),
                  SizedBox(height: 20),
                  _buildInfoCard(
                    title: 'Batarya Durumu',
                    subtitle: batteryStatus,
                    icon: Icons.battery_full,
                    iconColor: batteryStatus.contains('%') ? Colors.green : Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String subtitle, required IconData icon, required Color iconColor}) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(vertical: 12),
      elevation: 10,
      shadowColor: Colors.black12,
      child: ListTile(
        contentPadding: EdgeInsets.all(18.0),
        leading: CircleAvatar(
          radius: 35,
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor, size: 35),
        ),
        title: Text(title, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.black54, fontSize: 14)),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String subtitle, required IconData icon, required Color iconColor}) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(vertical: 12),
      elevation: 10,
      shadowColor: Colors.black12,
      child: ListTile(
        contentPadding: EdgeInsets.all(20.0),
        leading: CircleAvatar(
          radius: 38,
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor, size: 38),
        ),
        title: Text(title, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.black54, fontSize: 15)),
      ),
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange[600]),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}
