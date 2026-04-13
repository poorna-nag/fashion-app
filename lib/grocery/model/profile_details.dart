class ProfileDetails {
  bool? status;
  String? message;
  Data? data;
  int? total;

  ProfileDetails({this.status, this.message, this.data, this.total});

  ProfileDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class Data {
  List<Customers>? customers;

  Data({this.customers});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['customers'] != null) {
      customers = <Customers>[];
      json['customers'].forEach((v) {
        customers!.add(new Customers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customers != null) {
      data['customers'] = this.customers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customers {
  String? userId;
  String? name;
  String? email;
  String? address;
  String? address2;
  String? phone;
  String? city;
  String? state;
  String? country;
  String? regDate;
  String? username;
  String? password;
  String? pp;
  String? wallet;
  String? contacted;
  String? rated;
  String? likes;
  String? userType;
  String? franchise;
  String? shopId;
  String? pincode;
  String? prime;
  String? memPlanId;
  String? sponsor;
  String? pDate;
  String? pExpire;
  String? pFee;
  String? p1;
  String? p2;
  String? p3;
  String? p4;
  String? p5;
  String? p6;
  String? p7;
  String? p8;
  String? p9;
  String? p10;
  String? ref1;
  String? ref2;
  String? ref3;
  String? ref4;
  String? ref5;
  String? ref6;
  String? ref7;
  String? ref8;
  String? ref9;
  String? ref10;
  String? aname;
  String? anumber;
  String? bankname;
  String? bankbranch;
  String? ifsc;
  String? atype;
  String? withdrawl;
  String? aadhar;
  String? pan;
  String? aadharDoc;
  String? panDoc;
  String? dob;
  String? gst;
  String? sex;
  String? payForInstall;
  String? src;
  String? dlocation;
  String? loginType;
  String? lock;
  String? updateAdd;
  String? firebase;
  String? aadharImgF;
  String? aadharImgB;
  String? company;
  String? designation;
  String? phone2;
  String? height;
  String? weight;
  String? socialId;
  String? socialType;
  String? mlmCredits;
  String? mlmCreditRem;
  String? mlmLastCredit;
  String? fatherName;
  String? motherName;
  String? document;
  String? affiliateKey;
  String? transactionpass;
  String? extra1;
  String? extra2;
  String? upiid;

  Customers(
      {this.userId,
      this.name,
      this.email,
      this.address,
      this.address2,
      this.phone,
      this.city,
      this.state,
      this.country,
      this.regDate,
      this.username,
      this.password,
      this.pp,
      this.wallet,
      this.contacted,
      this.rated,
      this.likes,
      this.userType,
      this.franchise,
      this.shopId,
      this.pincode,
      this.prime,
      this.memPlanId,
      this.sponsor,
      this.pDate,
      this.pExpire,
      this.pFee,
      this.p1,
      this.p2,
      this.p3,
      this.p4,
      this.p5,
      this.p6,
      this.p7,
      this.p8,
      this.p9,
      this.p10,
      this.ref1,
      this.ref2,
      this.ref3,
      this.ref4,
      this.ref5,
      this.ref6,
      this.ref7,
      this.ref8,
      this.ref9,
      this.ref10,
      this.aname,
      this.anumber,
      this.bankname,
      this.bankbranch,
      this.ifsc,
      this.atype,
      this.withdrawl,
      this.aadhar,
      this.pan,
      this.aadharDoc,
      this.panDoc,
      this.dob,
      this.gst,
      this.sex,
      this.payForInstall,
      this.src,
      this.dlocation,
      this.loginType,
      this.lock,
      this.updateAdd,
      this.firebase,
      this.aadharImgF,
      this.aadharImgB,
      this.company,
      this.designation,
      this.phone2,
      this.height,
      this.weight,
      this.socialId,
      this.socialType,
      this.mlmCredits,
      this.mlmCreditRem,
      this.mlmLastCredit,
      this.fatherName,
      this.motherName,
      this.document,
      this.affiliateKey,
      this.transactionpass,
      this.extra1,
      this.extra2,
      this.upiid});

  Customers.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    address2 = json['address2'];
    phone = json['phone'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    regDate = json['reg_date'];
    username = json['username'];
    password = json['password'];
    pp = json['pp'];
    wallet = json['wallet'];
    contacted = json['contacted'];
    rated = json['rated'];
    likes = json['likes'];
    userType = json['user_type'];
    franchise = json['franchise'];
    shopId = json['shop_id'];
    pincode = json['pincode'];
    prime = json['prime'];
    memPlanId = json['mem_plan_id'];
    sponsor = json['sponsor'];
    pDate = json['p_date'];
    pExpire = json['p_expire'];
    pFee = json['p_fee'];
    p1 = json['p1'];
    p2 = json['p2'];
    p3 = json['p3'];
    p4 = json['p4'];
    p5 = json['p5'];
    p6 = json['p6'];
    p7 = json['p7'];
    p8 = json['p8'];
    p9 = json['p9'];
    p10 = json['p10'];
    ref1 = json['ref1'];
    ref2 = json['ref2'];
    ref3 = json['ref3'];
    ref4 = json['ref4'];
    ref5 = json['ref5'];
    ref6 = json['ref6'];
    ref7 = json['ref7'];
    ref8 = json['ref8'];
    ref9 = json['ref9'];
    ref10 = json['ref10'];
    aname = json['aname'];
    anumber = json['anumber'];
    bankname = json['bankname'];
    bankbranch = json['bankbranch'];
    ifsc = json['ifsc'];
    atype = json['atype'];
    withdrawl = json['withdrawl'];
    aadhar = json['aadhar'];
    pan = json['pan'];
    aadharDoc = json['aadhar_doc'];
    panDoc = json['pan_doc'];
    dob = json['dob'];
    gst = json['gst'];
    sex = json['sex'];
    payForInstall = json['pay_for_install'];
    src = json['src'];
    dlocation = json['dlocation'];
    loginType = json['login_type'];
    lock = json['lock'];
    updateAdd = json['update_add'];
    firebase = json['firebase'];
    aadharImgF = json['aadhar_img_f'];
    aadharImgB = json['aadhar_img_b'];
    company = json['company'];
    designation = json['designation'];
    phone2 = json['phone2'];
    height = json['height'];
    weight = json['weight'];
    socialId = json['social_id'];
    socialType = json['social_type'];
    mlmCredits = json['mlm_credits'];
    mlmCreditRem = json['mlm_credit_rem'];
    mlmLastCredit = json['mlm_last_credit'];
    fatherName = json['fatherName'];
    motherName = json['motherName'];
    document = json['document'];
    affiliateKey = json['affiliate_key'];
    transactionpass = json['transactionpass'];
    extra1 = json['extra1'];
    extra2 = json['extra2'];
    upiid = json['upiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['address2'] = this.address2;
    data['phone'] = this.phone;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['reg_date'] = this.regDate;
    data['username'] = this.username;
    data['password'] = this.password;
    data['pp'] = this.pp;
    data['wallet'] = this.wallet;
    data['contacted'] = this.contacted;
    data['rated'] = this.rated;
    data['likes'] = this.likes;
    data['user_type'] = this.userType;
    data['franchise'] = this.franchise;
    data['shop_id'] = this.shopId;
    data['pincode'] = this.pincode;
    data['prime'] = this.prime;
    data['mem_plan_id'] = this.memPlanId;
    data['sponsor'] = this.sponsor;
    data['p_date'] = this.pDate;
    data['p_expire'] = this.pExpire;
    data['p_fee'] = this.pFee;
    data['p1'] = this.p1;
    data['p2'] = this.p2;
    data['p3'] = this.p3;
    data['p4'] = this.p4;
    data['p5'] = this.p5;
    data['p6'] = this.p6;
    data['p7'] = this.p7;
    data['p8'] = this.p8;
    data['p9'] = this.p9;
    data['p10'] = this.p10;
    data['ref1'] = this.ref1;
    data['ref2'] = this.ref2;
    data['ref3'] = this.ref3;
    data['ref4'] = this.ref4;
    data['ref5'] = this.ref5;
    data['ref6'] = this.ref6;
    data['ref7'] = this.ref7;
    data['ref8'] = this.ref8;
    data['ref9'] = this.ref9;
    data['ref10'] = this.ref10;
    data['aname'] = this.aname;
    data['anumber'] = this.anumber;
    data['bankname'] = this.bankname;
    data['bankbranch'] = this.bankbranch;
    data['ifsc'] = this.ifsc;
    data['atype'] = this.atype;
    data['withdrawl'] = this.withdrawl;
    data['aadhar'] = this.aadhar;
    data['pan'] = this.pan;
    data['aadhar_doc'] = this.aadharDoc;
    data['pan_doc'] = this.panDoc;
    data['dob'] = this.dob;
    data['gst'] = this.gst;
    data['sex'] = this.sex;
    data['pay_for_install'] = this.payForInstall;
    data['src'] = this.src;
    data['dlocation'] = this.dlocation;
    data['login_type'] = this.loginType;
    data['lock'] = this.lock;
    data['update_add'] = this.updateAdd;
    data['firebase'] = this.firebase;
    data['aadhar_img_f'] = this.aadharImgF;
    data['aadhar_img_b'] = this.aadharImgB;
    data['company'] = this.company;
    data['designation'] = this.designation;
    data['phone2'] = this.phone2;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['social_id'] = this.socialId;
    data['social_type'] = this.socialType;
    data['mlm_credits'] = this.mlmCredits;
    data['mlm_credit_rem'] = this.mlmCreditRem;
    data['mlm_last_credit'] = this.mlmLastCredit;
    data['fatherName'] = this.fatherName;
    data['motherName'] = this.motherName;
    data['document'] = this.document;
    data['affiliate_key'] = this.affiliateKey;
    data['transactionpass'] = this.transactionpass;
    data['extra1'] = this.extra1;
    data['extra2'] = this.extra2;
    data['upiid'] = this.upiid;
    return data;
  }
}
