
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mbw204_club_ina/views/screens/ppob/cashout/success.dart';
import 'package:mbw204_club_ina/data/models/ppob/cashout/denom.dart';
import 'package:mbw204_club_ina/data/models/ppob/cashout/submit.dart';
import 'package:mbw204_club_ina/data/models/ppob/cashout/bank.dart';
import 'package:mbw204_club_ina/data/models/ppob/cashout/emoney.dart';
import 'package:mbw204_club_ina/data/models/ppob/cashout/inquiry.dart';
import 'package:mbw204_club_ina/helpers/helper.dart';
import 'package:mbw204_club_ina/views/screens/ppob/checkout_registrasi.dart';
import 'package:mbw204_club_ina/utils/constant.dart';
import 'package:mbw204_club_ina/data/models/ppob/registration/pay.dart'; 
import 'package:mbw204_club_ina/data/models/ppob/pln/inquiry_pascabayar.dart';
import 'package:mbw204_club_ina/data/models/ppob/wallet/balance.dart';
import 'package:mbw204_club_ina/data/models/ppob/va.dart';
import 'package:mbw204_club_ina/data/models/ppob/pln/inquiry_prabayar.dart';
import 'package:mbw204_club_ina/data/models/ppob/pln/list_price_prabayar.dart';
import 'package:mbw204_club_ina/data/models/ppob/list_product_denom.dart';
import 'package:mbw204_club_ina/data/models/ppob/wallet/history.dart';
import 'package:mbw204_club_ina/data/models/ppob/wallet/inqury_topup.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/exceptions.dart';
import 'package:mbw204_club_ina/views/screens/ppob/confirm_payment.dart';
import 'package:mbw204_club_ina/views/screens/ppob/payment_success.dart';
import 'package:mbw204_club_ina/views/screens/ppob/topup/success.dart';
import 'package:mbw204_club_ina/views/basewidget/separator_dash.dart';
import 'package:mbw204_club_ina/utils/dio.dart';

// PLN
enum InquiryPLNPrabayarStatus  { loading, loaded, empty, error }
enum ListPricePLNPrabayarStatus { idle, loading, loaded, empty, error }
enum InquiryPLNPascabayarStatus { loading, loaded, empty, error }

// PULSA
enum ListVoucherPulsaByPrefixStatus { idle, loading, loaded, empty, error }

// EMONEY
enum ListTopUpEmoneyStatus { loading, loaded, empty, error }

// VA 
enum VaStatus { loading, loaded, empty, error }

// WALLET 
enum BalanceStatus { loading, loaded, empty, error }
enum HistoryBalanceStatus { loading, loaded, empty, error }

// DISBURSEMENT
enum InquiryDisbursementStatus { idle, loading, loaded, empty, error }
enum DenomDisbursementStatus { idle, loading, loaded, empty, error }
enum BankDisbursementStatus { loading, loaded, empty, error }
enum EmoneyDisbursementStatus { loading, loaded, empty, error }
enum SubmitDisbursementStatus { idle, loading, loaded, empty, error }

class PPOBProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;

  PPOBProvider({
    this.sharedPreferences
  });

  // PLN
  bool btnNextBuyPLNPrabayar = false;

  // Konfirmasi Pembayaran
  bool loadingBuyBtn = false;

  /*-- Prabayar --*/ 
  InquiryPLNPrabayarData inquiryPLNPrabayarData;

  /*-- Pascabayar -- */
  InquiryPLNPascaBayarData inquiryPLNPascaBayarData; 

  /*-- TopUp E-Wallet --*/
  InquiryTopUpData inquiryTopUpData;

  ListPricePLNPrabayarStatus _listPricePLNPrabayarStatus = ListPricePLNPrabayarStatus.idle;
  ListPricePLNPrabayarStatus get listPricePLNPrabayarStatus => _listPricePLNPrabayarStatus;

  InquiryPLNPrabayarStatus _inquiryPLNPrabayarStatus = InquiryPLNPrabayarStatus.loading; 
  InquiryPLNPrabayarStatus get inquiryPLNPrabayarStatus => _inquiryPLNPrabayarStatus;

  InquiryPLNPascabayarStatus _inquiryPLNPascaBayarStatus = InquiryPLNPascabayarStatus.empty;
  InquiryPLNPascabayarStatus get inquiryPLNPascabayarStatus => _inquiryPLNPascaBayarStatus;
  
  /* -- List Price PLN Prabayar --*/
  void setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus listPricePLNPrabayarStatus) {
    _listPricePLNPrabayarStatus = listPricePLNPrabayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  /* -- Prabayar -- */ 
  void setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus inquiryPLNPrabayarStatus) {
    _inquiryPLNPrabayarStatus = inquiryPLNPrabayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  /* -- Pascabayar -- */
  void setStateInquiryPLNPascabayarStatus(InquiryPLNPascabayarStatus inquiryPLNPascaBayarStatus) {
    _inquiryPLNPascaBayarStatus = inquiryPLNPascaBayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  List<ListPricePraBayarData> _listPricePLNPrabayarData = [];
  List<ListPricePraBayarData> get listPricePLNPrabayarData => _listPricePLNPrabayarData;

  // PULSA
  ListVoucherPulsaByPrefixStatus _listVoucherPulsaByPrefixStatus = ListVoucherPulsaByPrefixStatus.idle;
  ListVoucherPulsaByPrefixStatus get listVoucherPulsaByPrefixStatus => _listVoucherPulsaByPrefixStatus;

  void setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus listVoucherPulsaByPrefixStatus) {
    _listVoucherPulsaByPrefixStatus = listVoucherPulsaByPrefixStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  List<ListProductDenomData> _listVoucherPulsaByPrefixData = [];
  List<ListProductDenomData> get listVoucherPulsaByPrefixData => _listVoucherPulsaByPrefixData;

  // E-MONEY
  ListTopUpEmoneyStatus _listTopUpEmoneyStatus = ListTopUpEmoneyStatus.empty;
  ListTopUpEmoneyStatus get listTopUpEmoneyStatus => _listTopUpEmoneyStatus;

  void setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus listTopUpEmoneyStatus) {
    _listTopUpEmoneyStatus = listTopUpEmoneyStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
   
  List<ListProductDenomData> _listTopUpEmoney = [];
  List<ListProductDenomData> get  listTopUpEmoney => _listTopUpEmoney;

  // VA
  VaStatus _vaStatus = VaStatus.loading;
  VaStatus get vaStatus => _vaStatus;

  List<VAData> _listVa = [];
  List<VAData> get listVa => _listVa;

  void setStateVAStatus(VaStatus vaStatus) {
    _vaStatus = vaStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  // Wallet 
  BalanceStatus _balanceStatus = BalanceStatus.loading;
  BalanceStatus get balanceStatus => _balanceStatus;

  HistoryBalanceStatus _historyBalanceStatus = HistoryBalanceStatus.loading;
  HistoryBalanceStatus get historyBalanceStatus => _historyBalanceStatus;

  void setStateHistoryBalanceStatus(HistoryBalanceStatus historyBalanceStatus) {
    _historyBalanceStatus = historyBalanceStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  List<HistoryBalanceData> _historyBalanceData = [];
  List<HistoryBalanceData> get historyBalanceData => _historyBalanceData;

  double balance;

  void setStateBalanceStatus(BalanceStatus walletStatus) {
    _balanceStatus = walletStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  // Disbursement 
  InquiryDisbursementStatus _inquirydisbursementStatus = InquiryDisbursementStatus.idle;
  InquiryDisbursementStatus get disbursementStatus => _inquirydisbursementStatus;

  List<DenomDisbursementBody> _denomDisbursement = [];
  List<DenomDisbursementBody> get denomDisbursement => _denomDisbursement;

  List<BankDisbursementBody> _bankDisbursement = [];
  List<BankDisbursementBody> get bankDisbursement => _bankDisbursement;

  DenomDisbursementStatus _denomDisbursementStatus = DenomDisbursementStatus.loading;
  DenomDisbursementStatus get denomDisbursementStatus => _denomDisbursementStatus;

  BankDisbursementStatus _bankDisbursementStatus = BankDisbursementStatus.loading;
  BankDisbursementStatus get bankDisbursementStatus => _bankDisbursementStatus; 

  List<EmoneyDisbursementBody> _emoneyDisbursement = [];
  List<EmoneyDisbursementBody> get emoneyDisbursement => _emoneyDisbursement;

  EmoneyDisbursementStatus _emoneyDisbursementStatus = EmoneyDisbursementStatus.loading;
  EmoneyDisbursementStatus get emoneyDisbursementStatus => _emoneyDisbursementStatus;

  SubmitDisbursementStatus _submitDisbursementStatus = SubmitDisbursementStatus.idle;
  SubmitDisbursementStatus get submitDisbursementStatus => _submitDisbursementStatus;

  void setStateDisbursementStatus(InquiryDisbursementStatus inquirydisbursementStatus) {
    _inquirydisbursementStatus = inquirydisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateDenomDisbursementStatus(DenomDisbursementStatus denomDisbursementStatus) {
    _denomDisbursementStatus = denomDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateBankDisbursementStatus(BankDisbursementStatus bankDisbursementStatus) {
    _bankDisbursementStatus = bankDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateEmoneyDisbursementStatus(EmoneyDisbursementStatus emoneyDisbursementStatus) {
    _emoneyDisbursementStatus = emoneyDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSubmitDisbursementStatus(SubmitDisbursementStatus submitDisbursementStatus) {
    _submitDisbursementStatus = submitDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  // void changeCashoutDisbursementCode(String val) {
  //   cashoutDisbursementBankCode = val;
  //   Future.delayed(Duration.zero, () => notifyListeners());
  // }

  // void changeCashoutDisbursementName(String val) {
  //   cashoutDisbursementBankName = val;
  //   Future.delayed(Duration.zero, () => notifyListeners());
  // }

  // void removeCashoutDisbursementName() {
  //   cashoutDisbursementBankName = "";
  //   Future.delayed(Duration.zero, () => notifyListeners());
  // }

  Future setAccountPaymentMethod(String account) async {
    sharedPreferences.setString("global_payment_method_account", account);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future changePaymentMethod(String name, String code) async {
    sharedPreferences.setString("global_payment_method_name", name);
    sharedPreferences.setString("global_payment_method_code", code);
    Future.delayed(Duration.zero,() => notifyListeners());
  }

  Future removePaymentMethod() async {
    sharedPreferences.remove("global_payment_method_name");
    sharedPreferences.remove("global_payment_method_code");
    sharedPreferences.remove("global_payment_method_account");
    Future.delayed(Duration.zero,() => notifyListeners());
  }

  String get getGlobalPaymentAccount => sharedPreferences.getString("global_payment_method_account") ?? "";
  String get getGlobalPaymentMethodName => sharedPreferences.getString("global_payment_method_name") ?? "";
  String get getGlobalPaymentMethodCode => sharedPreferences.getString("global_payment_method_code") ?? "";

  Future payRegister(BuildContext context, String productId, String paymentChannel, String transactionId) async {
    try {
      loadingBuyBtn = true;
      notifyListeners();
      Dio dio = Dio();
      Response res =  await dio.post("${AppConstants.BASE_URL_PPOB}/registration/pay", data: {
        "productId": productId,
        "paymentChannel" : paymentChannel,
        "paymentMethod": "BANK_TRANSFER",
        "transactionId" : transactionId
      }, options: Options(
        headers: {
          "Authorization": "Bearer ${sharedPreferences.getString("pay_register_token")}",
          "X-Context-ID": AppConstants.X_CONTEXT_ID
        }
      ));
      PayRegisterModel payRegisterModel = PayRegisterModel.fromJson(res.data);
      Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => CheckoutRegistrasiScreen(
          adminFee: double.parse(payRegisterModel.body.data.paymentAdminFee.toString()),
          guide: payRegisterModel.body.data.paymentGuide,
          nameBank: payRegisterModel.body.data.paymentChannel,
          noVa: payRegisterModel.body.data.paymentCode,
          productPrice: double.parse(payRegisterModel.body.productPrice.toString()),
          transactionId: payRegisterModel.body.transactionId,
        )),
      );
      loadingBuyBtn = false;
      notifyListeners();
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        loadingBuyBtn = false;
        notifyListeners();
        throw ServerErrorException("Ups! Terjadi kesalahan, mohon ulangi");
      }
      loadingBuyBtn = false;
      notifyListeners();
    } catch(e) {
      loadingBuyBtn = false;
      notifyListeners();      
      print(e);
    }
  }

  Future payPLNPrabayar(BuildContext context, String productId, String accountNumber, String transactionId) async {
    try {
      loadingBuyBtn = true;
      notifyListeners();
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.BASE_URL_PPOB}/pln/prabayar/pay", data: {
        "productId" : productId,
        "accountNumber" : accountNumber,
        "paymentMethod": "WALLET",
        "transactionId": transactionId
      });
      loadingBuyBtn = false;
      notifyListeners();
      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentSuccessScreen()));
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        loadingBuyBtn = false;
        notifyListeners();
        throw ServerErrorException("Ups! Saldo Anda tidak cukup / Terjadi kesalahan, mohon ulangi");
      }
      loadingBuyBtn = false;
      notifyListeners();
    } catch(e) {
      loadingBuyBtn = false;
      notifyListeners();
      print(e);
    }
  }

  Future payPLNPascabayar(BuildContext context, String accountNumber, String transactionId) async {
    try {
      loadingBuyBtn = true;
      notifyListeners();
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.BASE_URL_PPOB}/pln/pascabayar/pay", data: {
        "productId": "49c55554-8c62-4f80-8758-d8f0cea1b63b",
        "accountNumber": accountNumber,
        "paymentMethod": "WALLET",
        "transactionId": transactionId
      });
      loadingBuyBtn = false;
      notifyListeners();
      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentSuccessScreen()));
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        loadingBuyBtn = false;
        notifyListeners();
        throw ServerErrorException("Ups! Saldo Anda tidak cukup / Terjadi kesalahan, mohon ulangi");
      }
      loadingBuyBtn = false;
      notifyListeners();
    } catch(e) {
      loadingBuyBtn = false;
      notifyListeners();
      print(e);
    }
  }

  Future inquiryTopUp(BuildContext context, String productId, String accountNumber) async {
    try {
      loadingBuyBtn = true;
      notifyListeners();
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_PPOB}/wallet/inquiry", data: {
        "productId": productId,
        "accountNumber" : accountNumber
      });
      InquiryTopUpModel inquiryTopUpModel = InquiryTopUpModel.fromJson(res.data);
      inquiryTopUpData = inquiryTopUpModel.body;
      loadingBuyBtn = false;
      notifyListeners();
    } on DioError catch(e) {
      if(e?.response?.statusCode == 400) {
        loadingBuyBtn = false;
        notifyListeners();
        throw ServerErrorException("Ups! Terjadi kesalahan, mohon ulangi");
      }
      loadingBuyBtn = false;
      notifyListeners();
    } catch(e) {
      loadingBuyBtn = false;
      notifyListeners();
      print(e);
    }
  }

  Future payTopUp(BuildContext context, String productId, String paymentChannel, String transactionId) async {
    try {
      loadingBuyBtn = true;
      Future.delayed(Duration.zero, () => notifyListeners());
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.BASE_URL_PPOB}/wallet/pay", data : {
        "productId": productId,
        "paymentMethod" : "BANK_TRANSFER",
        "paymentChannel": paymentChannel,
        "transactionId": transactionId
      });
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      Navigator.push(context, MaterialPageRoute(builder: (context) => TopUpSuccessScreen()));
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        loadingBuyBtn = false;
        Future.delayed(Duration.zero, () => notifyListeners());
        throw ServerErrorException("Ups! Terjadi kesalahan, mohon ulangi");
      }
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      print(e);
    }
  }

  Future purchasePulsa(BuildContext context, String productId, String accountNumber) async {
    try {
      loadingBuyBtn = true;
      Future.delayed(Duration.zero, () => notifyListeners());
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.BASE_URL_PPOB}/pulsa/purchase", data: {
        "productId": productId,
        "accountNumber": accountNumber,
        "paymentMethod": "WALLET"
      });
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentSuccessScreen()));
    } on DioError catch(e) {
      if(e?.response?.statusCode == 400) {
        loadingBuyBtn = false;
        Future.delayed(Duration.zero, () => notifyListeners());
        throw ServerErrorException("Ups! Saldo Anda tidak cukup / Terjadi kesalahan, mohon ulangi");
      } 
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());    
      print(e);
    }
  }

  Future purchaseEmoney(BuildContext context, String productId, String accountNumber) async {
    try {
      loadingBuyBtn = true;
      notifyListeners();
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.BASE_URL_PPOB}/emoney/purchase", data: {
        "productId": productId,
        "accountNumber": accountNumber,
        "paymentMethod": "WALLET"
      });
      loadingBuyBtn = false;
      notifyListeners();
      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentSuccessScreen()));
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        loadingBuyBtn = false;
        notifyListeners();
        throw ServerErrorException("Ups! Saldo Anda tidak cukup / Terjadi kesalahan, mohon ulangi");
      }
      loadingBuyBtn = false;
      notifyListeners();
    } catch(e) {
      loadingBuyBtn = false;
      notifyListeners();
      print(e);
    }
  }

  Future postInquiryPLNPrabayarStatus(BuildContext context, String productId, String accountNumber, String paymentMethod) async {
    try {
      btnNextBuyPLNPrabayar = true;
      Future.delayed(Duration.zero, () => notifyListeners());

      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_PPOB}/pln/prabayar/inquiry", data: {
        "productId" : productId,
        "accountNumber" : accountNumber,
        "paymentMethod": paymentMethod
      });

      InquiryPLNPrabayarModel inquiryPLNPrabayarModel = InquiryPLNPrabayarModel.fromJson(res.data);
      inquiryPLNPrabayarData = inquiryPLNPrabayarModel.data;

      btnNextBuyPLNPrabayar = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.loaded);

      showMaterialModalBottomSheet(        
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: context,
        builder: (context) => SingleChildScrollView(
          child: Container(
            height: 300.0,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Informasi Pelanggan",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Nomor Meter"),
                          Text(accountNumber)
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Nama Pelanggan"),
                          Text(inquiryPLNPrabayarData.data.accountName)
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  color: Colors.blueGrey[50],
                  height: 8.0,
                ),
                SizedBox(height: 12.0),
                 Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Detail Pembayaran",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Token Listrik"),
                          Text(ConnexistHelper.formatCurrency(inquiryPLNPrabayarData.productPrice))
                        ],
                      ),
                      SizedBox(height: 10.0),
                      MySeparatorDash(
                        color: Colors.blueGrey[50],
                        height: 3.0,
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Pembayaran",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(ConnexistHelper.formatCurrency(inquiryPLNPrabayarData.productPrice),
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      elevation: 0.0,
                      color: ColorResources.WHITE,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide.none
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Ubah",
                        style: TextStyle(
                          color: ColorResources.PURPLE_DARK
                        ),
                      ),
                    ),
                    RaisedButton(
                      elevation: 0.0,
                      color: ColorResources.PURPLE_DARK,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide.none
                      ),
                      onPressed: () { 
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ConfirmPaymentScreen(
                            type: "pln-prabayar",
                            description: inquiryPLNPrabayarData.productName,
                            nominal : inquiryPLNPrabayarData.productPrice,
                            provider: "pln",
                            accountNumber: inquiryPLNPrabayarData.accountNumber1,
                            productId: inquiryPLNPrabayarData.productId,
                          )),
                        );
                      },
                      child: Text("Konfirmasi",
                        style: TextStyle(
                          color: ColorResources.WHITE
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } on DioError catch(_) {
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.error);

      showMaterialModalBottomSheet(
        context: context, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (context) {
        return Container(
          height: 320.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset("assets/lottie/error.json",
                width: 100.0,
                height: 100.0,
              ),
              Text("Ups! Maaf, nomor pelanggan salah / Sedang ada gangguan")
            ],
          ),
        );
      });
      
      btnNextBuyPLNPrabayar = false;
      notifyListeners();
    } catch(e) {
      print(e);
      btnNextBuyPLNPrabayar = false;
      notifyListeners();
    }
  }

  Future postInquiryPLNPascaBayar(BuildContext context, String accountNumber, TextEditingController controller, dynamic listener) async {
    try {
      setStateInquiryPLNPascabayarStatus(InquiryPLNPascabayarStatus.loading);
      
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_PPOB}/pln/pascabayar/inquiry", data: {
        "productId": "49c55554-8c62-4f80-8758-d8f0cea1b63b",
        "accountNumber": accountNumber
      });

      InquiryPLNPascabayarModel inquiryPLNPascaBayarModel = InquiryPLNPascabayarModel.fromJson(res.data);
      inquiryPLNPascaBayarData = inquiryPLNPascaBayarModel.body;

      setStateInquiryPLNPascabayarStatus(InquiryPLNPascabayarStatus.loaded);

      controller.removeListener(listener);
      showMaterialModalBottomSheet(        
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), 
            topRight: Radius.circular(20.0)
          ),
        ),
        context: context,
        builder: (context) => SingleChildScrollView(
          child: Container(
            height: 315.0,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Informasi Pelanggan",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Nomor Meter"),
                          Text(accountNumber)
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Nama Pelanggan"),
                          Text(inquiryPLNPascaBayarData.data.accountName)
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  color: Colors.blueGrey[50],
                  height: 8.0,
                ),
                SizedBox(height: 12.0),
                 Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Detail Pembayaran",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tagihan Listrik"),
                          Text(ConnexistHelper.formatCurrency(double.parse(inquiryPLNPascaBayarData.data.amount.toString())))
                        ],
                      ),
                      SizedBox(height: 10.0),
                      MySeparatorDash(
                        color: Colors.blueGrey[50],
                        height: 3.0,
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Pembayaran",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(ConnexistHelper.formatCurrency(double.parse(inquiryPLNPascaBayarData.data.amount.toString())),
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 140.0,
                      child: RaisedButton(
                        elevation: 0.0,
                        color: ColorResources.WHITE,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide.none
                        ),
                        onPressed: () { 
                          controller.addListener(listener);
                          Navigator.of(context).pop();
                        },
                        child: Text("Ubah",
                          style: TextStyle(
                            color: ColorResources.PURPLE_DARK
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 140.0,
                      child: RaisedButton(
                        elevation: 0.0,
                        color: ColorResources.PURPLE_DARK,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide.none
                        ),
                        onPressed: () { 
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ConfirmPaymentScreen(
                              type: "pln-pascabayar",
                              description: inquiryPLNPascaBayarData.productName,
                              nominal : inquiryPLNPascaBayarData.data.amount,
                              provider: "pln",
                              accountNumber: inquiryPLNPascaBayarData.accountNumber1,
                              productId: inquiryPLNPascaBayarData.productId,
                            )),
                          );
                        },
                        child: Text("Konfirmasi",
                          style: TextStyle(
                            color: ColorResources.WHITE
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );

    } on DioError catch(_) {
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.error);
      showMaterialModalBottomSheet(
        context: context, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (context) {
        return Container(
          height: 320.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset("assets/lottie/error.json",
                width: 100.0,
                height: 100.0,
              ),
              Text("Ups! Maaf, nomor pelanggan salah / Sedang ada gangguan")
            ],
          ),
        );
      });
    } catch(e) {
      print(e);
    }
  } 


  void getListPricePLNPrabayar(context) async {
    try {
      setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_PPOB}/product/list?group=public_utility&category=PLN&type=prabayar");
      ListPricePraBayarModel listPricePraBayarModel = ListPricePraBayarModel.fromJson(res.data);
      _listPricePLNPrabayarData = [];
      List<ListPricePraBayarData> listPricePLNPrabayarData = listPricePraBayarModel.body;
      _listPricePLNPrabayarData.addAll(listPricePLNPrabayarData);
      setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.loaded);
      if(_listPricePLNPrabayarData.length == 0) {
        setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.empty);
      }
    } on DioError catch(_) { 
      setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.error);
    } catch(e) {
      print(e);
    }
  } 

  void getListEmoney(BuildContext context, String category) async {
    try {
      setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_PPOB}/product/list?group=emoney&category=$category&type=credit");
      _listTopUpEmoney = [];
      ListProductDenomModel listProductDenomModel = ListProductDenomModel.fromJson(res.data);
      _listTopUpEmoney.addAll(listProductDenomModel.body);
      setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.loaded);
      if(_listTopUpEmoney.length == 0) {
        setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.empty);
      }
    } on DioError catch(_) {
      setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.error);
    } catch(e) {
      print(e);
    }
  }

  void getVoucherPulsaByPrefix(BuildContext context, int prefix) async {
    try {
      setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_PPOB}/product/list?group=voucher&category=$prefix&type=pulsa");
      ListProductDenomModel listVoucherPulsaByPrefixModel = ListProductDenomModel.fromJson(res.data);
      _listVoucherPulsaByPrefixData = [];
      List<ListProductDenomData> listVoucherPulsaByPrefixData = listVoucherPulsaByPrefixModel.body;
      _listVoucherPulsaByPrefixData.addAll(listVoucherPulsaByPrefixData);
      setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.loaded);
      if(_listVoucherPulsaByPrefixData.length == 0) {
        setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.empty);
      } 
    } on DioError catch(_) {
      setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.error);
    } catch(e) {
      print(e);
    }
  } 

  void getVA(context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_VA}");
      VAModel pilihPembayaranModel = VAModel.fromJson(res.data);
      _listVa = [];
      List<VAData> vaData = pilihPembayaranModel.body;
      _listVa.addAll(vaData);
      setStateVAStatus(VaStatus.loaded);
      if(_listVa.length == 0) {
        setStateVAStatus(VaStatus.empty);
      }
    } on DioError catch(_) {  
      setStateVAStatus(VaStatus.error);
    } catch(e) {
      print(e);
    }
  }

  void getBalance(BuildContext context) async {
    try {
      setStateBalanceStatus(BalanceStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_PPOB}/wallet/balance");
      BalanceModel balanceModel = BalanceModel.fromJson(res.data);
      balance = balanceModel.body?.balance;
      setStateBalanceStatus(BalanceStatus.loaded);
    } on DioError catch(_) {
      setStateBalanceStatus(BalanceStatus.error);
    } catch(e) {
      setStateBalanceStatus(BalanceStatus.error);
      print(e);
    }
  }

  Future getHistoryBalance(BuildContext context, String startDate, String endDate) async {
    try {
      setStateHistoryBalanceStatus(HistoryBalanceStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      FormData formData = FormData.fromMap({
        "start": startDate,
        "end": endDate,
        "sort": "created,desc"
      });
      Response res = await dio.post("${AppConstants.BASE_URL_PPOB}/wallet/history", data: formData);
      _historyBalanceData = [];
      HistoryBalanceModel historyBalanceModel = HistoryBalanceModel.fromJson(res.data);
      List<HistoryBalanceData> historyBalanceData = historyBalanceModel.body;
      _historyBalanceData.addAll(historyBalanceData);
      setStateHistoryBalanceStatus(HistoryBalanceStatus.loaded);
      if(_historyBalanceData.length == 0) {
        setStateHistoryBalanceStatus(HistoryBalanceStatus.empty);
      }
    } on DioError catch(_) {
      setStateHistoryBalanceStatus(HistoryBalanceStatus.error);
    } catch(e) {
      setStateHistoryBalanceStatus(HistoryBalanceStatus.error);
      print(e); 
    }
  }

  Future getDenomDisbursement(BuildContext context)  async {
    setStateDenomDisbursementStatus(DenomDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_DISBURSEMENT_DENOM}");
      DenomDisbursementModel denomDisbursementModel = DenomDisbursementModel.fromJson(res.data);
      _denomDisbursement = [];
      List<DenomDisbursementBody> denomDisbursement = denomDisbursementModel.body;
      _denomDisbursement.addAll(denomDisbursement);
      setStateDenomDisbursementStatus(DenomDisbursementStatus.loaded);
      if(denomDisbursement.isEmpty) {
        setStateDenomDisbursementStatus(DenomDisbursementStatus.empty);
      } 
    } on DioError catch(e) {
      setStateDenomDisbursementStatus(DenomDisbursementStatus.error);
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } catch(e) {
      setStateDenomDisbursementStatus(DenomDisbursementStatus.error);
      print(e);
    }
  }

  Future getBankDisbursement(BuildContext context) async {
    setStateBankDisbursementStatus(BankDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_DISBURSEMENT_BANK}");
      BankDisbursementModel bankDisbursementModel = BankDisbursementModel.fromJson(res.data);
      _bankDisbursement = [];
      List<BankDisbursementBody> listBankDisbursement = bankDisbursementModel.body;
      _bankDisbursement.addAll(listBankDisbursement);
      setStateBankDisbursementStatus(BankDisbursementStatus.loaded);
    } catch(e) {
      print(e);
    }
  }

  Future getEmoneyDisbursement(BuildContext context) async {
    setStateEmoneyDisbursementStatus(EmoneyDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.BASE_URL_DISBURSEMENT_EMONEY}");
      EmoneyDisbursementModel emoneyDisbursementModel = EmoneyDisbursementModel.fromJson(res.data);
      _emoneyDisbursement = [];
      List<EmoneyDisbursementBody> listEmoneyDisbursement = emoneyDisbursementModel.body;
      _emoneyDisbursement.addAll(listEmoneyDisbursement);
      setStateEmoneyDisbursementStatus(EmoneyDisbursementStatus.loaded);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } catch(e) {
      print(e);
    }
  }

  Future inquiryDisbursement(BuildContext context, int amount) async {
    setStateDisbursementStatus(InquiryDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_DISBURSEMENT}/disbursement/inquiry", data: {
        "amount": amount
      });
      InquiryDisbursementModel inquiryDisbursementModel = InquiryDisbursementModel.fromJson(res.data);
      InquiryDisbursementBody inquiryDisbursementBody = inquiryDisbursementModel.body;
      setStateDisbursementStatus(InquiryDisbursementStatus.loaded);
      return inquiryDisbursementBody;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      setStateDisbursementStatus(InquiryDisbursementStatus.error);
      if(e?.response?.statusCode == 400)
        setStateDisbursementStatus(InquiryDisbursementStatus.error);
        if(e?.response?.data["code"] == 411) 
          throw ServerErrorException("Insufficient wallet funds. Your Balance : ${ConnexistHelper.formatCurrency(double.parse(balance.toString()))}");
        else 
          throw ServerErrorException(e?.response?.data["message"]);
    } catch(e) {
      setStateDisbursementStatus(InquiryDisbursementStatus.error);
      print(e);
    }
  }

  Future submitDisbursement(BuildContext context, String token) async {
    setStateSubmitDisbursementStatus(SubmitDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.BASE_URL_DISBURSEMENT}/disbursement/submit", data: {
        "destAccount": getGlobalPaymentAccount,
        "destBank": getGlobalPaymentMethodCode
      }, options: Options(
        headers: {
          "x-request-token": token
        }
      ));
      SubmitDisbursementModel submitDisbursementModel = SubmitDisbursementModel.fromJson(res.data);
      SubmitDisbursementBody submitDisbursementBody = submitDisbursementModel.body;
      setStateSubmitDisbursementStatus(SubmitDisbursementStatus.loaded);
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => CashOutSuccessScreen()));
      return submitDisbursementBody;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
      setStateSubmitDisbursementStatus(SubmitDisbursementStatus.error);
      if(e?.response?.statusCode == 400)
        setStateSubmitDisbursementStatus(SubmitDisbursementStatus.error);
        if(e?.response?.data["code"] == 411)
          throw ServerErrorException(e?.response?.data["message"]);
        else 
          throw ServerErrorException(e?.response?.data["message"]);
    } catch(e) {
      setStateSubmitDisbursementStatus(SubmitDisbursementStatus.error);
      print(e);
    } 
  }
    
}