import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meal_application/AppProvider/MealProvider.dart';
import 'package:meal_application/AppScreens/Category_Screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ThemeScreen extends StatefulWidget {
  bool fromBoardingScreen = false;
  ThemeScreen(this.fromBoardingScreen);
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  Widget buildRadio(String val, String tit, BuildContext ctx, IconData ico,
      Color clr, double h) {
    String? groupval = Provider.of<MealProvider>(ctx, listen: false).radioval;
    return Container(
      height: h,
      child: RadioListTile(
        value: val,
        groupValue: groupval,
        title: Text(tit),
        secondary: Icon(
          ico,
          color: clr,
          size: Theme.of(ctx).iconTheme.size,
        ),
        onChanged: (newval) {
          setState(
            () {
              groupval = newval.toString();
              if (val == "System") {
                Provider.of<MealProvider>(ctx, listen: false)
                    .changeThemeMood(ThemeMode.system, val);
              } else if (val == "Light") {
                Provider.of<MealProvider>(ctx, listen: false)
                    .changeThemeMood(ThemeMode.light, val);
              } else {
                Provider.of<MealProvider>(ctx, listen: false)
                    .changeThemeMood(ThemeMode.dark, val);
              }
            },
          );
        },
        activeColor: Colors.red,
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
    var hei = MediaQuery.of(context).size.height;
    Provider.of<MealProvider>(context, listen: false).getthememood();
    return WillPopScope(
      onWillPop: () async {
        widget.fromBoardingScreen
            ? showDialog(
                context: context,
                builder: (_) {
                  return buildAlert(context);
                })
            : Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) {
                  return CategoryScreen();
                },
              ));
        return true;
      },
      child: Scaffold(
          body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            title: widget.fromBoardingScreen ? null : Text("Your Theme"),
            backgroundColor: widget.fromBoardingScreen
                ? Theme.of(context).canvasColor.withOpacity(0)
                : Theme.of(context).primaryColor,
            elevation: widget.fromBoardingScreen ? 0 : 5,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              height: !islandscape ? hei * 0.05 : hei * 0.05,
              margin: EdgeInsets.only(top: islandscape ? hei * 0.02 : 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
              ),
              child: Text(
                "Select Your Theme as You like :",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
            buildRadio(
              "System",
              "Default System Mood",
              context,
              Icons.settings,
              Colors.grey,
              !islandscape ? hei * 0.08 : hei * 0.12,
            ),
            buildRadio(
              "Light",
              "Light Mood",
              context,
              Icons.light_mode,
              Colors.yellow,
              !islandscape ? hei * 0.08 : hei * 0.12,
            ),
            buildRadio(
              "Dark",
              "Dark Mood",
              context,
              Icons.dark_mode,
              Colors.black87,
              !islandscape ? hei * 0.08 : hei * 0.12,
            ),
            SizedBox(height: hei * 0.02),
            // Container(
            //   height: hei * 0.05,
            //   child: ListTile(
            //     title: Text(
            //       "Choose Your Primary Color :",
            //       style: Theme.of(context).textTheme.headline4,
            //     ),
            //     trailing: CircleAvatar(
            //       backgroundColor: Theme.of(context).iconTheme.color,
            //       radius: 30,
            //     ),
            //     onTap: () {
            //       showDialog(
            //           context: context,
            //           builder: (_) {
            //             return AlertDialog(
            //               title: Text("Choose your Color :"),
            //               content: Container(
            //                 child: SingleChildScrollView(
            //                   child: Column(
            //                     mainAxisSize: MainAxisSize.max,
            //                     children: [
            //                       Divider(color: Colors.red),
            //                       SingleChildScrollView(
            //                         child: MaterialPicker(
            //                           pickerColor: Colors.amber,
            //                           enableLabel: true,
            //                           onColorChanged: (newColor) {},
            //                         ),
            //                       ),
            //                       Builder(
            //                         builder: (innerctx) => ElevatedButton(
            //                           onPressed: () {
            //                             Navigator.of(innerctx).pop();
            //                           },
            //                           child: Text("Close"),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             );
            //             ;
            //           });
            //     },
            //   ),
            // ),
            // SizedBox(height: hei * 0.03),
            // Container(
            //   height: hei * 0.05,
            //   child: ListTile(
            //     title: Text("Choose Your accent Color :",
            //         style: Theme.of(context).textTheme.headline4),
            //     trailing: CircleAvatar(
            //       backgroundColor: Theme.of(context).iconTheme.color,
            //       radius: 30,
            //     ),
            //     onTap: () {
            //       showDialog(
            //         context: context,
            //         builder: (_) => AlertDialog(
            //           title: Text("Choose your Color :"),
            //           content: Container(
            //             child: SingleChildScrollView(
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   Divider(color: Colors.red),
            //                   SingleChildScrollView(
            //                     child: ColorPicker(
            //                       showLabel: true,
            //                       enableAlpha: true,
            //                       pickerAreaBorderRadius:
            //                           BorderRadius.circular(15.0),
            //                       paletteType: PaletteType.hsv,
            //                       pickerColor: Colors.red,
            //                       portraitOnly: true,
            //                       displayThumbColor: true,
            //                       pickerAreaHeightPercent: 1.0,
            //                       onColorChanged: (newColor) {},
            //                     ),
            //                   ),
            //                   Builder(
            //                     builder: (innerctx) => ElevatedButton(
            //                       onPressed: () {
            //                         Navigator.of(innerctx).pop();
            //                       },
            //                       child: Text("Close"),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // if (islandscape) SizedBox(height: 130),
          ]))
        ],
      )),
    );
  }
}
