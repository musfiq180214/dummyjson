import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../domain/video.dart';

class VideoProvider extends ChangeNotifier {
  final List<Video> playlist; // <-- add this

  VideoProvider({required this.playlist}); // <-- constructor

  Video? _currentVideo;
  YoutubePlayerController? _controller;
  int _currentIndex = -1;
  bool _isDisposed = false;

  Video? get currentVideo => _currentVideo;
  YoutubePlayerController? get controller => _controller;
  int get currentIndex => _currentIndex;

  VoidCallback? onPlaylistEnd;

  /// Play selected video
  void playVideo(Video video, {int? index}) {
    if (_controller != null) {
      final oldController = _controller!;
      oldController.removeListener(_videoListener);
      Future.microtask(() => oldController.dispose());
    }

    _currentVideo = video;
    if (index != null) _currentIndex = index;

    final videoId = YoutubePlayer.convertUrlToId(video.url);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      )..addListener(_videoListener);
    }

    notifyListeners();
  }

  void _videoListener() {
    if (_controller == null || _isDisposed) return;

    if (_controller!.value.playerState == PlayerState.ended) {
      if (_currentIndex < playlist.length - 1) {
        Future.microtask(() {
          playNext();
        });
      } else {
        onPlaylistEnd?.call();
      }
    }
  }

  void playNext() {
    if (_currentIndex < playlist.length - 1) {
      playVideo(playlist[_currentIndex + 1], index: _currentIndex + 1);
    }
  }

  void playPrevious() {
    if (_currentIndex > 0) {
      playVideo(playlist[_currentIndex - 1], index: _currentIndex - 1);
    }
  }

  void pauseVideo() {
    _controller?.pause();
    notifyListeners();
  }

  void resumeVideo() {
    _controller?.play();
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }
}