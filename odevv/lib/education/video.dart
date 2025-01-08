import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final String videoUrl;

  const YouTubeVideoDetailPage({
    Key? key,
    required this.title,
    required this.description,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<YouTubeVideoDetailPage> createState() => _YouTubeVideoDetailPageState();
}

class _YouTubeVideoDetailPageState extends State<YouTubeVideoDetailPage> {
  late YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange, // AppBar rengi
      ),
      backgroundColor: Colors.orange[50], // Arka plan rengi
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YoutubePlayer(
              controller: _youtubePlayerController,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.orange, // Gelişim göstergesi rengi
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.description,
                style: const TextStyle(fontSize: 16, color: Colors.black), // Metin rengi
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _youtubePlayerController.value.isPlaying
                        ? _youtubePlayerController.pause()
                        : _youtubePlayerController.play();
                  });
                },
                icon: Icon(
                  _youtubePlayerController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.orange, // İkon rengi
                ),
                label: Text(
                  _youtubePlayerController.value.isPlaying
                      ? 'Durdur'
                      : 'Oynat',
                  style: TextStyle(color: Colors.white), // Buton metin rengi
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Buton arka plan rengi
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
