import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/models/meal.dart';

class FavouriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavouriteMealsNotifier() : super([]);
  void ToggleFavouriteStatus(Meal meal) {
    final MealIsFavourite = state.contains(meal);
    if (MealIsFavourite) {
      state = state.where((m) => m.id != meal.id).toList();
    } else {
      state = [...state, meal];
    }
  }
}

final FavouriteMealsProvider =
    StateNotifierProvider<FavouriteMealsNotifier, List<Meal>>((ref) {
  return FavouriteMealsNotifier();
});
