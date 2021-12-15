import 'package:flutter/material.dart';
import 'package:meal_application/AppScreens/Meal_Details_Screen.dart';
import 'package:meal_application/Modals/Meal_Modal.dart';

import 'package:page_transition/page_transition.dart';

class mealWidget extends StatelessWidget {
  final String? img;
  final String? id;
  final String? title;
  final int? duration;
  final Affordability? affordabilityVariable;
  final Complexity? complexityVariable;
  final List<Meal>? mylist;

  mealWidget({
    this.id,
    this.title,
    this.img,
    this.duration,
    this.affordabilityVariable,
    this.complexityVariable,
    this.mylist,
  });

  String get aford {
    if (affordabilityVariable == Affordability.Affordable) {
      return "Affordable";
    } else if (affordabilityVariable == Affordability.Luxurious) {
      return "Luxurious";
    } else {
      return "Pricey";
    }
  }

  String get compx {
    if (complexityVariable == Complexity.Challenging) {
      return "Challenging";
    } else if (complexityVariable == Complexity.Hard) {
      return "Hard";
    } else {
      return "Simple";
    }
  }

  Stack StackBuilder(BuildContext ctx, bool island, double hei, double wid) {
    return Stack(
      children: [
        InteractiveViewer(
          boundaryMargin: EdgeInsets.zero,
          constrained: true,
          alignPanAxis: true,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: Hero(
                tag: id.toString(),
                child: FadeInImage(
                  placeholder: AssetImage("assets/images/Loading.jpg"),
                  image: NetworkImage(
                    img.toString(),
                  ),
                  width: double.infinity,
                  height: island ? hei * 0.39 : hei * 0.252,
                  fit: BoxFit.fill,
                )),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            color: Theme.of(ctx).buttonColor,
            padding: EdgeInsets.all(10),
            width: island ? wid * 0.30 : wid * 0.38,
            height: island ? hei * 0.15 : hei * 0.10,
            child: Text(
              title.toString(),
              style: Theme.of(ctx).textTheme.headline6,
              softWrap: true,
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }

  Row RowBuild(IconData ico, String textlabel, BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          ico,
          color: Theme.of(ctx).iconTheme.color,
          size: Theme.of(ctx).iconTheme.size,
        ),
        SizedBox(width: 5),
        Text(textlabel,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(ctx).iconTheme.color,
            )),
      ],
    );
  }

  Widget RowBuilder(BuildContext ctx, bool island, double hei) {
    return Padding(
      padding: EdgeInsets.all(island ? 5 : hei * 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RowBuild(Icons.schedule, duration.toString() + " min", ctx),
          RowBuild(Icons.work, aford.toString(), ctx),
          RowBuild(Icons.attach_money, compx.toString(), ctx),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double hei = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return MealDetails(id.toString(), mylist!);
        }));
      },
      child: Card(
        elevation: 10,
        margin: EdgeInsets.all(8),
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StackBuilder(context, islandscape, hei, wid),
              Container(
                margin: EdgeInsets.only(
                  top: islandscape ? hei * 0.01 : hei * 0.0143,
                  bottom: islandscape ? hei * 0.001 : hei * 0.0143,
                ),
                child: RowBuilder(context, islandscape, hei),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
