import 'package:flutter/material.dart';
import '../providers/language_provider.dart';
import '../providers/meal_provider.dart';
import '../dummy_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class MealDetailScreen extends StatelessWidget {

  static const routeName = 'meal_detail';

  Widget buildSectionTitle(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: Theme.of(context).textTheme.headline6),
    );
  }

  Widget buildContainer(BuildContext context, Widget child) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    var dw = MediaQuery.of(context).size.width;
    var dh = MediaQuery.of(context).size.height;
    return Container(
      height: isLandscape ? dh*0.5 : dh*0.25,
      width: isLandscape ? (dw*0.5-30) : dw,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10), 
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final mealId = ModalRoute.of(context).settings.arguments as String;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);
    
    var accentColor = Theme.of(context).accentColor;
    var lan = Provider.of<LanguageProvider>(context, listen: true);

    List<String> lngredientLi = lan.getTexts('ingredients-$mealId') as List<String>;
    var lvIngredients = ListView.builder(
      itemBuilder: (context, index) => Card(
        color: accentColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            lngredientLi[index],
            style: TextStyle(
              color: useWhiteForeground(accentColor)
                ? Colors.white
                : Colors.black
            ),
          ),
        ),
      ),
      itemCount: lngredientLi.length,
    );
    List<String> stepsLi = lan.getTexts('steps-$mealId') as List<String>;
    var lvSteps = ListView.builder(
      itemBuilder: (context, index) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text('# ${index + 1}',),
            ),
            title: Text(
              stepsLi[index],
              style: TextStyle(color: Colors.black),
            ),
          ),
          Divider(color: stepsLi[index] != stepsLi.last ? Colors.black : null),
        ],
      ),
      itemCount: stepsLi.length,
    );
    
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(lan.getTexts('meal-$mealId'))),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Hero(
                  tag: mealId,
                  child: Image.network(selectedMeal.imageUrl, fit: BoxFit.cover),
                ),
              ),
              
              if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      buildSectionTitle(context, lan.getTexts('Ingredients')),
                      buildContainer(context, lvIngredients),
                    ],
                  ),
                  Column(
                    children: [
                      buildSectionTitle(context, lan.getTexts('Steps')),
                      buildContainer(context, lvSteps),
                    ],
                  ),
                ],
              ),
              if (!isLandscape) buildSectionTitle(context, lan.getTexts('Ingredients')),
              if (!isLandscape) buildContainer(context, lvIngredients),
              if (!isLandscape) buildSectionTitle(context, lan.getTexts('Steps')),
              if (!isLandscape) buildContainer(context, lvSteps),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Provider.of<MealProvider>(context, listen: false).toggleFavorite(mealId),
          child: Icon(
            Provider.of<MealProvider>(context, listen: true).isMealFavorite(mealId)
              ? Icons.star 
              : Icons.star_border
          ),
        ),
      ),
    );
  }
}