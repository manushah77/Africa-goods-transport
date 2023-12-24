class signup_model {
  String? status;
  int? code;
  User? user;
  String? token;
  String? message;

  signup_model({this.status, this.code, this.user, this.token, this.message});

  signup_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    data['message'] = this.message;
    return data;
  }
}

class User {
  String? name;
  String? email;
  String? phoneNo;
  String? imageUrl;
  String? personStatus;
  String? isVerified;
  String? isCompleted;
  String? otp;
  String? isRequested;
  String? updatedAt;
  String? createdAt;
  int? id;

  User(
      {this.name,
        this.email,
        this.phoneNo,
        this.imageUrl,
        this.personStatus,
        this.isVerified,
        this.isCompleted,
        this.otp,
        this.isRequested,
        this.updatedAt,
        this.createdAt,
        this.id});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNo = json['phoneNo'];
    imageUrl = json['imageUrl'];
    personStatus = json['personStatus'];
    isVerified = json['isVerified'];
    isCompleted = json['isCompleted'];
    otp = json['otp'];
    isRequested = json['isRequested'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phoneNo'] = this.phoneNo;
    data['imageUrl'] = this.imageUrl;
    data['personStatus'] = this.personStatus;
    data['isVerified'] = this.isVerified;
    data['isCompleted'] = this.isCompleted;
    data['otp'] = this.otp;
    data['isRequested'] = this.isRequested;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}