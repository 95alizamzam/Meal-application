import 'package:flutter/material.dart';
import 'package:meal_application/AppProvider/MealProvider.dart';
import 'package:meal_application/AppScreens/Category_Screen.dart';
import 'package:meal_application/AppWidgets/Meal_Widget.dart';
import 'package:meal_application/Modals/Meal_Modal.dart';
import 'package:provider/provider.dart';

class MealScreen extends StatelessWidget {
  final String id;
  final String title;

  MealScreen(this.id, this.title);
  @override
  Widget build(BuildContext context) {
    bool islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var wid = MediaQuery.of(context).size.width;
    var hei = MediaQuery.of(context).size.height;

    Provider.of<MealProvider>(context, listen: false).showMeal(id);
    List<Meal> myMeals =
        Provider.of<MealProvider>(context, listen: true).mealList;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) {
            return CategoryScreen();
          },
        ));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: islandscape
            ? GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: wid <= 400 ? 400 : 500,
                  //childAspectRatio: width for item / Height for item,
                  childAspectRatio:
                      islandscape ? wid / (wid * 0.6016) : wid / (wid * 0.8316),
                ),
                itemCount: myMeals.length,
                itemBuilder: (ctx, index) {
                  return mealWidget(
                    id: myMeals[index].id,
                    title: myMeals[index].title,
                    img: myMeals[index].imageUrl,
                    duration: myMeals[index].duration,
                    affordabilityVariable: myMeals[index].affordabilityVariable,
                    complexityVariable: myMeals[index].complexityVariable,
                    mylist: myMeals,
                  );
                },
              )
            : ListView.builder(
                itemCount: myMeals.length,
                itemBuilder: (ctx, index) {
                  return mealWidget(
                    id: myMeals[index].id,
                    title: myMeals[index].title,
                    img: myMeals[index].imageUrl,
                    duration: myMeals[index].duration,
                    affordabilityVariable: myMeals[index].affordabilityVariable,
                    complexityVariable: myMeals[index].complexityVariable,
                    mylist: myMeals,
                  );
                },
              ),
      ),
    );
  }
}
