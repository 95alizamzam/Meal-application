import 'package:flutter/material.dart';
import 'package:meal_application/AppProvider/MealProvider.dart';
import 'package:meal_application/AppScreens/FavoriteScreen.dart';
import 'package:meal_application/AppWidgets/Meal_Details_Widget.dart';
import 'package:meal_application/Modals/Meal_Modal.dart';
import 'package:provider/provider.dart';

class MealDetails extends StatefulWidget {
  final String id;
  final List<Meal> li;
  MealDetails(this.id, this.li);

  @override
  _MealDetailsState createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  @override
  bool? decision;
  Meal? myMeal;
  //فائدتها انه في كل مرة تتحدث الحالة سوف تتنفذ الدالة وتتحدث الليستات والعناصر بداخلها
  void didChangeDependencies() {
    super.didChangeDependencies();
    decision =
        Provider.of<MealProvider>(context, listen: false).favIcon(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    try {
      myMeal = Provider.of<MealProvider>(context, listen: false)
          .showMealDetails(widget.id, widget.li, context);
    } catch (e) {
      Navigator.of(context).pop();
    }
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return true;
        },
        child: Details_Widget(myMeal!, widget.id.toString()));
  }
}
