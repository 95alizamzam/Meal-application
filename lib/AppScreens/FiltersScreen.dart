import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meal_application/AppProvider/MealProvider.dart';
import 'package:meal_application/AppScreens/Category_Screen.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class FiltersScreen extends StatelessWidget {
  bool fromboard = false;
  FiltersScreen(this.fromboard);
  Widget filtersBuilder(
      bool value, String title, BuildContext ctx, int index, String subTit) {
    return SwitchListTile(
      value: value,
      onChanged: (newVal) {
        Provider.of<MealProvider>(ctx, listen: false).setFilters(newVal, index);
        Toast.show("Your Meals Updated", ctx, duration: 3);
      },
      title: Text(title, style: Theme.of(ctx).textTheme.headline6),
      subtitle: Text(
        subTit,
        style: Theme.of(ctx).textTheme.headline4,
      ),
      activeColor: Colors.lightGreen,
      inactiveThumbColor:
          Theme.of(ctx).floatingActionButtonTheme.backgroundColor,
      inactiveTrackColor:
          Theme.of(ctx).floatingActionButtonTheme.backgroundColor,
      secondary: CircleAvatar(
        child: Text(
          "${index + 1}",
          style: TextStyle(
            color: Theme.of(ctx).primaryColor,
          ),
        ),
        backgroundColor:
            Theme.of(ctx).floatingActionButtonTheme.backgroundColor,
        foregroundColor:
            Theme.of(ctx).floatingActionButtonTheme.foregroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isGlutenFree =
        Provider.of<MealProvider>(context, listen: true).isGlutenFree!;
    bool isVegan = Provider.of<MealProvider>(context, listen: true).isVegan!;
    bool isVegetarian =
        Provider.of<MealProvider>(context, listen: true).isVegetarian!;
    bool isLactoseFree =
        Provider.of<MealProvider>(context, listen: true).isLactoseFree!;

    bool islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var hei = MediaQuery.of(context).size.height;

    AlertDialog buildAlert(BuildContext ctx) {
      return AlertDialog(
        backgroundColor: Theme.of(ctx).primaryColor,
        title: Text("Do you Want Exit ?!",
            style: TextStyle(
              color: Theme.of(context).iconTheme.color,
            )),
        content: Container(
          height: 1,
          color: Theme.of(ctx).iconTheme.color,
          child: Divider(
            color: Theme.of(ctx).primaryColor,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                child: Text("Ok"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
              SizedBox(width: 5),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Cancel")),
            ],
          )
        ],
      );
    }

    return WillPopScope(
        onWillPop: () async {
          fromboard
              ? showDialog(
                  context: context,
                  builder: (ctx) {
                    return buildAlert(ctx);
                  })
              : Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) {
                    return CategoryScreen();
                  },
                ));
          return true;
        },
        child: Scaffold(
            //عند وجود مساحة كافية لايختفي الابار
            //عندما تضيق المساحة يحتفي
            body: CustomScrollView(slivers: [
          SliverAppBar(
            pinned: false,
            title: fromboard ? null : Text("Your Filters"),
            backgroundColor: fromboard
                ? Theme.of(context).canvasColor.withOpacity(0)
                : Theme.of(context).primaryColor,
            elevation: fromboard ? 0 : 5,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: islandscape ? hei * 0.03 : 20),
                Container(
                  margin: EdgeInsets.all(islandscape ? 0 : 10),
                  padding: EdgeInsets.all(islandscape ? 0 : 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Text(
                    "Select Your Filters as You like :",
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: islandscape ? hei * 0.05 : 30),
                filtersBuilder(isGlutenFree, "Gluten-Free", context, 0,
                    "Meals without Gluten "),
                filtersBuilder(
                    isVegan, "Vegan-Free", context, 1, "Only Vegan Meals"),
                filtersBuilder(isVegetarian, "Vegetarian-Free", context, 2,
                    "Only Vegetarian Meals"),
                filtersBuilder(isLactoseFree, "Lactose-Free", context, 3,
                    "Meals without Lactose"),
                SizedBox(height: hei * 0.23)
              ],
            ),
          ),
        ])));
  }
}
