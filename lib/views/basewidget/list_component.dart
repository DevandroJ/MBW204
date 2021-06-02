import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/views/screens/ppob/cashout/setaccount.dart';
import 'package:mbw204_club_ina/providers/ppob.dart';
import 'package:mbw204_club_ina/views/basewidget/custom_app_bar.dart';

class ListTileComponent extends StatefulWidget {
  final String title;
  final List items;

  ListTileComponent({
    this.title,
    this.items
  });

  @override
  _ListTileComponentState createState() => _ListTileComponentState();
}

class _ListTileComponentState extends State<ListTileComponent> {
  
  int selected;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: widget.title, isBackButtonExist: true),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
                child: StatefulBuilder(
                  builder: (BuildContext context, Function s) {
                    return ListView.separated(
                      itemCount: widget.items.length,
                      separatorBuilder: (BuildContext context, int i) {
                        return Divider();
                      },
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => CashoutSetAccountScreen(
                                      title: widget.title,
                                    )),
                                  );
                                  s(() {
                                    Provider.of<PPOBProvider>(context, listen: false).changePaymentMethod(widget.items[i].name, widget.items[i].code.toString());
                                    selected = i;                   
                                  });
                                },
                                dense: true,
                                leading: Text(widget.items[i].name),
                                trailing: Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    shape: BoxShape.circle
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    width: 5.0,
                                    height: 5.0,
                                    decoration: BoxDecoration(
                                      color: selected == i ? Colors.grey : Colors.transparent,
                                      border: Border.all(color: Colors.transparent),
                                      shape: BoxShape.circle
                                    )
                                  ),
                                ),
                              )
                            ],
                          ),
                        );  
                      }
                    );
                  }
                )
              )
            )

          ],
        ),
      ),
    );
  }
}