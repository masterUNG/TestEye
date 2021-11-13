import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImagePost extends StatefulWidget {
  final String pathImage;
  const ShowImagePost({Key? key, required this.pathImage}) : super(key: key);

  @override
  _ShowImagePostState createState() => _ShowImagePostState();
}

class _ShowImagePostState extends State<ShowImagePost> {
  String? pathImage;

  @override
  void initState() {
    super.initState();
    pathImage = widget.pathImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoView(
        
        imageProvider: CachedNetworkImageProvider(pathImage!),
      ),
    );
  }
}
