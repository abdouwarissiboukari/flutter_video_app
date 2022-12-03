import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_video/model/datas.dart';
import 'package:learn_video/model/video.dart';
import 'package:learn_video/view/video_tile_view.dart';

class ListController extends StatelessWidget {
  List<Video> videos = Datas().parseVideo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Videos book"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => VideoTileView(
          video: videos[index],
        ),
        itemCount: videos.length,
      ),
    );
  }
}
