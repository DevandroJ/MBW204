import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/views/screens/dashboard/dashboard.dart';

class TopUpSuccessScreen extends StatelessWidget {
  final String title;

  TopUpSuccessScreen({
    this.title
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Center(
            child: Icon(
              Icons.verified,
              color: ColorResources.WHITE,
              size: 100.0,
            ),
          ),

          SizedBox(height: 16.0),

          Container(
            margin: EdgeInsets.only(left: 40.0, right: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text("Permintaan Anda akan segera kami proses,",
                    softWrap: true,
                    style: poppinsRegular.copyWith(
                      fontSize: 14.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.WHITE
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("segera lakukan pembayaran.",
                    softWrap: true,
                    style: poppinsRegular.copyWith(
                      fontSize: 14.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.WHITE
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("Notifikasi akan masuk ke Inbox Anda.",
                    softWrap: true,
                    style: poppinsRegular.copyWith(
                      fontSize: 14.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.WHITE
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.0),

          Center(
            child: Container(
              width: 100.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith<double>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return 0;
                      }
                      return 0;
                    },
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.blue[600]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )
                  )
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
                },
                child: Text("OK",
                  style: poppinsRegular.copyWith(
                    color: Colors.white
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}