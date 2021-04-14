import 'package:flutter/material.dart';
import '../providers/meal_provider.dart';
import '../widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class FiltersScreen extends StatelessWidget {

  static const routeName = '/filters';

  final bool fromOnBoarding;

  FiltersScreen({this.fromOnBoarding = false});

  Widget buildSwitchListTile(String title, String subtitle, bool currentValue, Function updateValue) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: currentValue,
      onChanged: updateValue,
      //inactiveTrackColor: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, bool> currentFilters = Provider.of<MealProvider>(context, listen: true).filters;
    return Scaffold(
      appBar: AppBar(title: Text('Your Filters'),),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Adjust your meal selection',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                buildSwitchListTile(
                  'Gluten-free', 
                  'Only include gluten-free meals', 
                  currentFilters['gluten'],
                  (newValue) {
                    currentFilters['gluten'] = newValue;
                    Provider.of<MealProvider>(context, listen: false).setFilters();
                  }
                ),
                buildSwitchListTile(
                  'Lactose-free', 
                  'Only include lactose-free meals', 
                  currentFilters['lactose'],
                  (newValue) {
                    currentFilters['lactose'] = newValue;
                    Provider.of<MealProvider>(context, listen: false).setFilters();
                  }
                ),
                buildSwitchListTile(
                  'Vegan', 
                  'Only include vegan meals', 
                  currentFilters['vegan'],
                  (newValue) {
                    currentFilters['vegan'] = newValue;
                    Provider.of<MealProvider>(context, listen: false).setFilters();
                  }
                ),
                buildSwitchListTile(
                  'Vegetarian', 
                  'Only include vegetarian meals', 
                  currentFilters['vegetarian'],
                  (newValue) {
                    currentFilters['vegetarian'] = newValue;
                    Provider.of<MealProvider>(context, listen: false).setFilters();
                  }
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
    );
  }
}