import 'package:flutter/material.dart';

class ShowReview extends StatefulWidget {
  const ShowReview({Key? key}) : super(key: key);

  @override
  _ShowReviewState createState() => _ShowReviewState();
}

class _ShowReviewState extends State<ShowReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text('Show Review'),
      ),
      body: Container(
        margin: EdgeInsetsDirectional.only(top: 20),
        padding: EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 1,
          children: [
            Card(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 150),
            ),
          ],
        ),
      ),
    );
  }
}
