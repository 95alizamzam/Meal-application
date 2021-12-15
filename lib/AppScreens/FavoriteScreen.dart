import 'package:flutter/material.dart';
import 'package:meal_application/AppProvider/MealProvider.dart';
import 'package:meal_application/AppWidgets/Meal_Widget.dart';
import 'package:meal_application/Modals/Meal_Modal.dart';

import 'package:provider/provider.dart';

class FavScreen extends StatefulWidget {
  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  List<Meal>? favoriteMeals;
  bool _isloading = true;
  @override
  void didChangeDependencies() {
    Provider.of<MealProvider>(context, listen: false)
        .getprefFavorite()
        .then((_) {
      setState(() {
        _isloading = false;
      });
    });
    favoriteMeals =
        Provider.of<MealProvider>(context, listen: true).getfavList();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    var wid = MediaQuery.of(context).size.width;
    return Scaffold(
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (favoriteMeals!.isEmpty)
                ? Center(
                    child: Text(
                      "There is No Favorite meal yet",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  )
                : (!islandscape)
                    ? ListView.builder(
                        itemCount: favoriteMeals!.length,
                        itemBuilder: (ctx, index) {
                          return mealWidget(
                            id: favoriteMeals![index].id,
                            img: favoriteMeals![index].imageUrl,
                            title: favoriteMeals![index].title,
                            duration: favoriteMeals![index].duration,
                            complexityVariable:
                                favoriteMeals![index].complexityVariable,
                            affordabilityVariable:
                                favoriteMeals![index].affordabilityVariable,
                            mylist: favoriteMeals!,
                          );
                        },
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: wid <= 400 ? 400 : 500,
                          //childAspectRatio: width for item / Height for item,
                          childAspectRatio: islandscape
                              ? wid / (wid * 0.6316)
                              : wid / (wid * 0.8316),
                        ),
                        itemCount: favoriteMeals!.length,
                        itemBuilder: (ctx, index) {
                          return mealWidget(
                            id: favoriteMeals![index].id,
                            title: favoriteMeals![index].title,
                            img: favoriteMeals![index].imageUrl,
                            duration: favoriteMeals![index].duration,
                            affordabilityVariable:
                                favoriteMeals![index].affordabilityVariable,
                            complexityVariable:
                                favoriteMeals![index].complexityVariable,
                            mylist: favoriteMeals!,
                          );
                        },
                      ));
  }
}
