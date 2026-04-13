class MembershipPlan {
  MembershipPlan({
    this.memId,
    this.shopId,
    this.l1,
    this.l2,
    this.l3,
    this.l4,
    this.l5,
    this.l6,
    this.l7,
    this.l8,
    this.l9,
    this.l10,
    this.joinBonus,
    this.joinFee,
    this.validity,
    this.name,
    this.description,
    this.types,
    this.xMemJoin,
    this.xMemJoinBunus,
    this.xTotalBuisness,
    this.xTotalBuisnessBonus,
    this.status,
    this.addedOn,
  });

  String? memId;
  String? shopId;
  String? l1;
  String? l2;
  String? l3;
  String? l4;
  String? l5;
  String? l6;
  String? l7;
  String? l8;
  String? l9;
  String? l10;
  String? joinBonus;
  String? joinFee;
  String? validity;
  String? name;
  String? description;
  String? types;
  String? xMemJoin;
  String? xMemJoinBunus;
  String? xTotalBuisness;
  String? xTotalBuisnessBonus;
  String? status;
  String? addedOn;

  factory MembershipPlan.fromJson(Map<String, dynamic> json) => MembershipPlan(
        memId: json["mem_id"],
        shopId: json["shop_id"],
        l1: json["l1"],
        l2: json["l2"],
        l3: json["l3"],
        l4: json["l4"],
        l5: json["l5"],
        l6: json["l6"],
        l7: json["l7"],
        l8: json["l8"],
        l9: json["l9"],
        l10: json["l10"],
        joinBonus: json["joinBonus"],
        joinFee: json["joinFee"],
        validity: json["validity"],
        name: json["name"],
        description: json["description"],
        types: json["types"],
        xMemJoin: json["xMemJoin"],
        xMemJoinBunus: json["xMemJoinBunus"],
        xTotalBuisness: json["xTotalBuisness"],
        xTotalBuisnessBonus: json["xTotalBuisnessBonus"],
        status: json["status"],
        addedOn: json["added_on"],
      );

  static List<MembershipPlan> getListFromJson(List<dynamic> list) {
    List<MembershipPlan> unitList =[];
    list.forEach((unit) => unitList.add(MembershipPlan.fromJson(unit)));
    return unitList;
  }
}
