import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';

class InfoScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.BG_GREY,
      body: SafeArea(
        child: Column(
          children: [
            
            CustomAppBar(title: "Info"),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Card(
                  child: Container(
                    child: Column(
                      children: [
                        
                        Container(
                          margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: ColorResources.PRIMARY,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextField(
                            readOnly: true,
                            onTap: () {},
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold 
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(     
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(top: 6.0, left: 5.0, bottom: 15.0),
                                child: SizedBox(
                                  child: IconButton(
                                    onPressed: () => Navigator.of(context).pushNamed("/search-slb"),
                                    icon: Icon(Icons.search),
                                    color: Colors.white,
                                  ),
                                ),
                              ),          
                              hintText: "Cari Bengkel", 
                              hintStyle: TextStyle(
                                color: Colors.white
                              ), 
                              contentPadding: EdgeInsets.only(
                                left: 18.0,
                                top: 18.0,
                                right: 18.0,
                                bottom: 18.0
                              ),
                              border: InputBorder.none,
                            ),
                          ) 
                        ),

                      ],
                    ),
                  )
                ),
              )
            )

          ],
        )
      ),
    );
  }

}