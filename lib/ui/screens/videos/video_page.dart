import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:framed_v2/data/models/movie_videos.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass_kit/glass_kit.dart';

@RoutePage(name: 'VideoPageRoute')
class VideoPage extends ConsumerStatefulWidget {
  final MovieVideo movieVideo;
  const VideoPage(this.movieVideo, {super.key});
  @override
  ConsumerState<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends ConsumerState<VideoPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.movieVideo.key,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        forceHD: true,
        useHybridComposition: true,
      ),
    );
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        // Handled by plugin
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.white,
        progressColors: const ProgressBarColors(
          playedColor: Colors.white,
          handleColor: Colors.white60,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Background Gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1a1a1a), Colors.black],
                  ),
                ),
              ),
              
              // Main Content
              Column(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: player,
                        );
                      }
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),

              // Enhanced Back Button (Overlay)
              Positioned(
                top: 50,
                left: 20,
                child: GestureDetector(
                  onTap: () => context.router.back(),
                  child: GlassContainer.frostedGlass(
                    height: 68,
                    width: 68,
                    shape: BoxShape.circle,
                    borderWidth: 1.5,
                    borderColor: Colors.white.withOpacity(0.2),
                    blur: 25,
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
