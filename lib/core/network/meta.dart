class MetaResponse {
  int statusCode;
  String statusMsg;

  MetaResponse({required this.statusCode, required this.statusMsg});

  factory MetaResponse.fromJson(Map<String, dynamic> json) {
    return MetaResponse(statusCode: json['statusCode'] as int, statusMsg: json['statusMsg'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['statusMsg'] = statusMsg;
    return data;
  }
}
