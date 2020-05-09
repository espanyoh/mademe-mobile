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
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () => print('hit something'),
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xffFFEEE0),
              borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  Container(
                    width: 170.0,
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              Spacer(),
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                // decoration: BoxDecoration(
                //     color: Color(0xffFBB97C),
                //     borderRadius: BorderRadius.circular(15)),
                child: IconButton(
                  icon: Icon(Icons.remove_circle),
                  color: Colors.redAccent,
                  onPressed: () => print('remove'),
                ),
                // Text(
                //   "Remove",
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 13,
                //       fontWeight: FontWeight.w500),
                // ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
