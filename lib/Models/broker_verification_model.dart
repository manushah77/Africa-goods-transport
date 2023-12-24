class broker_verification_model {
  String? status;
  int? code;
  User? user;
  BrokerData? data;
  String? message;

  broker_verification_model(
      {this.status, this.code, this.user, this.data, this.message});

  broker_verification_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    data = json['data'] != null ? new BrokerData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? phoneNo;
  String? personStatus;
  String? isVerified;
  String? isCompleted;
  String? imageUrl;
  String? otp;
  String? isRequested;
  String? email;
  int? status;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
        this.name,
        this.phoneNo,
        this.personStatus,
        this.isVerified,
        this.isCompleted,
        this.imageUrl,
        this.otp,
        this.isRequested,
        this.email,
        this.status,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNo = json['phoneNo'];
    personStatus = json['personStatus'];
    isVerified = json['isVerified'];
    isCompleted = json['isCompleted'];
    imageUrl = json['imageUrl'];
    otp = json['otp'];
    isRequested = json['isRequested'];
    email = json['email'];
    status = json['status'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phoneNo'] = this.phoneNo;
    data['personStatus'] = this.personStatus;
    data['isVerified'] = this.isVerified;
    data['isCompleted'] = this.isCompleted;
    data['imageUrl'] = this.imageUrl;
    data['otp'] = this.otp;
    data['isRequested'] = this.isRequested;
    data['email'] = this.email;
    data['status'] = this.status;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class BrokerData {
  int? id;
  String? userId;
  String? address;
  String? companyName;
  String? phoneOpt;
  String? ntn;
  String? managerName;
  String? managerNo1;
  String? managerNo2;
  String? visitingUrl;
  String? workingForum;
  String? createdAt;
  String? updatedAt;

  BrokerData(
      {this.id,
        this.userId,
        this.address,
        this.companyName,
        this.phoneOpt,
        this.ntn,
        this.managerName,
        this.managerNo1,
        this.managerNo2,
        this.visitingUrl,
        this.workingForum,
        this.createdAt,
        this.updatedAt});

  BrokerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    address = json['address'];
    companyName = json['company_name'];
    phoneOpt = json['phoneOpt'];
    ntn = json['ntn'];
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
