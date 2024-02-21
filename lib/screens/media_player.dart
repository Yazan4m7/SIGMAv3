import 'package:app/models/galleryMedia.dart';
import 'package:chewie/chewie.dart';
import 'package:app/utils/media_player_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';

import '../utils/storage_service.dart';

class MediaPlayer extends StatefulWidget {
   const MediaPlayer({
    Key? key,
    required this.galleryMedia,
  }) : super(key: key);

  final GalleryMedia galleryMedia;

  @override
  State<StatefulWidget> createState() {
    return _MediaPlayerState();
  }
}

class _MediaPlayerState extends State<MediaPlayer> {
  // TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  double _aspectRatio = 16 / 9;
  bool _isLoading = true;
  @override
  void initState(){

    initializePlayer();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    // ]);

    addToMediaViewed(widget.galleryMedia.id!);
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  late String src = "http://161.35.46.18/gallery/${widget.galleryMedia.id}/video.mp4";

  Future<void> initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(src));
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    await _createChewieController();
    setState(() {
      _isLoading = false;
    });
    _chewieController.enterFullScreen();
  }

  Future<void> _createChewieController() async {
    _chewieController = ChewieController(
      allowedScreenSleep: false,
      allowFullScreen: true,
      // deviceOrientationsAfterFullScreen: [
      //   DeviceOrientation.landscapeRight,
      //   DeviceOrientation.landscapeLeft,
      //   DeviceOrientation.portraitUp,
      //   DeviceOrientation.portraitDown,
      // ],
      videoPlayerController: _videoPlayerController,
       aspectRatio: _aspectRatio,
      autoInitialize: true,
      autoPlay: true,
      showControls: true,
      fullScreenByDefault: false,
    );
    _chewieController.addListener(() {
      if (_chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:() async {
        _chewieController.exitFullScreen();
        Navigator.pop(context);
        return Future.value(true);
      },
      child: MaterialApp(
        title: widget.galleryMedia.text!,
        theme: AppTheme.light.copyWith(
          platform: TargetPlatform.android,
        ),
        home: Scaffold(
          body: _isLoading ?  Center(child: CircularProgressIndicator()) :  Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                      ? WillPopScope(
                    onWillPop:() async {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      return Future.value(true);
                    },
                        child: Chewie(
                    controller: _chewieController!,
                  ),
                      )
                      : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Loading'),
                    ],
                  ),
                ),
              ),
            ],
          ) ,
        ),
      ),
    );
  }
}

