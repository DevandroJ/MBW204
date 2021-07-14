import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/dimensions.dart';

class TitleRow extends StatelessWidget {
  final String title;
  final Function onTap;
  final Duration eventDuration;
  final bool isDetailsPage;
  TitleRow({@required this.title, this.onTap, this.eventDuration, this.isDetailsPage});

  @override
  Widget build(BuildContext context) {
    int days, hours, minutes, seconds;
    if (eventDuration != null) {
      days = eventDuration.inDays;
      hours = eventDuration.inHours - days * 24;
      minutes = eventDuration.inMinutes - (24 * days * 60) - (hours * 60);
      seconds = eventDuration.inSeconds - (24 * days * 60 * 60) - (hours * 60 * 60) - (minutes * 60);
    }

    return Row(children: [
      Text(title, style: poppinsRegular),
      eventDuration == null
          ? Expanded(child: SizedBox.shrink())
          : Expanded(
              child: Row(children: [
              SizedBox(width: 5),
              TimerBox(time: days),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: hours),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: minutes),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: seconds, isBorder: true),
            ])),
      onTap != null
          ? InkWell(
              onTap: onTap,
              child: Row(children: [
                isDetailsPage == null
                    ? Text(getTranslated('VIEW_ALL', context),
                        style: poppinsRegular.copyWith(
                          color: ColorResources.PRIMARY,
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                        ))
                    : SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: isDetailsPage == null ? ColorResources.PRIMARY : Theme.of(context).hintColor,
                    size: Dimensions.FONT_SIZE_SMALL,
                  ),
                ),
              ]),
            )
          : SizedBox.shrink(),
    ]);
  }
}

class TimerBox extends StatelessWidget {
  final int time;
  final bool isBorder;

  TimerBox({@required this.time, this.isBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1),
      padding: EdgeInsets.all(isBorder ? 0 : 2),
      decoration: BoxDecoration(
        color: isBorder ? null : ColorResources.getPrimary(context),
        border: isBorder ? Border.all(width: 2, color: ColorResources.getPrimary(context)) : null,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Text(time < 10 ? '0$time' : time.toString(),
          style: poppinsRegular.copyWith(
            color: isBorder ? ColorResources.getPrimary(context) : Theme.of(context).accentColor,
            fontSize: Dimensions.FONT_SIZE_SMALL,
          ),
        ),
      ),
    );
  }
}
