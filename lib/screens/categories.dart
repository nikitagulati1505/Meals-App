import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/data/widget/category_grid_items.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/models/meal.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen(
      {super.key,
      required this.availableMeals});

  final List<Meal> availableMeals;
  void _selectedCategory(BuildContext context, Category category) {
    final filteredDummy = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredDummy,
                ),
      ),
    );
  }

  @override
  Widget build(context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      children: [
        for (final category in availableCategories)
          CategoryGriditem(
            category: category,
            onSelectCategory: () {
              _selectedCategory(context, category);
            },
          )
      ],
    );
  }
}
