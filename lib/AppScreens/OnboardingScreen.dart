import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:meal_application/AppProvider/MealProvider.dart';
import 'package:meal_application/AppScreens/Category_Screen.dart';
import 'package:meal_application/AppScreens/FiltersScreen.dart';
import 'package:meal_application/AppScreens/ThemeScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class onboardingScreen extends StatefulWidget {
  @override
  _onboardingScreenState createState() => _onboardingScreenState();
}

class _onboardingScreenState extends State<onboardingScreen> {
  int currentIndex = 0;
  Container Buildcontainer(Color clr, int ind, IconData ico) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(),
      child: ind == currentIndex
          ? Icon(
              Icons.star,
              color: ind == currentIndex ? Colors.yellow : clr,
            )
          : Icon(
              Icons.circle,
              color: clr,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    bool islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    ThemeMode tm = Provider.of<MealProvider>(context, listen: true).tm;
    Provider.of<MealProvider>(context, listen: false).getAppFilters();
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (ctx) {
              return buildAlert(ctx);
            });
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              children: [
                Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage("assets/images/x.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 0),
                    child: Container(
                      width: 250,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.withOpacity(0.8),
                            Colors.white.withOpacity(0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Meal",
                              style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontSize: 25,
                              ),
                            ),
                            TextSpan(
                              text: " App",
                              style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
                ThemeScreen(true),
                FiltersScreen(true),
              ],
              onPageChanged: (newVal) {
                setState(() => currentIndex = newVal);
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: islandscape ? 15 : 0),
              child: Align(
                alignment: Alignment(0, 0.8),
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(CategoryScreen.routeName);
                        Provider.of<MealProvider>(context, listen: false)
                            .EnabledOnboarderScreen();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).iconTheme.color,
                        ),
                      ),
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: Theme.of(context).iconTheme.size,
                        ),
                      )),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.92),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Buildcontainer(
                      tm == ThemeMode.dark ? Colors.white : Colors.black,
                      0,
                      Icons.star),
                  Buildcontainer(
                      tm == ThemeMode.dark ? Colors.white : Colors.black,
                      1,
                      Icons.star),
                  Buildcontainer(
                      tm == ThemeMode.dark ? Colors.white : Colors.black,
                      2,
                      Icons.star),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
