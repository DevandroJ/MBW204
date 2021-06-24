// import 'package:flappy_search_bar/flappy_search_bar.dart';
// import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/data/models/event_search.dart';
import 'package:mbw204_club_ina/providers/auth.dart';
import 'package:mbw204_club_ina/providers/event.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  SearchWidget({this.hintText});

  @override
  Widget build(BuildContext context) {

    // return Padding(
    //   padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    //   child: Container(
    //   decoration: BoxDecoration(color: Colors.white),
    //   height: 220.0,
    //   child: SearchBar(
    //     searchBarPadding: EdgeInsets.symmetric(horizontal: 8.0),
    //     headerPadding: EdgeInsets.symmetric(horizontal: 8.0),
    //     listPadding: EdgeInsets.symmetric(horizontal: 8.0),
    //     onSearch: Provider.of<AuthProvider>(context, listen: false).getAllProvinsi,
    //     searchBarController: Provider.of<AuthProvider>(context, listen: false).searchBarProvinsi,
    //     debounceDuration: Duration(milliseconds: 500),
    //     placeHolder: ListView.separated(
    //       separatorBuilder: (BuildContext context, int i) {
    //         return Divider();
    //       },
    //       // itemCount: Provider.of<AuthProvider>(context, listen: false).provinsiData.length,
    //       itemBuilder: (BuildContext context, int i) {
    //         return InkWell(
    //         onTap: () {
    //           Navigator.pop(context);
    //         },
    //         // child: Container(
    //         //   margin: EdgeInsets.only(top: 10.0, left:12.0),
    //         //     child: Text(Provider.of<AuthProvider>(context, listen: false).provinsiData[i].nama,
    //         //       style: titilliumRegular.copyWith(
    //         //         fontSize: 14.0,
    //         //         fontWeight: FontWeight.bold
    //         //       )
    //         //     )
    //         //   )
    //         );
    //       },
    //     ),
    //     cancellationWidget: Text("Batal"),
    //     emptyWidget: Container(
    //     margin: EdgeInsets.only(top: 5.0, left: 12.0),
    //     child: Text( "Data tidak ditemukan",
    //       style: TextStyle(
    //           fontSize: 16.0,
    //           fontWeight: FontWeight.bold
    //         )
    //       )
    //     ),
    //     indexedScaledTileBuilder: (int index) => ScaledTile.count(1, index.isEven ? 2 : 1),
    //     header: Row(),
    //     onCancelled: () {},
    //     mainAxisSpacing: 10.0,
    //     crossAxisSpacing: 10.0,
    //     crossAxisCount: 2,
    //     onItemFound: (EventSearchData event, int i) {

    //       return Container(
    //         child: ListTile(
    //           title: Text(event.description,
    //           style: titilliumRegular.copyWith(
    //               fontSize: 16.0,
    //               fontWeight: FontWeight.bold
    //             )
    //           ),
    //           onTap: () {
               
    //           },
    //         ),
    //       );

    //     },
    //     ),
    //   ),
    // );

    
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
              width: 90.0,
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
    Future fetchEventSearchData(String query) async {
      await Provider.of<EventProvider>(context, listen: false).getEventSearch(context, query);
    }
    fetchEventSearchData(query);
    return buildSuggestionsSuccess();
  }

  Widget buildSuggestionsSuccess() {
    return Consumer<EventProvider>(
      builder: (BuildContext context, EventProvider eventProvider, Widget child) {
        if(eventProvider.eventSearchStatus == EventSearchStatus.loading) {
          return Loader(
            color: ColorResources.BTN_PRIMARY_SECOND,
          );
        }
        if(eventProvider.eventSearchStatus == EventSearchStatus.empty) {
          return Center(
            child: Text("Belum ada event"),
          );
        }
        List<EventSearchData> suggestions = query.isEmpty ? [] : eventProvider.eventSearchData.where((event) {
          final descLower = event.description.toLowerCase();
          final queryLower = query.toLowerCase();
          return descLower.contains(queryLower);
        }).toList();
        return ListView.builder(
          itemBuilder: (BuildContext context, int i) {
            final suggestion = suggestions[i];
            return ListTile(
              dense: true,
              visualDensity: VisualDensity(
                vertical: 4.0,
                horizontal: 0.0
              ),
              leading: ClipOval(
                child: Image.network(
                  "${AppConstants.BASE_URL_FEED_IMG}${suggestion.media[0].path}",
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
        itemCount: suggestions.length,
      ); 
    });
  }
  
}