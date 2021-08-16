import 'package:flutter/material.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:sizer/sizer.dart';
import 'package:readmore/readmore.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';

class PostTextComponent extends StatefulWidget {
  final dynamic item;

  PostTextComponent(
    this.item
  );

  @override
  _PostTextComponentState createState() => _PostTextComponentState();
}

class _PostTextComponentState extends State<PostTextComponent> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      margin: EdgeInsets.only(left: 70.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadMoreText(widget.item.text,
            style: poppinsRegular.copyWith(
              fontSize: 9.0.sp,
              color: ColorResources.BLACK
            ),
            trimLines: 2,
            colorClickableText: Colors.black,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Tampilkan Lebih',
            trimExpandedText: 'Tutup',
            moreStyle: poppinsRegular.copyWith(
              fontSize: 9.0.sp, 
              fontWeight: FontWeight.bold
            ),
            lessStyle: poppinsRegular.copyWith(
              fontSize: 9.0.sp, 
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ) 
    );
  }
}