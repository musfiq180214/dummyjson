import 'package:dummyjson/features/courses/presentation/thank_you_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/navigation/app_navigator.dart';
import '../../../core/navigation/route_names.dart';
import '../domain/video.dart';
import '../providers/vedio_Provider.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseTitle;
  final List<Video> playlist;

  const CourseDetailScreen({
    super.key,
    required this.courseTitle,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoProvider(playlist: playlist),
      child: Builder(
        builder: (context) {
          final videoProvider =
          Provider.of<VideoProvider>(context, listen: false);

          // Playlist end callback
          videoProvider.onPlaylistEnd = () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ThankYouScreen()),
            );
          };

          return Scaffold(
            appBar: AppBar(title: Text(courseTitle), centerTitle: true),
            body: Consumer<VideoProvider>(
              builder: (context, videoProvider, _) {
                final currentIndex = videoProvider.currentIndex;
                final currentVideo = videoProvider.currentVideo;

                return Column(
                  children: [
                    // Video Player
                    if (videoProvider.controller != null)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: YoutubePlayer(
                          key: ValueKey(currentVideo?.url),
                          controller: videoProvider.controller!,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.blueAccent,
                          progressColors: const ProgressBarColors(
                            playedColor: Colors.blue,
                            handleColor: Colors.blueAccent,
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 220,
                        color: Colors.black12,
                        child: const Center(
                          child: Text(
                            'Select a video to play',
                            style: TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                        ),
                      ),

                    const Divider(),

                    // Video List
                    Expanded(
                      child: ListView.builder(
                        itemCount: playlist.length,
                        itemBuilder: (context, index) {
                          final video = playlist[index];
                          final isPlaying = currentVideo?.title == video.title;
                          return Container(
                            color: isPlaying ? Colors.blue.shade50 : null,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              title: Text(
                                video.title,
                                style: TextStyle(
                                  fontWeight: isPlaying
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(video.duration),
                              trailing: isPlaying
                                  ? const Icon(Icons.play_arrow,
                                  color: Colors.blue)
                                  : null,
                              onTap: () {
                                videoProvider.playVideo(video, index: index);
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    // Controls
                    if (videoProvider.controller != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.skip_previous, size: 40),
                              color: currentIndex > 0
                                  ? Colors.blue
                                  : Colors.grey,
                              onPressed: currentIndex > 0
                                  ? videoProvider.playPrevious
                                  : null,
                            ),
                            IconButton(
                              icon: SizedBox(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  videoProvider.controller!.value.isPlaying
                                      ? Icons.play_circle_filled
                                      : Icons.pause_circle_filled,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              ),
                              onPressed: () {
                                if (videoProvider.controller!.value.isPlaying) {
                                  videoProvider.pauseVideo();
                                } else {
                                  videoProvider.resumeVideo();
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next, size: 40),
                              color: currentIndex < playlist.length - 1
                                  ? Colors.blue
                                  : Colors.grey,
                              onPressed: currentIndex < playlist.length - 1
                                  ? videoProvider.playNext
                                  : null,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

