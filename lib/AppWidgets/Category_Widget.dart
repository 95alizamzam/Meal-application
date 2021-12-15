import 'package:flutter/material.dart';
import 'package:meal_application/AppProvider/MealProvider.dart';
import 'package:meal_application/AppScreens/MealScreen.dart';
import 'package:meal_application/Modals/Category_Modal.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Category_Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List AvailableCategories =
        Provider.of<MealProvider>(context, listen: false).getavailableCat();

    return Container(
      margin: EdgeInsets.all(10),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisExtent: 110,
            mainAxisSpacing: 20,
          ),
          itemCount: AvailableCategories.length,
          itemBuilder: (ctx, index) {
            return InkWell(
              borderRadius: BorderRadius.circular(25),
              highlightColor: AvailableCategories[index].clr,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AvailableCategories[index].clr!,
                      AvailableCategories[index].clr!.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  AvailableCategories[index].title.toString(),
                  style: Theme.of(context).textTheme.headline6,
                  maxLines: 1,
                  softWrap: false,
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: MealScreen(
                      AvailableCategories[index].id.toString(),
                      AvailableCategories[index].title.toString(),
                    ),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 200),
                  ),
                );
              },
            );
          }),
    );
  }
}
