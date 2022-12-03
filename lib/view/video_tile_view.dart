import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_video/controller/player_controller.dart';
import 'package:learn_video/model/video.dart';

class VideoTileView extends StatelessWidget {
  final Video video;

  const VideoTileView({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() => onTapAction(context)),
      child: Card(
        margin: const EdgeInsets.all(0),
        child: Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 7),
                child: Text(
                  video.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Image.network(
                video.thumbString,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
              ),
              const Divider(
                color: Colors.deepOrangeAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onTapAction(BuildContext context) {
    final route = MaterialPageRoute(
      builder: (context) => PlayerController(
        video: video,
      ),
    );

    Navigator.push(context, route);
  }
}
