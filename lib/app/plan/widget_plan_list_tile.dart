import 'package:flutter/material.dart';
import 'package:mademe/services/plan_recipe_service.dart';
import 'package:mademe/services/plan_service.dart';
import 'package:provider/provider.dart';

class PlanReceipeTile extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final List<String> imgAssetPath;
  PlanReceipeTile(
      {@required this.imgAssetPath,
      @required this.id,
      @required this.title,
      @required this.description});

  @override
  Widget build(BuildContext context) {
    final planRecipeService =
        Provider.of<PlanRecipeService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);
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
                  Container(
                    width: 180.0,
                    child: Text(title,
                        style:
                            TextStyle(color: Color(0xffFC9535), fontSize: 19),
                        overflow: TextOverflow.ellipsis),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    width: 170.0,
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              Spacer(),
              Container(
                child: IconButton(
                  icon: Icon(Icons.remove_circle),
                  color: Colors.redAccent,
                  onPressed: () {
                    planRecipeService.removeRecipe(
                        planService.current.id, this.id);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
