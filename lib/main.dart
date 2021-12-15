import 'package:flutter/material.dart';
import 'package:meal_application/AppProvider/MealProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AppScreens/Category_Screen.dart';
import 'AppScreens/OnboardingScreen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  bool watched = _prefs.getBool("watched") ?? false;
  Widget MainScreen = (!watched) ? onboardingScreen() : CategoryScreen();

  runApp(
    ChangeNotifierProvider<MealProvider>(
      create: (_) => MealProvider(),
      child: MyApp(MainScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget goal;
  MyApp(this.goal);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Meal Application",
      themeMode: Provider.of<MealProvider>(context, listen: true).tm,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.white54,
        canvasColor: Colors.white,
        cardColor: Colors.white,
        buttonColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 5,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              headline4: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              bodyText1: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              bodyText2: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 20,
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.grey,
        canvasColor: Colors.white10,
        cardColor: Colors.black,
        buttonColor: Colors.black,
        unselectedWidgetColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[600],
          elevation: 5,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: false,
        ),
        textTheme: ThemeData.dark().textTheme.copyWith(
              headline6: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              headline4: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              bodyText1: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              bodyText2: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: goal,
      routes: {
        CategoryScreen.routeName: (context) => CategoryScreen(),
      },
    );
  }
}
