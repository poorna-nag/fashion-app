class PromotionBanner {
  String? shopId;
  String? images;
  bool ?status;
  String? msg;
  String? path;

  PromotionBanner({this.shopId, this.images, this.status, this.msg, this.path});

  PromotionBanner.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    images = json['images'];
    status = json['status'];
    msg = json['msg'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['images'] = this.images;
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['path'] = this.path;
    return data;
  }
}
