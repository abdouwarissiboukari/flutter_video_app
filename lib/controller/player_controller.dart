import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_video/model/datas.dart';
import 'package:learn_video/model/video.dart';
import 'package:learn_video/view/custom_views.dart';
import 'package:video_player/video_player.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PlayerController extends StatefulWidget {
  final Video video;

  const PlayerController({super.key, required this.video});

  @override
  PlayerControlerState createState() => PlayerControlerState();
}

class PlayerControlerState extends State<PlayerController> {
  late Video _video;
  late VideoPlayerController _videoPlayerController;
  late int currentIndex;
  late AutoScrollController autoScrollController;
  final scrollDirection = Axis.horizontal;
  late bool isVisible;

  bool canMountVideoPlayer() => _videoPlayerController.value.isInitialized;
  bool isPlaying() => _videoPlayerController.value.isPlaying;
  int getIndex() =>
      Datas().parseVideo().indexWhere((vid) => _video.index == vid.index);

  @override
  void initState() {
    super.initState();
    _video = widget.video;
    currentIndex = getIndex();
    configurePlayer();
    autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.right),
        axis: scrollDirection);

    isVisible = false;
  }

  @override
  void dispose() {
    deletePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_video.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isVisible = true;
                        Timer(const Duration(seconds: 5), () {
                          setState(() {
                            isVisible = false;
                          });
                        });
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      color: Colors.black,
                      child:
                          canMountVideoPlayer() ? fittedBoxView() : Container(),
                    ),
                  ),
                  (isVisible) ? playPauseButton() : Container(),
                ],
              ),
              Container(
                transform: Matrix4.translationValues(0.0, -8.0, 0.0),
                child: Column(
                  children: [
                    VideoProgressIndicator(_videoPlayerController,
                        allowScrubbing: true),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                              "${_videoPlayerController.value.duration.inSeconds}s"),
                          Text(
                              "${_videoPlayerController.value.position.inSeconds.toString()} s"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _video.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.all(10),
              //   child: Card(
              //     elevation: 3,
              //     child: Center(
              //       child: Row(
              //         mainAxisSize: MainAxisSize.max,
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           IconButton(
              //               onPressed: previous,
              //               icon: const Icon(Icons.skip_previous)),
              //           IconButton(
              //             onPressed: playPause,
              //             icon: Icon((isPlaying())
              //                 ? Icons.pause_circle
              //                 : Icons.play_circle),
              //           ),
              //           IconButton(
              //               onPressed: next, icon: const Icon(Icons.skip_next)),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                height: 150,
                child: ListView.builder(
                    controller: autoScrollController,
                    scrollDirection: scrollDirection,
                    itemCount: Datas().parseVideo().length,
                    itemBuilder: ((context, index) {
                      final newVideo = Datas().parseVideo()[index];
                      return AutoScrollTag(
                        key: ValueKey(index),
                        controller: autoScrollController,
                        index: index,
                        child: InkWell(
                          onTap: () {
                            onItemTap(index);
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    child: Image.network(
                                      newVideo.thumbString,
                                      fit: BoxFit.cover,
                                      height: 140,
                                      width: 140,
                                    ),
                                  ),
                                  (currentIndex == index)
                                      ? currentVideoCheckCircle()
                                      : Container(),
                                ],
                              )),
                        ),
                      );
                    })),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget aspectRatioView() {
    return AspectRatio(
      aspectRatio: _videoPlayerController.value.aspectRatio,
      child: VideoPlayer(_videoPlayerController),
    );
  }

  Widget fittedBoxView() {
    return FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.center,
      child: SizedBox(
        height: _videoPlayerController.value.size.height,
        width: _videoPlayerController.value.size.width,
        child: VideoPlayer(_videoPlayerController),
      ),
    );
  }

  Widget playPauseButton() {
    return AnimatedOpacity(
      opacity: (isVisible) ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: previous,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white24,
              size: 40,
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.transparent,
                  shape: BoxShape.circle),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    (isPlaying())
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                onTap: () {
                  playPause();
                },
              ),
            ),
          ),
          IconButton(
            onPressed: next,
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white24,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  configurePlayer() {
    _videoPlayerController = VideoPlayerController.network(_video.urlVideo);

    _videoPlayerController.addListener(() {
      update();
    });

    _videoPlayerController.setLooping(true);
    _videoPlayerController.initialize().then((_) {
      update();
      _videoPlayerController.play();
    });
  }

  deletePlayer() {
    _videoPlayerController.dispose();
    // _videoPlayerController.removeListener(() {
    //   update();
    // });
  }

  update() {
    if (mounted) {
      setState(() {});
    }
  }

  playPause() {
    isPlaying()
        ? _videoPlayerController.pause()
        : _videoPlayerController.play();
    update();
  }

  next() {
    if (currentIndex < Datas().parseVideo().length - 1) {
      currentIndex = currentIndex + 1;
      _video = Datas().parseVideo()[currentIndex];

      if (canMountVideoPlayer()) {
        _videoPlayerController.dispose();
      }

      configurePlayer();
      scrollToIndex(currentIndex);
    }

    // currentIndex = (currentIndex >= Datas().parseVideo().length - 1)
    //     ? 0
    //     : currentIndex + 1;
    // _video = Datas().parseVideo()[currentIndex];
    // configurePlayer();
    // scrollToIndex(currentIndex);
  }

  previous() {
    if (currentIndex > 0) {
      currentIndex = currentIndex - 1;
      _video = Datas().parseVideo()[currentIndex];

      if (canMountVideoPlayer()) {
        _videoPlayerController.dispose();
      }

      configurePlayer();
      scrollToIndex(currentIndex);
    }

    // currentIndex = (currentIndex <= 0)
    //     ? Datas().parseVideo().length - 1
    //     : currentIndex - 1;
    // _video = Datas().parseVideo()[currentIndex];
    // configurePlayer();
    // scrollToIndex(currentIndex);
  }

  onItemTap(int index) {
    currentIndex = index;
    _video = Datas().parseVideo()[currentIndex];

    if (canMountVideoPlayer()) {
      _videoPlayerController.dispose();
    }

    configurePlayer();
  }

  Future scrollToIndex(int index) async {
    await autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin);
  }
}
