import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meal_application/AppProvider/MealProvider.dart';
import 'package:meal_application/AppScreens/ThemeScreen.dart';
import 'package:meal_application/AppWidgets/Category_Widget.dart';
import 'package:meal_application/AppWidgets/bottomBarWidget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:residemenu/residemenu.dart';
import 'FavoriteScreen.dart';
import 'FiltersScreen.dart';

class CategoryScreen extends StatefulWidget {
  static String routeName = "/CatScreen";
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  MenuController? _menuController;
  int? ind;

  var DropButtonVal;

  ThemeMode? mytm;

  @override
  void initState() {
    super.initState();
    _menuController = MenuController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    Provider.of<MealProvider>(context, listen: false).getAppFilters();

    Provider.of<MealProvider>(context, listen: false).getthememood();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //willPopScope Alert Dialog
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

    Container TitleBuilder() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).iconTheme.color,
              radius: 22,
              child: Icon(
                Icons.restaurant_menu,
                size: Theme.of(context).iconTheme.size,
                color: Theme.of(context).buttonColor,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Meal",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    TextSpan(
                      text: " App",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    ListTile listTileBuilder(IconData ico, String title, Widget Goalchild) {
      return ListTile(
        leading: Icon(
          ico,
          size: Theme.of(context).iconTheme.size,
          color: Theme.of(context).iconTheme.color,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        onTap: () {
          Navigator.of(context).pushReplacement(PageTransition(
            child: Goalchild,
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 300),
          ));
        },
      );
    }

    DropdownMenuItem BuildMenuItem(String val, IconData ico, Color iconColor) {
      return DropdownMenuItem<dynamic>(
        value: val,
        child: TextButton.icon(
          onPressed: () {
            Provider.of<MealProvider>(context, listen: false).changeThemeMood(
                val == "Light" ? ThemeMode.light : ThemeMode.dark,
                val == "Light" ? "Light" : "Dark");
          },
          icon: Icon(
            ico,
            color: iconColor == Colors.yellow
                ? Colors.yellow
                : (mytm == ThemeMode.dark)
                    ? Colors.white
                    : Colors.black,
          ),
          label: Text(
            val == "Light" ? "Light Mood" : "Dark Mood",
            style: TextStyle(
                color: mytm == ThemeMode.dark ? Colors.white : Colors.black),
          ),
        ),
      );
    }

    mytm = Provider.of<MealProvider>(context, listen: false).tm;

    bool islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    List<Map<String, dynamic>> pages = [
      {
        "appBar": " Your Available Meal ",
        "body": Category_Widget(),
      },
      {
        "appBar": "Your Favorite Meals",
        "body": FavScreen(),
      },
    ];
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (ctx) {
              return buildAlert(ctx);
            });
        return true;
      },
      child: new Material(
        child: ResideMenu.scaffold(
          child: Selector<MealProvider, int>(
            selector: (ctx, tool) => tool.getindex(),
            builder: (bctx, val, _) => Scaffold(
              appBar: AppBar(
                title: Text(pages[val]["appBar"]),
                leading: InkWell(
                  child: Icon(Icons.menu),
                  onTap: () => _menuController!.openMenu(true),
                ),
              ),
              body: pages[val]["body"],
              bottomNavigationBar: bottomBar(),
            ),
          ),
          controller: _menuController,
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
          leftScaffold: MenuScaffold(
            topMargin: islandscape ? 20 : 40,
            itemExtent: islandscape ? 50 : 70,
            children: [
              TitleBuilder(),
              listTileBuilder(Icons.fastfood, "Your Meals", CategoryScreen()),
              listTileBuilder(
                  Icons.settings, "Your Filters", FiltersScreen(false)),
              listTileBuilder(
                  Icons.color_lens, "App Theme", ThemeScreen(false)),
              Container(
                  margin: EdgeInsets.only(left: 18),
                  child: Row(
                    children: [
                      Icon(
                        Icons.light_mode,
                        color: Theme.of(context).iconTheme.color,
                        size: Theme.of(context).iconTheme.size,
                      ),
                      SizedBox(width: 30),
                      DropdownButton<dynamic>(
                        underline: Container(),
                        elevation: 0,
                        hint: Text(
                          "Select Your App Mood :",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        onChanged: (newVal) {
                          setState(() {
                            DropButtonVal = newVal.toString();
                          });
                        },
                        items: [
                          BuildMenuItem(
                              "Light", Icons.light_mode, Colors.yellow),
                          BuildMenuItem("Dark", Icons.dark_mode, Colors.white),
                        ],
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                          color: mytm == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        dropdownColor: mytm == ThemeMode.dark
                            ? Colors.black
                            : Colors.white,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
