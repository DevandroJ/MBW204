
class VAModel {
  VAModel({
    this.code,
    this.message,
    this.count,
    this.first,
    this.body,
    this.error,
  });

  int code;
  String message;
  int count;
  bool first;
  List<VAData> body;
  dynamic error;

  factory VAModel.fromJson(Map<String, dynamic> json) => VAModel(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    count: json["count"] == null ? null : json["count"],
    first: json["first"] == null ? null : json["first"],
    body: json["body"] == null ? null : List<VAData>.from(json["body"].map((x) => VAData.fromJson(x))),
    error: json["error"],
  );

}

class VAData {
  VAData({
    this.channel,
    this.classId,
    this.guide,
    this.isDirect,
    this.name,
    this.paymentCode,
    this.paymentDescription,
    this.paymentGateway,
    this.paymentLogo,
    this.paymentName,
    this.paymentUrl,
    this.paymentUrlV2,
    this.totalAdminFee,
  });

  String channel;
  String classId;
  String guide;
  bool isDirect;
  String name;
  String paymentCode;
  String paymentDescription;
  String paymentGateway;
  String paymentLogo;
  String paymentName;
  String paymentUrl;
  String paymentUrlV2;
  double totalAdminFee;

  factory VAData.fromJson(Map<String, dynamic> json) => VAData(
    channel: json["channel"] == null ? null : json["channel"],
    classId: json["classId"] == null ? null : json["classId"],
    guide: json["guide"] == null ? null : json["guide"],
    isDirect: json["is_direct"] == null ? null : json["is_direct"],
    name: json["name"] == null ? null : json["name"],
    paymentCode: json["payment_code"] == null ? null : json["payment_code"],
    paymentDescription: json["payment_description"] == null ? null : json["payment_description"],
    paymentGateway: json["payment_gateway"] == null ? null : json["payment_gateway"],
    paymentLogo: json["payment_logo"] == null ? null : json["payment_logo"],
    paymentName: json["payment_name"] == null ? null : json["payment_name"],
    paymentUrl: json["payment_url"] == null ? null : json["payment_url"],
    paymentUrlV2: json["payment_url_v2"] == null ? null : json["payment_url_v2"],
    totalAdminFee: json["total_admin_fee"] == null ? null : json["total_admin_fee"],
  );
}
