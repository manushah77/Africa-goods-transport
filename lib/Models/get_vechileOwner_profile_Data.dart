class get_VehicleOwner_data {
  String? status;
  int? code;
  Data? data;
  String? message;

  get_VehicleOwner_data(
      {this.status, this.code, this.data, this.message});

  get_VehicleOwner_data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;

    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}


class Data {
  int? id;
  String? userId;
  String? address;
  String? companyName;
  String? phoneOpt;
  String? ntn;
  String? companyType;
  String? managerName;
  String? managerNo1;
  String? managerNo2;
  String? visitingUrl;
  String? workingForum;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.userId,
        this.address,
        this.companyName,
        this.phoneOpt,
        this.ntn,
        this.companyType,
        this.managerName,
        this.managerNo1,
        this.managerNo2,
        this.visitingUrl,
        this.workingForum,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    address = json['address'];
    companyName = json['company_name'];
    phoneOpt = json['phoneOpt'];
    ntn = json['ntn'];
    companyType = json['company_type'];
    managerName = json['manager_name'];
    managerNo1 = json['managerNo1'];
    managerNo2 = json['managerNo2'];
    visitingUrl = json['visitingUrl'];
    workingForum = json['working_forum'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['address'] = this.address;
    data['company_name'] = this.companyName;
    data['phoneOpt'] = this.phoneOpt;
    data['ntn'] = this.ntn;
    data['company_type'] = this.companyType;
    data['manager_name'] = this.managerName;
    data['managerNo1'] = this.managerNo1;
    data['managerNo2'] = this.managerNo2;
    data['visitingUrl'] = this.visitingUrl;
    data['working_forum'] = this.workingForum;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
