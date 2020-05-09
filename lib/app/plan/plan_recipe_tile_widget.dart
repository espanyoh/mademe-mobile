import 'package:flutter/material.dart';

class PlanReceipeTile extends StatelessWidget {
  final List<String> imgAssetPath;
  final String title;
  final String description;
  PlanReceipeTile(
      {@required this.imgAssetPath,
      @required this.title,
      @required this.description});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('hit something'),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xffFFEEE0), borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: <Widget>[
            Container(
              child: imgAssetPath.length > 0
                  ? Image.network(
                      imgAssetPath[0],
                      fit: BoxFit.fitHeight,
                      height: 40.0,
                      width: 40.0,
                    )
                  : Text('WAIT FOR IMAGE'),
            ),
            SizedBox(
              width: 17,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(color: Color(0xffFC9535), fontSize: 19),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              decoration: BoxDecoration(
                  color: Color(0xffFBB97C),
                  borderRadius: BorderRadius.circular(13)),
              child: Text(
                "Remove",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
