import 'package:flutter/material.dart';
import 'package:meal_application/AppData/dummy_data.dart';
import 'package:meal_application/AppScreens/FavoriteScreen.dart';
import 'package:meal_application/Modals/Category_Modal.dart';
import 'package:meal_application/Modals/Meal_Modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class MealProvider with ChangeNotifier {
  List<Meal> mealList = DUMMY_MEALS;
  List<Meal> FavList = [];
  List<Meal> FilteredList = DUMMY_MEALS;
  List<String> sharedMealId = [];
  var mealDetails;
  int index = 0;
  bool? isSwitched = false;
  ThemeMode tm = ThemeMode.system;
  String mood = "";
  String? radioval;
  List<Category> availableCategory = [];

  bool? isGlutenFree;
  bool? isVegan;
  bool? isVegetarian;
  bool? isLactoseFree;

  String getAffordability(int index, List li) {
    final temp = li[index].affordabilityVariable;
    if (temp == Affordability.Affordable) {
      return "Affordable";
    } else if (temp == Affordability.Luxurious) {
      return "Luxurious";
    } else if (temp == Affordability.Pricey) {
      return "Pricey";
    }
    return "";
  }

  String getComplex(int index, List li) {
    final temp = li[index].complexityVariable;
    if (temp == Complexity.Challenging) {
      return "Challenging";
    } else if (temp == Complexity.Hard) {
      return "Hard";
    } else if (temp == Complexity.Simple) {
      return "Simple";
    }
    return "";
  }

  showMeal(String id) {
    mealList = FilteredList.where((element) => element.categories!.contains(id))
        .toList();
  }

  showMealDetails(String id, List<Meal> li, BuildContext ctx) {
    try {
      mealDetails = li.firstWhere((element) => element.id == id);
      return mealDetails;
    } catch (e) {
      throw e;
    }
  }

  changeIndex(int newIndex) {
    index = newIndex;
    notifyListeners();
  }

  makeItemFavorite(String id, BuildContext ctx) async {
    var isExist = FavList.indexWhere((element) => element.id == id);
    if (isExist >= 0) {
      FavList.removeAt(isExist);
      sharedMealId.remove(id);
      Toast.show("Unfavorit Item", ctx, duration: 2);
    } else {
      var item = DUMMY_MEALS.firstWhere((element) => element.id == id);
      FavList.add(item);
      sharedMealId.add(id);
      Toast.show("Favorit item", ctx, duration: 2);
    }

    notifyListeners();

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList("sharedMealId", sharedMealId);
  }

  bool favIcon(String id) {
    if (FavList.any((element) => element.id == id)) {
      return true;
    } else {
      return false;
    }
  }

  setFilters(bool newValue, index) async {
    if (index == 0) {
      isGlutenFree = newValue;
    } else if (index == 1) {
      isVegan = newValue;
    } else if (index == 2) {
      isVegetarian = newValue;
    } else {
      isLactoseFree = newValue;
    }
    updateMeals();

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool("isGlutenFree", isGlutenFree!);
    _prefs.setBool("isVegan", isVegan!);
    _prefs.setBool("isVegetarian", isVegetarian!);
    _prefs.setBool("isLactoseFree", isLactoseFree!);
  }

  updateMeals() {
    FilteredList = DUMMY_MEALS.where(
      (meal) {
        if (isGlutenFree! && !meal.isGlutenFree!) {
          return false;
        }
        if (isLactoseFree! && !meal.isLactoseFree!) {
          return false;
        }
        if (isVegan! && !meal.isVegan!) {
          return false;
        }
        if (isVegetarian! && !meal.isVegetarian!) {
          return false;
        }
        return true;
      },
    ).toList();

    List<Category> temp = [];
    FilteredList.forEach((meal) {
      meal.categories!.forEach((catId) {
        DUMMY_CATEGORIES.forEach((cat) {
          if (catId == cat.id) {
            if (!temp.any((element) => element.id == catId)) {
              temp.add(cat);
            }
          }
        });
      });
    });
    availableCategory = temp;

    notifyListeners();
  }

  getAppFilters() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    isGlutenFree = _prefs.getBool("isGlutenFree") ?? false;
    isVegan = _prefs.getBool("isVegan") ?? false;
    isVegetarian = _prefs.getBool("isVegetarian") ?? false;
    isLactoseFree = _prefs.getBool("isLactoseFree") ?? false;

    updateMeals();
  }

  Future<void> getprefFavorite() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    sharedMealId = _prefs.getStringList("sharedMealId") ?? [];
    if (sharedMealId == []) {
      FavList = [];
    } else {
      sharedMealId.forEach((mealId) {
        if (FavList.indexWhere((element) => element.id == mealId) < 0) {
          FavList.add(
              DUMMY_MEALS.firstWhere((element) => element.id == mealId));
        }
      });
    }

    notifyListeners();
  }

  changedarkmood(bool newVal) {
    isSwitched = newVal;
    notifyListeners();
  }

  List<Meal> getfavList() {
    List<Meal> temp = [];
    FilteredList.forEach((filteredelement) {
      FavList.forEach((favelement) {
        if (filteredelement.id == favelement.id) {
          temp.add(favelement);
        }
      });
    });
    FavList = temp;

    return FavList;
  }

  int getindex() {
    return index;
  }

  bool getswitchVal() {
    return isSwitched!;
  }

  getthememood() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    radioval = _prefs.getString("radioVal") ?? "System";
    String m = _prefs.getString("mood") ?? "s";
    if (m == "s") {
      tm = ThemeMode.system;
    } else if (m == "d") {
      tm = ThemeMode.dark;
    } else if (m == "l") {
      tm = ThemeMode.light;
    }

    notifyListeners();
  }

  changeThemeMood(ThemeMode newtm, String radioval) async {
    tm = newtm;

    if (newtm == ThemeMode.system) {
      mood = "s";
      radioval = "System";
    } else if (newtm == ThemeMode.dark) {
      mood = "d";
      radioval = "Dark";
    } else if (newtm == ThemeMode.light) {
      mood = "l";
      radioval = "Light";
    }
    notifyListeners();

    SharedPreferences _prfes = await SharedPreferences.getInstance();
    _prfes.setString("mood", mood);
    _prfes.setString("radioVal", radioval);
  }

/*
 void changeColor(Color clr, String txt) {
    if (txt == "prim") {
      primary = _setColor(clr.hashCode);
    } else if (txt == "acc") {
      accent = _setColor(clr.hashCode);
    }

    notifyListeners();
  }

  MaterialColor _setColor(color) {
    return MaterialColor(
      color,
      <int, Color>{
        50: Color(0xFFFAFAFA),
        100: Color(0xFFF5F5F5),
        200: Color(0xFFEEEEEE),
        300: Color(0xFFE0E0E0),
        350: Color(
            0xFFD6D6D6), // only for raised button while pressed in light theme
        400: Color(0xFFBDBDBD),
        500: Color(color),
        600: Color(0xFF757575),
        700: Color(0xFF616161),
        800: Color(0xFF424242),
        850: Color(0xFF303030), // only for background color in dark theme
        900: Color(0xFF212121),
      },
    );
    */

  List<Category> getavailableCat() {
    return availableCategory;
  }

  EnabledOnboarderScreen() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool("watched", true);
  }
}
