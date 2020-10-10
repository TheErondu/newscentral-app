import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/videos_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  //
  VideoPlayerScreen(
      {this.videoItem, this.onEnterFullScreen, this.onExitFullScreen});
  final VideoItem videoItem;
  final VoidCallback onEnterFullScreen;
  final VoidCallback onExitFullScreen;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  //
  YoutubePlayerController _controller;
  bool _isPlayerReady;
  bool _fullScreen = true;

  @override
  void initState() {
    super.initState();
    _isPlayerReady = false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoItem.video.resourceId.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      //
    }
  }

  void listener() {
    setState(() {
      _fullScreen = _controller.value.isFullScreen;
    });
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _fullScreen
          ? null
          : AppBar(
              backgroundColor: Colors.black,
              centerTitle: true,
              title: Text(
                widget.videoItem.video.title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
      body: Container(
        height: double.infinity,
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            print('Player is ready.');
            _isPlayerReady = true;
          },
        ),
      ),
    );
  }
}
