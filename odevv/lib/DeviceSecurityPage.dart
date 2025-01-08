import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DeviceSecurityPage extends StatefulWidget {
  @override
  _DeviceSecurityPageState createState() => _DeviceSecurityPageState();
}

class _DeviceSecurityPageState extends State<DeviceSecurityPage> {
  String osVersion = '';
  String deviceModel = '';
  String deviceSecurityStatus = 'Cihaz güvenliği kontrol ediliyor...';
  bool isRooted = false;
  int batteryLevel = 0;
  String deviceLocation = 'Konum alınıyor...';
  Battery _battery = Battery();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Timer? _inactivityTimer;
  int _inactivityTimeLimit = 60; // 60 saniye, süreyi değiştirebilirsiniz

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _getDeviceInfo();
    _getBatteryLevel();
    _getDeviceLocation();
    _startInactivityTimer();
  }

  // Bildirimleri başlatma
  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Bildirim Gönderme
  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'default_channel',
      'Default',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  // Cihaz bilgilerini almak
  Future<void> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String securityStatus = '';
    bool rooted = false;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      // İşletim sistemi bilgisi
      setState(() {
        osVersion = androidInfo.version.release;
        deviceModel = androidInfo.model;
      });

      // Güncellenmeyen Android sürümü kontrolü
      if (androidInfo.version.release.compareTo('12') < 0) {
        securityStatus = 'Güncellemeler yapılmalı!';
      } else {
        securityStatus = 'Cihaz güvenli';
      }

      // Root kontrolü
      if (androidInfo.isPhysicalDevice && await _isRooted()) {
        rooted = true;
        securityStatus = 'Cihazınız rootlu!';
      }
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        deviceModel = iosInfo.model;
        osVersion = iosInfo.systemVersion;
      });

      securityStatus = 'Cihaz güvenli'; // iOS için root kontrolü yapamayız
    }

    setState(() {
      deviceSecurityStatus = securityStatus;
      isRooted = rooted;
    });
  }

  Future<bool> _isRooted() async {
    try {
      final file = File('/system/bin/su');
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  // Batarya seviyesini almak
  Future<void> _getBatteryLevel() async {
    try {
      int level = await _battery.batteryLevel;
      setState(() {
        batteryLevel = level;
      });
    } catch (e) {
      setState(() {
        batteryLevel = 0; // Hata durumunda batarya seviyesini sıfır olarak ayarlıyoruz
      });
    }
  }

  // Cihazın konumunu almak
  Future<void> _getDeviceLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        deviceLocation = 'Lat: ${position.latitude}, Long: ${position.longitude}';
      });
    } catch (e) {
      setState(() {
        deviceLocation = 'Konum alınamadı';
      });
    }
  }

  // Kullanıcı etkileşimi ile zamanlayıcıyı sıfırlama
  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _startInactivityTimer();
  }

  // Etkinlik yapmama durumunda zamanlayıcı başlatma
  void _startInactivityTimer() {
    _inactivityTimer = Timer.periodic(Duration(seconds: _inactivityTimeLimit), (timer) {
      _showNotification('Uyarı', 'Cihazınız uzun süredir kullanılmadı!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobil Cihaz Güvenliği İzlencesi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.orange[50],
      body: GestureDetector(
        onPanUpdate: (_) => _resetInactivityTimer(), // Kaydırma hareketini dinler
        onTap: () => _resetInactivityTimer(), // Ekrana dokunmayı dinler
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                title: 'Cihaz Modeli',
                content: deviceModel,
                icon: Icons.phone_android,
                iconColor: Colors.blue,
              ),
              _buildInfoCard(
                title: 'İşletim Sistemi',
                content: osVersion,
                icon: Icons.system_update,
                iconColor: Colors.orange,
              ),
              _buildInfoCard(
                title: 'Batarya Durumu',
                content: '$batteryLevel%',
                icon: Icons.battery_full,
                iconColor: Colors.green,
              ),
              _buildInfoCard(
                title: 'Konum',
                content: deviceLocation,
                icon: Icons.location_on,
                iconColor: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'Cihaz Güvenliği Durumu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: deviceSecurityStatus == 'Cihaz güvenli' ? Colors.green : Colors.red),
              ),
              SizedBox(height: 20),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: deviceSecurityStatus == 'Cihaz güvenli'
                    ? Icon(Icons.check_circle, color: Colors.green, size: 60)
                    : Icon(Icons.warning, color: Colors.red, size: 60),
              ),
              SizedBox(height: 20),
              isRooted
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Root Durumu: Rootlu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  Center(child: Icon(Icons.error, color: Colors.red, size: 60)),
                ],
              )
                  : Text(
                'Root Durumu: Rootlu Değil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _getDeviceInfo();
                  _getBatteryLevel();
                  _getDeviceLocation();
                },
                child: Text('Yenile'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bilgi kartları için yardımcı fonksiyon
  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor, size: 30),
        ),
        title: Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        subtitle: Text(content, style: TextStyle(color: Colors.black54)),
      ),
    );
  }
}
