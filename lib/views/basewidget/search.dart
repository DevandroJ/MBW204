// import 'package:flappy_search_bar/flappy_search_bar.dart';
// import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/data/models/event_search.dart';
import 'package:mbw204_club_ina/providers/event.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/event/detail.dart';


class SearchWidget extends StatelessWidget {
  final String hintText;
  SearchWidget({this.hintText});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        showSearch(context: context, delegate: EventSearch());
      },
      child: Container(
        height: 50.0,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: ColorResources.LAVENDER,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: ColorResources.BLACK,
                  ),
                  SizedBox(width: 10.0),
                  Text(hintText, 
                    style: poppinsRegular.copyWith(
                      color: ColorResources.BLACK 
                    ),
                    overflow: TextOverflow.ellipsis
                  )
                ],
              ) 
            ),
          ], 
        ),
      ),
    );

  }
}


class EventSearch extends SearchDelegate {

  @override
  String get searchFieldLabel => "Cari Event";

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: poppinsRegular.copyWith(
          color: Colors.white,
          fontSize: 16.0
        ),
        border: InputBorder.none
      ),
      textTheme: TextTheme(
      headline6: poppinsRegular.copyWith(
        color: Colors.white, fontSize: 16.0
        )
      ),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: ColorResources.DIM_GRAY,  
      )
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: Icon(Icons.clear), 
      onPressed: () {
        if(query.isEmpty) {
          close(context, null);
        } else {
          query = '';
        }
      }
    )
  ];

  @override
  Widget buildLeading(BuildContext context) =>  IconButton(
    icon: Icon(Icons.arrow_back), 
    onPressed: () {
      Navigator.of(context).pop();
    }
  );
  
  @override
  Widget buildResults(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_city,
          size: 120.0,
        ),
        SizedBox(height: 48.0),
        Text(query)
      ],
    ),
  );
  
  @override
  Widget buildSuggestions(BuildContext context) {
    return query.isEmpty 
    ? Container() 
    : FutureBuilder(
      future: Provider.of<EventProvider>(context, listen: false).getEventSearch(context, query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Loader(
            color: ColorResources.BTN_PRIMARY,
          );
        }
        List<EventSearchData> suggestions = query.isEmpty ? [] : Provider.of<EventProvider>(context, listen: false).eventSearchData.where((event) {
          final descLower = event.description.toLowerCase();
          final queryLower = query.toLowerCase();
          return descLower.contains(queryLower);
        }).toList();
        return suggestions.isEmpty 
        ? Center(
          child: Text(getTranslated("THERE_IS_NO_EVENT", context),
            style: poppinsRegular.copyWith(
              color: ColorResources.DIM_GRAY,
              fontSize: 18.0
            ),
          ),
        ) 
        : ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int i) {
            final suggestion = suggestions[i];
            return ListTile(
              dense: true,
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DetailEventScreen(
                    title: suggestion.description,
                    date: suggestion.created,
                    imageUrl: suggestion.media[0].path,
                    content: suggestion.summary,
                  )),
                );
              },
              visualDensity: VisualDensity(
                vertical: 4.0,
                horizontal: 0.0
              ),
              leading: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: "${AppConstants.BASE_URL_FEED_IMG}${suggestion.media[0].path}",
                  fit: BoxFit.cover,
                  width: 50.0,
                  height: 50.0,
                )
              ),
              title: Text(suggestion.description,
                style: poppinsRegular.copyWith(
                  fontSize: 13.0,
                  color: ColorResources.BLACK
                ),
              ),
              subtitle: Text(suggestion.location,
                style: poppinsRegular.copyWith(
                  fontSize: 12.0,
                  color: ColorResources.BLACK
                ),
              ),
            );
          },
        ); 
      }
    );
  }
  
}