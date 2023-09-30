import 'package:app/models/galleryMedia.dart';
import 'package:chewie/chewie.dart';
import 'package:app/utils/media_player_theme.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';

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

  @override
  void initState() {
    initializePlayer();
    _createChewieController();
    super.initState();

  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  late String src = "http://161.35.46.18/gallery/${widget.galleryMedia.id}/video.mp4";
  // List<String> srcs = [
  //   "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
  //   "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
  //   "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  // ];

  Future<void> initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(src));
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    // final subtitles = [
    //     Subtitle(
    //       index: 0,
    //       start: Duration.zero,
    //       end: const Duration(seconds: 10),
    //       text: 'Hello from subtitles',
    //     ),
    //     Subtitle(
    //       index: 0,
    //       start: const Duration(seconds: 10),
    //       end: const Duration(seconds: 20),
    //       text: 'Whats up? :)',
    //     ),
    //   ];

    // final subtitles = [
    //   Subtitle(
    //     index: 0,
    //     start: Duration.zero,
    //     end: const Duration(seconds: 10),
    //     text: const TextSpan(
    //       children: [
    //         TextSpan(
    //           text: 'Hello',
    //           style: TextStyle(color: Colors.red, fontSize: 22),
    //         ),
    //         TextSpan(
    //           text: ' from ',
    //           style: TextStyle(color: Colors.green, fontSize: 20),
    //         ),
    //         TextSpan(
    //           text: 'subtitles',
    //           style: TextStyle(color: Colors.blue, fontSize: 18),
    //         )
    //       ],
    //     ),
    //   ),
    //   Subtitle(
    //     index: 0,
    //     start: const Duration(seconds: 10),
    //     end: const Duration(seconds: 20),
    //     text: 'Whats up? :)',
    //     // text: const TextSpan(
    //     //   text: 'Whats up? :)',
    //     //   style: TextStyle(color: Colors.amber, fontSize: 22, fontStyle: FontStyle.italic),
    //     // ),
    //   ),
    // ];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      draggableProgressBar: true,
      showControlsOnInitialize: true,
      showControls: true,
      showOptions: true,
      zoomAndPan: true,

      // progressIndicatorDelay:
      // bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,

      additionalOptions: (context) {
        return <OptionItem>[
          // OptionItem(
          //   onTap: (){},
          //   iconData: Icons.live_tv_sharp,
          //   title: 'Toggle Video Src',
          // ),
        ];
      },
      //subtitle: Subtitles(subtitles),
      // subtitleBuilder: (context, dynamic subtitle) => Container(
      //   padding: const EdgeInsets.all(10.0),
      //   child: subtitle is InlineSpan
      //       ? RichText(
      //     text: subtitle,
      //   )
      //       : Text(
      //     subtitle.toString(),
      //     style: const TextStyle(color: Colors.black),
      //   ),
      // ),

      hideControlsTimer: const Duration(seconds: 2),

      // Try playing around with some of these other options:

      // showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: true,
    );
  }

  // int currPlayIndex = 0;

  // Future<void> toggleVideo() async {
  //   await _videoPlayerController1.pause();
  //   currPlayIndex += 1;
  //   if (currPlayIndex >= srcs.length) {
  //     currPlayIndex = 0;
  //   }
  //   await initializePlayer();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.galleryMedia.text!,
      theme: AppTheme.light.copyWith(
        platform: TargetPlatform.android,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.galleryMedia.text!),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: _chewieController != null &&
                    _chewieController!
                        .videoPlayerController.value.isInitialized
                    ? Chewie(
                  controller: _chewieController!,
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
            TextButton(
              onPressed: () {
                _chewieController?.enterFullScreen();
              },
              child: const Text('Fullscreen'),
            ),
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       child: TextButton(
            //         onPressed: () {
            //           setState(() {
            //             _videoPlayerController1.pause();
            //             _videoPlayerController1.seekTo(Duration.zero);
            //             _createChewieController();
            //           });
            //         },
            //         child: const Padding(
            //           padding: EdgeInsets.symmetric(vertical: 16.0),
            //           child: Text("Landscape Video"),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: TextButton(
            //         onPressed: () {
            //           setState(() {
            //             _videoPlayerController2.pause();
            //             _videoPlayerController2.seekTo(Duration.zero);
            //             _chewieController = _chewieController!.copyWith(
            //               videoPlayerController: _videoPlayerController2,
            //               autoPlay: true,
            //               looping: true,
            //               /* subtitle: Subtitles([
            //                 Subtitle(
            //                   index: 0,
            //                   start: Duration.zero,
            //                   end: const Duration(seconds: 10),
            //                   text: 'Hello from subtitles',
            //                 ),
            //                 Subtitle(
            //                   index: 0,
            //                   start: const Duration(seconds: 10),
            //                   end: const Duration(seconds: 20),
            //                   text: 'Whats up? :)',
            //                 ),
            //               ]),
            //               subtitleBuilder: (context, subtitle) => Container(
            //                 padding: const EdgeInsets.all(10.0),
            //                 child: Text(
            //                   subtitle,
            //                   style: const TextStyle(color: Colors.white),
            //                 ),
            //               ), */
            //             );
            //           });
            //         },
            //         child: const Padding(
            //           padding: EdgeInsets.symmetric(vertical: 16.0),
            //           child: Text("Portrait Video"),
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       child: TextButton(
            //         onPressed: () {
            //           setState(() {
            //             _platform = TargetPlatform.android;
            //           });
            //         },
            //         child: const Padding(
            //           padding: EdgeInsets.symmetric(vertical: 16.0),
            //           child: Text("Android controls"),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: TextButton(
            //         onPressed: () {
            //           setState(() {
            //             _platform = TargetPlatform.iOS;
            //           });
            //         },
            //         child: const Padding(
            //           padding: EdgeInsets.symmetric(vertical: 16.0),
            //           child: Text("iOS controls"),
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       child: TextButton(
            //         onPressed: () {
            //           setState(() {
            //             _platform = TargetPlatform.windows;
            //           });
            //         },
            //         child: const Padding(
            //           padding: EdgeInsets.symmetric(vertical: 16.0),
            //           child: Text("Desktop controls"),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

          ],
        ),
      ),
    );
  }
}

// class DelaySlider extends StatefulWidget {
//   const DelaySlider({Key? key, required this.delay, required this.onSave})
//       : super(key: key);
//
//   final int? delay;
//   final void Function(int?) onSave;
//   @override
//   State<DelaySlider> createState() => _DelaySliderState();
// }
//
// class _DelaySliderState extends State<DelaySlider> {
//   int? delay;
//   bool saved = false;
//
//   @override
//   void initState() {
//     super.initState();
//     delay = widget.delay;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const int max = 1000;
//     return ListTile(
//       title: Text(
//         "Progress indicator delay ${delay != null ? "${delay.toString()} MS" : ""}",
//       ),
//       subtitle: Slider(
//         value: delay != null ? (delay! / max) : 0,
//         onChanged: (value) async {
//           delay = (value * max).toInt();
//           setState(() {
//             saved = false;
//           });
//         },
//       ),
//       trailing: IconButton(
//         icon: const Icon(Icons.save),
//         onPressed: saved
//             ? null
//             : () {
//           widget.onSave(delay);
//           setState(() {
//             saved = true;
//           });
//         },
//       ),
//     );
//   }
// }