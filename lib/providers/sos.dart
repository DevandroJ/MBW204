import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:mbw204_club_ina/data/models/sos.dart';
import 'package:mbw204_club_ina/data/repository/sos.dart';
import 'package:mbw204_club_ina/localization/language_constrants.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/utils/dio.dart';

enum SosConfirmStatus { idle, loading, loaded, error } 

class SosProvider extends ChangeNotifier {
  final SosRepo sosRepo;

  SosProvider({@required this.sosRepo});

  SosConfirmStatus _sosConfirmStatus = SosConfirmStatus.idle;
  SosConfirmStatus get sosConfirmStatus => _sosConfirmStatus;

  List<Sos> _sosList = [];
  List<Sos> get sosList => [..._sosList];

  void setStateSosConfirmStatus(SosConfirmStatus sosConfirmStatus) {
    _sosConfirmStatus = sosConfirmStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void initSosList() async {
    _sosList = [];
    sosRepo.getSosList().forEach((category) => _sosList.add(category));
    Future.delayed(Duration.zero, () => notifyListeners());    
  }

  Future insertSos(BuildContext context, 
    String userId, String geoPosition,
    String type, body,
    String address,
    String sender, String phoneNumber
  ) async {
    try {
      setStateSosConfirmStatus(SosConfirmStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.BASE_URL}/data/sos", data: {
        "userId": userId,
        "geoPosition": geoPosition,
        "address": address,
        "sosType": "sos",
        "Message": "$body $address",
        "sender": sender,
        "phoneNumber": phoneNumber
      });
      showAnimatedDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ClassicGeneralDialogWidget(
            titleText: "${getTranslated("SENT_SOS", context)} !",
            contentText: '',
            positiveText: 'Ok',
            onPositiveClick: () => Navigator.of(context).pop(),
          );                   
        },
        animationType: DialogTransitionType.scale,
      );
      setStateSosConfirmStatus(SosConfirmStatus.loaded);
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      showAnimatedDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ClassicGeneralDialogWidget(
            titleText: getTranslated("THERE_WAS_PROBLEM", context),
            contentText: '',
            positiveText: 'Ok',
            onPositiveClick: () {
              Navigator.of(context).pop();
            },
          );                   
        },
        animationType: DialogTransitionType.scale,
        curve: Curves.fastOutSlowIn,
      );
      setStateSosConfirmStatus(SosConfirmStatus.error);
    } catch(e) {
      print(e);
    }
  }

}
