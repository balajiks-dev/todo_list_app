class FailureResponseModel {
  final bool? status;
  final String? message;

  FailureResponseModel({this.status, this.message});

  factory FailureResponseModel.fromJson(Map<String, dynamic> json) {
    return FailureResponseModel(
        status: json['status'], message: json['message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
