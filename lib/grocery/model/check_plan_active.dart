class CheckPlanActive {
  String? success;
  String? message;
  String? name;
  String? email;
  String? address;
  String? city;
  String? wallet;
  String? membershipId;
  String? membershipName;
  String? membershipJoinBonus;
  String? membershipJoinFee;
  String? membershipValidity;
  String? membershipDescription;
  String? membershipDirectJoin;
  String? membershipDirectJoinAmnt;

  CheckPlanActive(
      {this.success,
      this.message,
      this.name,
      this.email,
      this.address,
      this.city,
      this.wallet,
      this.membershipId,
      this.membershipName,
      this.membershipJoinBonus,
      this.membershipJoinFee,
      this.membershipValidity,
      this.membershipDescription,
      this.membershipDirectJoin,
      this.membershipDirectJoinAmnt});

  CheckPlanActive.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    city = json['city'];
    wallet = json['wallet'];
    membershipId = json['membership_id'];
    membershipName = json['membership_name'];
    membershipJoinBonus = json['membership_joinBonus'];
    membershipJoinFee = json['membership_joinFee'];
    membershipValidity = json['membership_validity'];
    membershipDescription = json['membership_description'];
    membershipDirectJoin = json['membership_directJoin'];
    membershipDirectJoinAmnt = json['membership_directJoinAmnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['city'] = this.city;
    data['wallet'] = this.wallet;
    data['membership_id'] = this.membershipId;
    data['membership_name'] = this.membershipName;
    data['membership_joinBonus'] = this.membershipJoinBonus;
    data['membership_joinFee'] = this.membershipJoinFee;
    data['membership_validity'] = this.membershipValidity;
    data['membership_description'] = this.membershipDescription;
    data['membership_directJoin'] = this.membershipDirectJoin;
    data['membership_directJoinAmnt'] = this.membershipDirectJoinAmnt;
    return data;
  }
}
