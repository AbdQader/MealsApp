import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../models/meal.dart';
import '../dummy_data.dart';

class MealProvider with ChangeNotifier {

  Map<String, bool> filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Meal> availableMeals = DUMMY_MEALS;
  List<Meal> favoriteMeals = [];
  
  List<String> favoriteMealsIds = [];

  List<Category> availableCategory = [];

  void setFilters() async {
      availableMeals = DUMMY_MEALS.where((meal) {
        if (filters['gluten'] && !meal.isGlutenFree) {
          return false;
        }
        if (filters['lactose'] && !meal.isLactoseFree) {
          return false;
        }
        if (filters['vegan'] && !meal.isVegan) {
          return false;
        }
        if (filters['vegetarian'] && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
      
      List<Category> ac = [];
      availableMeals.forEach((meal) {
        meal.categories.forEach((cateId) {
          DUMMY_CATEGORIES.forEach((cate) {
            if (cate.id == cateId) {
              if (!ac.any((cate) => cate.id == cateId)) ac.add(cate);
              // OR => if (!ac.contains(cate)) ac.add(cate);
            }
          });
        });
      });
      availableCategory = ac;

      notifyListeners();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('gluten', filters['gluten']);
      prefs.setBool('lactose', filters['lactose']);
      prefs.setBool('vegan', filters['vegan']);
      prefs.setBool('vegetarian', filters['vegetarian']);

  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    filters['gluten'] = prefs.getBool('gluten') ?? false;
    filters['lactose'] = prefs.getBool('lactose') ?? false;
    filters['vegan'] = prefs.getBool('vegan') ?? false;
    filters['vegetarian'] = prefs.getBool('vegetarian') ?? false;
    setFilters();

    List<String> favoriteMealsIds = prefs.getStringList('favoriteMealsIds');
    favoriteMealsIds.forEach((mealId) {
      final existingIndex = favoriteMeals.indexWhere((meal) => meal.id == mealId);
      if (existingIndex < 0) {
        favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      }
    });
    
    List<Meal> fm = [];
    favoriteMeals.forEach((favMeals) {
      availableMeals.forEach((avMeals) {
        if(favMeals.id == avMeals.id) fm.add(favMeals);
      });
    });
    favoriteMeals = fm;
    
    notifyListeners();
  }

  void toggleFavorite(String mealId) async {
    final existingIndex = favoriteMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      favoriteMeals.removeAt(existingIndex);
      favoriteMealsIds.remove(mealId);
    } else {
      favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      favoriteMealsIds.add(mealId);
    }

    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteMealsIds', favoriteMealsIds);
  }

  bool isMealFavorite(String mealId) {
    return favoriteMeals.any((meal) => meal.id == mealId);
  }

}