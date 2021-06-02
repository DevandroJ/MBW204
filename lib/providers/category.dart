import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/data/models/category.dart';
import 'package:mbw204_club_ina/data/repository/category.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;

  CategoryProvider({@required this.categoryRepo});

  List<Category> _categoryList = [];
  int _categorySelectedIndex;

  List<Category> get categoryList => _categoryList;

  int get categorySelectedIndex => _categorySelectedIndex;

  void initCategoryList(BuildContext context) async {
    _categoryList = [];
    categoryRepo.getCategoryList(context).forEach((category) => _categoryList.add(category));
    _categorySelectedIndex = 0;
    Future.delayed(Duration.zero,() => notifyListeners());    
  }

  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }
}
