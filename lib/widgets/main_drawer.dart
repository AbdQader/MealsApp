import 'package:flutter/material.dart';
import '../screens/filters_screen.dart';

class MainDrawer extends StatelessWidget {

  Widget buildListTile(String title, IconData icon, Function mFun) {
    return ListTile(
      onTap: mFun,
      leading: Icon(icon, size: 26),
      title: Text(
        title, 
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: 120,
            color: Theme.of(context).accentColor,
            child: Text(
              'Cooking Up!',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(height: 20),
          buildListTile(
            'Meal', 
            Icons.restaurant, 
            () { Navigator.of(context).pushReplacementNamed('/'); }
          ),
          buildListTile(
            'Filters', 
            Icons.settings, 
            () { Navigator.of(context).pushReplacementNamed(FiltersScreen.routName);}
          ),
        ],
      ),
    );
  }
}