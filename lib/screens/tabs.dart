import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/data/widget/main_drawer.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/provider/means_provider.dart';
import 'package:meals_app/provider/favourites_provider.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

const kselectedfilter = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class _TabsScreenState extends ConsumerState<TabsScreen> {
  final List<Meal> _favouriteMeals = [];
  Map<Filter, bool> _selectedFilters = kselectedfilter;
  void _showinfomessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMealFavouriteStatus(Meal meal) {
    final isExisting = _favouriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favouriteMeals.remove(meal);
      });
      _showinfomessage('Meal is no longer favourite');
    } else {
      setState(() {
        _favouriteMeals.add(meal);
      });
      _showinfomessage('Meal is marked as favourite!');
    }
  }

  int _selectPageIndex = 0;
  void selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
            builder: (ctx) => FilterScreen(
                  currentFilters: _selectedFilters,
                )),
      );
      setState(() {
        _selectedFilters = result ?? kselectedfilter;
      });
    }
  }

  @override
  Widget build(context) {
    final meals = ref.watch(mealsProvider);
    final availableMeals = meals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activepageTitles = 'Categories';
    if (_selectPageIndex == 1) {
      final FavouriteMeals = ref.watch(FavouriteMealsProvider);
      activePage = MealsScreen(
        meals: FavouriteMeals,
      );
      activepageTitles = 'Your favourites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activepageTitles),
      ),
      drawer: MainDrawer(
        onSelectscreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        currentIndex: _selectPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'favourites'),
        ],
      ),
    );
  }
}
