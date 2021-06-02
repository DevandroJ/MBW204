import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/data/models/category.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';

class CategoryRepo {
  List<Category> getCategoryList(BuildContext context) {
    List<Category> categoryList = [
      Category(id: 1, name: 'Forum', icon: 'assets/icons/ic-feed.png'),
      Category(id: 2, name: getTranslated("EVENT", context), icon: 'assets/icons/ic-event.png'),
      Category(id: 3, name: 'Media', icon: 'assets/icons/ic-media.png'),
      Category(id: 4, name: 'Check In', icon: 'assets/icons/ic-booking.png'),
      Category(id: 5, name: 'Info', icon: 'assets/icons/ic-info.png'),
      Category(id: 6, name: getTranslated("NEWS", context), icon: 'assets/icons/ic-news.png'),
      Category(id: 7, name: 'PPOB', icon: 'assets/icons/ic-ppob.png'),
      Category(id: 8, name: 'Indomini Mart', icon: 'assets/icons/ic-indomini-mart.png'),
    ];
    return categoryList;
  }
}