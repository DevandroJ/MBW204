import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import 'package:mbw204_club_ina/providers/store.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

class EditNoteProductPage extends StatefulWidget {
  final String idProduct;
  final String note;

  EditNoteProductPage({
    Key key,
    @required this.idProduct,
    @required this.note,
  }) : super(key: key);
  @override
  _EditNoteProductPageState createState() => _EditNoteProductPageState();
}

class _EditNoteProductPageState extends State<EditNoteProductPage> {
  TextEditingController _catatan;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _catatan = TextEditingController(text: widget.note);

    _catatan.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
        
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Tulis Catatan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleSpacing: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Icon(Icons.close)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0)),
              child: TextFormField(
                controller: _catatan,
                autofocus: true,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Tulis catatan untuk barang ini",
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                validator: (val) {
                  if (val.trim().isEmpty) {
                    return "Catatan tidak boleh kosong";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                  fontFamily: 'Proppins',
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60.0,
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
                child: SizedBox(
                  height: 55.0,
                  width: double.infinity,
                  child: RaisedButton(
                  color: ColorResources.PRIMARY,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text("Submit",
                      style: TextStyle(
                        fontSize: 16.0, 
                        color: Colors.white
                      )
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await Provider.of<WarungProvider>(context, listen: false).postEditNoteCart(context, widget.idProduct, _catatan.text);
                      Navigator.pop(context, true);
                    } catch(_) {
                    }                      
                  },
                )
              )
            )
          )
        ],
      ),
    );
  }
}
