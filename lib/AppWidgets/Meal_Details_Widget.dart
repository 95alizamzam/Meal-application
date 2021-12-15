import 'package:flutter/material.dart';
import 'package:meal_application/AppProvider/MealProvider.dart';
import 'package:meal_application/Modals/Meal_Modal.dart';
import 'package:provider/provider.dart';

class Details_Widget extends StatelessWidget {
  final Meal meal;
  final String id;

  Details_Widget(this.meal, this.id);

  Widget ImageBuilder(bool island, double hei) {
    return SafeArea(
      child: Container(
        height: island ? hei * 0.60 : hei * 0.25,
        margin: EdgeInsets.symmetric(horizontal: 0),
        child: InteractiveViewer(
          boundaryMargin: EdgeInsets.zero,
          constrained: true,
          alignPanAxis: true,
          child: Hero(
            tag: meal.id.toString(),
            child: InteractiveViewer(
              child: Image.network(
                meal.imageUrl.toString(),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding TextBuilder(String text, BuildContext ctx, bool island, double hei) {
    return Padding(
        padding: EdgeInsets.all(island ? hei * 0.02 : hei * 0.02),
        child: Text(text,
            style: Theme.of(ctx).textTheme.headline6,
            textAlign: TextAlign.center));
  }

  Container contentBuilder(
      String str, BuildContext ctx, double wid, double hei, bool island) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      width: island ? wid * 0.40 : wid * 0.75,
      height: island ? hei * 0.50 : hei * 0.35,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey,
          style: BorderStyle.solid,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: str == "ingredients"
            ? meal.ingredients!.length
            : meal.steps!.length,
        itemBuilder: (ctx, index) => ListTile(
          leading: CircleAvatar(
            child: Text(
              "${index + 1}",
              style: Theme.of(ctx).textTheme.headline6,
            ),
            backgroundColor: Colors.blue.withOpacity(0.4),
          ),
          title: Text(
            str == "ingredients"
                ? "${meal.ingredients![index]}"
                : "${meal.steps![index]}",
            style: Theme.of(ctx).textTheme.headline6,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    var hei = MediaQuery.of(context).size.height;
    bool islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //AppBar
          SliverAppBar(
            expandedHeight: islandscape ? hei * 0.60 : hei * 0.25,
            pinned: true, // ثابت
            flexibleSpace: FlexibleSpaceBar(
              title: Text(meal.title.toString()),
              background: ImageBuilder(islandscape, hei),
            ),
          ),

          //Body
          SliverList(
              delegate: SliverChildListDelegate([
            islandscape
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              TextBuilder(
                                  "ingredients", context, islandscape, hei),
                              contentBuilder("ingredients", context, wid, hei,
                                  islandscape),
                            ],
                          ),
                          Column(
                            children: [
                              TextBuilder("Steps", context, islandscape, hei),
                              contentBuilder(
                                  "Steps", context, wid, hei, islandscape),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(height: 10),
                      TextBuilder("ingredients", context, islandscape, hei),
                      contentBuilder(
                          "ingredients", context, wid, hei, islandscape),
                      TextBuilder("Steps", context, islandscape, hei),
                      contentBuilder("Steps", context, wid, hei, islandscape),
                      SizedBox(height: 15),
                    ],
                  ),
          ])),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        foregroundColor:
            Theme.of(context).floatingActionButtonTheme.foregroundColor,
        onPressed: () {
          Provider.of<MealProvider>(context, listen: false)
              .makeItemFavorite(id, context);
        },
        child: Selector<MealProvider, bool>(
            selector: (ctx, value) =>
                Provider.of<MealProvider>(ctx, listen: true).favIcon(id),
            builder: (ctx2, result, child) {
              if (result) {
                return Icon(Icons.star);
              } else {
                return Icon(Icons.star_outline);
              }
            }),
      ),
    );
  }
}
