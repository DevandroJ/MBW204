import 'package:flutter/material.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';
import 'package:mbw204_club_ina/views/screens/dashboard/dashboard.dart';

class CashOutSuccessScreen extends StatelessWidget {
  final String title;

  CashOutSuccessScreen({
    this.title
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [

            Icon(
              Icons.verified,
              color: ColorResources.WHITE,
              size: 100.0,
            ),
            
            SizedBox(height: 20.0),

            Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text("Permintaan Anda akan segera kami proses,",
                softWrap: true,
                style: poppinsRegular.copyWith(
                  fontSize: 16.0,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.WHITE
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text("Notifikasi akan masuk ke Inbox Anda.",
                softWrap: true,
                style: poppinsRegular.copyWith(
                  fontSize: 16.0,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.WHITE
                ),
              ),
            ),

            SizedBox(height: 20.0),

            Container(
              width: 140.0,
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
            )

          ],
        ),
      ),
    );
  }
}