import 'package:flutter/material.dart';
import 'package:odevv/education/quiz_detail_page.dart';
import 'package:odevv/education/video.dart';
import 'article_detail_page.dart';

class CyberSecurityVpnPage extends StatefulWidget {
  @override
  _CyberSecurityVpnPageState createState() => _CyberSecurityVpnPageState();
}

class _CyberSecurityVpnPageState extends State<CyberSecurityVpnPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent, // Koyu mavi arka plan
        title: Text('Siber Güvenlik ve VPN Eğitimi'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange, // Turuncu alt çizgi
          tabs: [
            Tab(
              icon: Icon(Icons.video_library, color: Colors.red, size: 30), // Kırmızı ve büyük ikon
              text: 'Videolar',
            ),
            Tab(
              icon: Icon(Icons.quiz, color: Colors.yellow, size: 30), // Sarı ve büyük ikon
              text: 'Quiz',
            ),
            Tab(
              icon: Icon(Icons.book, color: Colors.green, size: 30), // Yeşil ve büyük ikon
              text: 'Makaleler',
            ),

          ],
        ),
      ),
      body: Container(
        color: Colors.orange[50], // Çok açık turuncu arka plan
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildVideoTab(),
            _buildQuizTab(),
            _buildArticlesTab(),
          ],
        ),
      ),
    );
  }

  // Videolar Sekmesi
  Widget _buildVideoTab() {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.play_circle_fill, color: Colors.red),
          title: Text('VPN Nedir ve Nasıl Çalışır?'),
          subtitle: Text('VPN kullanımının temel prensipleri.'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => YouTubeVideoDetailPage(
                  title: 'Ağ Güvenliği Temelleri',
                  description: 'Wi-Fi ağlarının güvenliği',
                  videoUrl: 'https://www.youtube.com/watch?v=d9m0epffI3U', // Replace with the actual video URL
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.play_circle_fill, color: Colors.red),
          title: Text('Ağ Güvenliği Temelleri'),
          subtitle: Text('Ağ Güvenliği Temelleri Nedir?'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => YouTubeVideoDetailPage(
                  title: 'Ağ Güvenliği Temelleri',
                  description: 'Wi-Fi ağlarının güvenliği.',
                  videoUrl: 'https://www.youtube.com/watch?v=d30mdlHGvdg&list=PLe-saRM3WlvNJFG4DfwYzTL9P20M6DPHj', // Replace with the actual video URL
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.play_circle_fill, color: Colors.red),
          title: Text('Siber Güvenlik'),
          subtitle: Text('Siber güvenlik nedir?'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => YouTubeVideoDetailPage(
                  title: 'Siber Güvenlik',
                  description: 'Siber güvenlik nedir?',
                  videoUrl: 'https://www.youtube.com/watch?v=wSWlQVPzBrI', // Replace with the actual video URL
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.play_circle_fill, color: Colors.red),
          title: Text('IP,DNS,VPN'),
          subtitle: Text('IP,DNS,VPN nedir?'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => YouTubeVideoDetailPage(
                  title: 'IP,DNS,VPN',
                  description: 'IP,DNS,VPN nedir?',
                  videoUrl: 'https://www.youtube.com/watch?v=1iwgjToHfVE', // Replace with the actual video URL
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Quiz Sekmesi
  Widget _buildQuizTab() {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.question_answer, color: Colors.yellow),
          title: Text('VPN ve Güvenlik Quiz 1'),
          subtitle: Text('Temel bilgilerinizi test edin.'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizDetailPage(
                  title: 'VPN Quiz',
                  questions: [
                    {
                      'question': '“Kişisel verilerin belli alanlarının silinerek veya yıldızlanarak kişinin belirlenemez hale getirilmesine ……….. denir.”ifadesindeki boşluğu doldurmak için kullanılacak en uygun ifade aşağıdakilerden hangisidir?',
                      'options': ['Veri maskeleme', 'Veri şifreleme', 'Bilgi güvenliği', 'Veri görselleştirme'],
                      'answer': 'Veri maskeleme',
                    },
                    {
                      'question': 'Bir yazılım veya sistemde, normal giriş çıkış noktaları dışında erişime veya veri çıkışına imkân veren, bilerek veyabilmeyerek oluşturulan açık noktalara verilen genel ad nedir?',
                      'options': ['Erişim izni', 'Arka kapı', 'Güvensiz erişim', 'Port açma '],
                      'answer': 'Arka kapı',
                    },
                    {
                      'question': 'Aşağıdakilerden hangisi siber zorbalığa uğradığınızda yapılması gerekenlerden biri değildir?',
                      'options': [
                        'Sosyal medya üzerinden saldırganı ifşa edecek paylaşımlarda bulunmak',
                        'onlineislemler.egm.gov.tr üzerinden ihbarda bulunmak',
                        'Emniyet Genel Müdürlüğü Siber Suçlarla Mücadele birimine müracaat etmek',
                        'İlgili dijital platformun şikâyet bildirme özelliğini kullanmak '
                      ],
                      'answer': 'Sosyal medya üzerinden saldırganı ifşa edecek paylaşımlarda bulunmak',
                    },
                    {
                      'question': 'Siber zorbalık ile ilgili aşağıdaki bilgilerden hangisi yanlıştır?',
                      'options': [
                        'Siber zorbalık yapan bireyler, bıraktıkları dijital ayak izleri ile tespit edilebilir.',
                        'Siber zorbalık, duygusal ve psikolojik olarak olumsuz sonuçlar doğurabilir. ',
                        'Siber zorbalığa uğramamak için sahte hesaplar kullanılması yeterlidir. ',
                        'Siber zorbalığa en sık maruz kalınan platformalar, sosyal medya ve çevrim içi oyunlardır.'
                      ],
                      'answer': 'Siber zorbalığa uğramamak için sahte hesaplar kullanılması yeterlidir. ',
                    },
                    {
                      'question': 'Bilgi sistemlerine yetkisiz erişim sağlayan saldırgan davranışları ile ilgili bilgi toplamaya yarayan tuzak sistemlerene ad verilmektedir?',
                      'options': ['IDS – Saldırı Tespit Sistemi', 'Honeypot – Bal Küpü', 'IPS – Saldırı Engelleme Sistemi', 'Sandbox – Kum Havuzu'],
                      'answer': 'Honeypot – Bal Küpü',
                    },
                    {
                      'question': 'Aşağıdakilerden hangisi iki faktörlü kimlik doğrulamaya örnek değildir?',
                      'options': ['Kullanıcı adı ve parola', 'PIN kodu ve yüz doğrulama', 'Parmak izi ve akıllı erişim kartı', 'Parola ve tek kullanımlık SMS kodu'],
                      'answer': 'Kullanıcı adı ve parola',
                    },
                    {
                      'question': 'Saldırganın, ağ üzerinden iletilen veri trafiğinin arasına girerek taraflar arasındaki iletişimi gizlice elde ettiğiveya değiştirdiği saldırı türüne ne ad verilir?',
                      'options': ['Kaba kuvvet (Brute-force) saldırısı', 'Kimlik avı saldırısı', 'Ortadaki adam (MITM) saldırısı', 'Oltalama (Phishing) saldırısı'],
                      'answer': 'Ortadaki adam (MITM) saldırısı',
                    },
                    {
                      'question': 'Aşağıdakilerden hangisi “Bilgi Güvenliği” ile “Siber Güvenlik” kavramları arasındaki ilişkiyi doğru biçimdetanımlar?',
                      'options': [
                        'Bilgi güvenliği ve siber güvenlik aynı anlamda kullanılan kavramlardır.',
                        'Bilgi güvenliği basılı belgeler gibi yalnızca fiziksel ortamlardaki bilgilerle, siber güvenlik isesiber ortamdaki bilgilerle ilişkilidir. ',
                        'Siber güvenlik ile bilgi güvenliği birbiri ile zıt kavramlardır.',
                        'Siber güvenlik dijital verileri korumayı amaçlarken, bilgi güvenliği tüm verileri korumayı amaçlar.'
                      ],
                      'answer': 'Siber güvenlik dijital verileri korumayı amaçlarken, bilgi güvenliği tüm verileri korumayı amaçlar.',
                    },
                    {
                      'question': '- Bir kişinin bilgisayarını, mobil cihaz ekranını ya da klavyesini gözetleyerek o kişiye ait hassas verileri elde etmeyeçalışma yöntemi olarak tanımlanabilecek saldırı türü aşağıdakilerden hangisidir?',
                      'options': ['Omuz sörfü', 'Kaba kuvvet saldırısı', 'Kimlik sahteciliği', 'Sahte erişim noktası'],
                      'answer': 'Omuz sörfü',
                    },
                    {
                      'question': 'Sosyal medya platformlarında paylaşılmış olan bir fotoğrafın üst veri (metadata) analizi sonucu aşağıdakilerdenhangisi elde edilemez?',
                      'options': ['Oluşturulduğu tarih ve saat', 'Çekildiği yerin coğrafi konumu', 'Çekildiği cihazın markası ve modeli', 'Yayımlandığı sitenin IP adresi'],
                      'answer': 'Yayımlandığı sitenin IP adresi',
                    },

                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Makaleler Sekmesi
  Widget _buildArticlesTab() {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.article, color: Colors.green),
          title: Text('Siber Güvenlik'),
          subtitle: Text('MODERN ÇAĞDA SİBER GÜVENLİK KAVRAMI',
              style: TextStyle(fontSize: 15)),
          onTap: () {
            String filePath = 'assets/article.txt'; // Dosya yolu

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailPage(
                  title: 'MODERN ÇAĞDA SİBER GÜVENLİK',
                  filePath: filePath, // Dosya yolunu geçiyoruz
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}