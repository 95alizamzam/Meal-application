import 'package:flutter/material.dart';

enum Affordability { Affordable, Pricey, Luxurious }

enum Complexity { Simple, Challenging, Hard }

class Meal {
  final String? id;
  final List<String>? categories;
  final String? title;
  final Affordability? affordabilityVariable;
  final Complexity? complexityVariable;
  final String? imageUrl;
  final int? duration;
  final List<String>? ingredients;
  final List<String>? steps;
  final bool? isGlutenFree;
  final bool? isVegan;
  final bool? isVegetarian;
  final bool? isLactoseFree;

  const Meal({
    @required this.id,
    @required this.categories,
    @required this.title,
    @required this.affordabilityVariable,
    @required this.complexityVariable,
    @required this.imageUrl,
    @required this.duration,
    @required this.ingredients,
    @required this.steps,
    @required this.isGlutenFree,
    @required this.isVegan,
    @required this.isVegetarian,
    @required this.isLactoseFree,
  });
}
