import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/views/screens/warung/search_product.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  SearchWidget({this.hintText});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchProductPage(typeProduct: "commerce"))),
      child: Container(
        height: 55.0,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          color: ColorResources.LAVENDER,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(width: 200.0, 
              child: Text(hintText, 
                style: titilliumRegular.copyWith(
                  color: ColorResources.BLACK 
                ),
                overflow: TextOverflow.ellipsis
              )
            ),
            Icon(
              Icons.search,
              color: ColorResources.PRIMARY,
            ),
          ], 
        ),
      ),
    );
  }
}
