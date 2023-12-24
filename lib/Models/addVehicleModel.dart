class Vehicles {
  int? id;
  String? vehicle;
  String? type;
  String? regNo;
  String? modelYear;
  String? userId;
  String? vOwnerId;
  String? createdAt;
  String? updatedAt;

  Vehicles(
      {this.id,
        this.vehicle,
        this.type,
        this.regNo,
        this.modelYear,
        this.userId,
        this.vOwnerId,
        this.createdAt,
        this.updatedAt});

  Vehicles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicle = json['vehicle'];
    type = json['type'];
    regNo = json['regNo'];
    modelYear = json['model_year'];
    userId = json['userId'];
    vOwnerId = json['vOwnerId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicle'] = this.vehicle;
    data['type'] = this.type;
    data['regNo'] = this.regNo;
    data['model_year'] = this.modelYear;
    data['userId'] = this.userId;
    data['vOwnerId'] = this.vOwnerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}