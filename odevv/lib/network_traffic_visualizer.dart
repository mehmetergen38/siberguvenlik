import 'dart:async';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

class NetworkTrafficVisualizer extends StatefulWidget {
  @override
  _NetworkTrafficVisualizerState createState() => _NetworkTrafficVisualizerState();
}

class _NetworkTrafficVisualizerState extends State<NetworkTrafficVisualizer> {
  List<_NetworkData> downloadData = [];
  List<_NetworkData> uploadData = [];
  Timer? timer;
  double time = 0;
  double maxSpeed = 0;
  double minSpeed = double.infinity;
  double totalDownload = 0;
  double totalUpload = 0;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    startMonitoring();
    initializeNotifications();
  }

  void initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin?.initialize(initializationSettings);
  }

  double getRandomData() {
    return (Random().nextDouble() * 100).clamp(1, 100);
  }

  void startMonitoring() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        time += 1;
        double downloadSpeed = getRandomData();
        double uploadSpeed = downloadSpeed / 2;

        downloadData.add(_NetworkData(time, downloadSpeed));
        uploadData.add(_NetworkData(time, uploadSpeed));

        totalDownload += downloadSpeed;
        totalUpload += uploadSpeed;

        if (downloadData.length > 20) downloadData.removeAt(0);
        if (uploadData.length > 20) uploadData.removeAt(0);

        maxSpeed = max(maxSpeed, downloadSpeed);
        minSpeed = min(minSpeed, downloadSpeed);

        if (downloadSpeed > 90) {
          showNotification('Yüksek Ağ Trafiği', 'İndirme hızı 90 Mbps\'i geçti!');
        }
      });
    });
  }

  void showNotification(String title, String body) async {
    var androidDetails = AndroidNotificationDetails('channel_id', 'channel_name', importance: Importance.high);
    var notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin?.show(0, title, body, notificationDetails);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> exportData() async {
    List<List<dynamic>> rows = [];
    rows.add(["Zaman", "İndirme Hızı (Mbps)", "Yükleme Hızı (Mbps)"]);

    for (int i = 0; i < downloadData.length; i++) {
      rows.add([downloadData[i].time, downloadData[i].speed, uploadData[i].speed]);
    }

    String csv = const ListToCsvConverter().convert(rows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ağ Trafik Görselleştirici'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: exportData,
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.orange[50],
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Anlık Veri Aktarımı Grafiği',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(
                  title: AxisTitle(text: 'Zaman (saniye)', textStyle: TextStyle(color: Colors.black)),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Hız (Mbps)', textStyle: TextStyle(color: Colors.black)),
                ),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  enablePanning: true,
                ),
                series: <ChartSeries>[
                  LineSeries<_NetworkData, double>(
                    name: 'İndirme Hızı',
                    dataSource: downloadData,
                    xValueMapper: (_NetworkData data, _) => data.time,
                    yValueMapper: (_NetworkData data, _) => data.speed,
                    color: Colors.green,
                  ),
                  LineSeries<_NetworkData, double>(
                    name: 'Yükleme Hızı',
                    dataSource: uploadData,
                    xValueMapper: (_NetworkData data, _) => data.time,
                    yValueMapper: (_NetworkData data, _) => data.speed,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.download, color: Colors.green),
                  title: Text('İndirme Hızı', style: TextStyle(color: Colors.black)),
                  trailing: Text('${downloadData.isNotEmpty ? downloadData.last.speed.toStringAsFixed(2) : 0} Mbps', style: TextStyle(color: Colors.black)),
                ),
                ListTile(
                  leading: Icon(Icons.upload, color: Colors.red),
                  title: Text('Yükleme Hızı', style: TextStyle(color: Colors.black)),
                  trailing: Text('${uploadData.isNotEmpty ? uploadData.last.speed.toStringAsFixed(2) : 0} Mbps', style: TextStyle(color: Colors.black)),
                ),
                ListTile(
                  leading: Icon(Icons.speed, color: Colors.blue),
                  title: Text('Ortalama İndirme Hızı', style: TextStyle(color: Colors.black)),
                  trailing: Text('${(totalDownload / time).toStringAsFixed(2)} Mbps', style: TextStyle(color: Colors.black)),
                ),
                ListTile(
                  leading: Icon(Icons.high_quality, color: Colors.purple),
                  title: Text('En Yüksek Hız', style: TextStyle(color: Colors.black)),
                  trailing: Text('$maxSpeed Mbps', style: TextStyle(color: Colors.black)),
                ),
                ListTile(
                  leading: Icon(Icons.low_priority, color: Colors.redAccent),
                  title: Text('En Düşük Hız', style: TextStyle(color: Colors.black)),
                  trailing: Text('$minSpeed Mbps', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                downloadData.clear();
                uploadData.clear();
                time = 0;
                totalDownload = 0;
                totalUpload = 0;
                maxSpeed = 0;
                minSpeed = double.infinity;
              });
            },
            icon: Icon(Icons.refresh),
            label: Text('Yeniden Başlat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _NetworkData {
  final double time;
  final double speed;

  _NetworkData(this.time, this.speed);
}
