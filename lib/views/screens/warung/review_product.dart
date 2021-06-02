import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/warung/transaction_warung_paid_single_model.dart';
import 'package:mbw204_club_ina/providers/warung.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/loader.dart';
import 'package:mbw204_club_ina/views/screens/warung/pesanan_transaction_warung.dart';

class ReviewProductPage extends StatefulWidget {
  final String idProduct;
  final String nameProduct;
  final String imgUrl;

  ReviewProductPage({
    Key key,
    @required this.idProduct,
    @required this.nameProduct,
    @required this.imgUrl,
  }) : super(key: key);
  @override
  _ReviewProductPageState createState() => _ReviewProductPageState();
}

class _ReviewProductPageState extends State<ReviewProductPage> {
  double productRating = 1.0;
  final ulasanController = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  TransactionWarungPaidSingleModel transactionPaidSingle;
  bool isLoading = true;
  ProgressDialog pr;

  List<File> files = [];
  List<Asset> images = List<Asset>();

  @override
  void initState() {
    super.initState();
  }

  void uploadPic() async {
    List<Asset> resultList = List<Asset>();
    List<File> before = [];
    resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: false,
        selectedAssets: images,
        materialOptions: MaterialOptions(
            actionBarColor: "#FF7700", statusBarColor: "#FF7700"));
    resultList.forEach((imageAsset) async {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);
      File tempFile = File(filePath);
      setState(() {
        images = resultList;
        before.add(tempFile);
        files = before.toSet().toList();
      });
    });
  }

  Future<bool> onWillPop() {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PesananTransactionWarungPage(
        index: 5,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final warungVM = Provider.of<WarungProvider>(context, listen: false);
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: ' Mohon Tunggu...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Loader(
          color: ColorResources.PRIMARY,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Beri Ulasan Produk",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: ColorResources.PRIMARY,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  color: Colors.white),
              onPressed: () {
                Navigator.pop(context, true);
              }),
        ),
        body: Stack(
          children: [
            ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(16),
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 50,
                            child: Stack(
                              children: [
                                Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            AppConstants.BASE_URL_FEED_IMG + widget.imgUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                            child: Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.grey[100],
                                          child: Container(
                                            color: Colors.white,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        )),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                                child: Image.asset(
                                          "assets/default_image.png",
                                          fit: BoxFit.cover,
                                        )),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                widget.nameProduct.length > 75
                                    ? Text(
                                        widget.nameProduct.substring(0, 80) +
                                            "...",
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        widget.nameProduct,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Container(
                          child: RatingBar(
                            initialRating: 1,
                            minRating: 1.0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 50,
                            ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              half: Icon(Icons.star_half, color: Colors.amber),
                              empty:
                                  Icon(Icons.star_border, color: Colors.amber),
                            ),
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            onRatingUpdate: (rating) {
                              print(rating);
                              productRating = rating;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Center(
                        child: Text(
                          "Yuk, Bantu calon pembeli lain dengan \nbagikan pengalamanmu!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.orange[700]),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Fotoin dong barangnya",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 100,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[600]),
                            borderRadius: BorderRadius.circular(10)),
                        child: files == null || files.length == 0
                            ? Row(
                                children: [
                                  GestureDetector(
                                    onTap: uploadPic,
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey[400]),
                                          color: Colors.grey[350]),
                                      child: Center(
                                        child: files == null ||
                                                files.length == 0
                                            ? Icon(
                                                Icons.camera_alt,
                                                color: Colors.grey[600],
                                                size: 35,
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: FadeInImage(
                                                    fit: BoxFit.cover,
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    image:
                                                        FileImage(files.first),
                                                    placeholder: AssetImage(
                                                        "assets/default_profile.png")),
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Unggah Gambar Ulasan",
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          "Maksimum 5 gambar, ukuran minimal 300x300px berformat JPG atau PNG",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                    ],
                                  ))
                                ],
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: files.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < files.length) {
                                    return Container(
                                      height: 80,
                                      width: 80,
                                      margin: EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey[400]),
                                          color: Colors.grey[350]),
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: FadeInImage(
                                              fit: BoxFit.cover,
                                              height: double.infinity,
                                              width: double.infinity,
                                              image: FileImage(files[index]),
                                              placeholder: AssetImage(
                                                  "assets/default_profile.png")),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        if (files.length < 5) {
                                          uploadPic();
                                        } else if (files.length >= 5) {
                                          setState(() {
                                            files.clear();
                                            images.clear();
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        margin: EdgeInsets.only(right: 4),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey[400]),
                                            color: files.length < 5
                                                ? Colors.grey[350]
                                                : Colors.red),
                                        child: Center(
                                          child: Icon(
                                            files.length < 5
                                                ? Icons.camera_alt
                                                : Icons.delete,
                                            color: files.length < 5
                                                ? Colors.grey[600]
                                                : Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Apa yang bikin kamu puas?",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: TextFormField(
                          maxLength: null,
                          maxLines: null,
                          controller: ulasanController,
                          decoration: InputDecoration(
                            hintText: "Ceritakan pengalamanmu terkait barang ini",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.orange[700]
                              ),
                            ),
                          ),
                          // onSaved: (newValue) {
                          //   description = newValue;
                          // },
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 60,
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              pr.show();
                              await warungVM
                                  .postDataReviewProduct(
                                    context,
                                    widget.idProduct,
                                    productRating,
                                    ulasanController.text,
                                    files
                                  )
                                  .then((value) {
                                if (value.code == 0) {
                                  pr.hide();
                                  Navigator.pop(context, true);
                                } else {
                                  pr.hide();
                                  Fluttertoast.showToast(
                                      msg: "Terjadi kesalahan mohon coba lagi",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white);
                                }
                              });
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orange[700]
                              ),
                              child: Center(
                                child: Text("Kirim",
                                  style: TextStyle(
                                    color: Colors.white, 
                                    fontSize: 16
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
