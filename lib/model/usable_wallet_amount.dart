class UsableWalletAmount {
  String?  success;
  String?  name;
  String?  img;
  String?  city;
  String?  cat;
  String?  star;
  String?  today;
  String?  month;
  String?  todayc;
  String?  monthc;
  String?  products;
  String?  categories;
  String?  users;
  String?  sms;
  String?  pages;
  String?  blogs;
  String?  images;
  String?  leads;
  String?  reviews;
  String?  faq;
  String?  address;
  String?  contactPerson;
  String?  pincode;
  String?  description;
  String?  mobileNo;
  String?  emailId;
  String?  upi;
  String?  dearning;
  String?  walletCanBeUsed;

  UsableWalletAmount(
      {this.success,
        this.name,
        this.img,
        this.city,
        this.cat,
        this.star,
        this.today,
        this.month,
        this.todayc,
        this.monthc,
        this.products,
        this.categories,
        this.users,
        this.sms,
        this.pages,
        this.blogs,
        this.images,
        this.leads,
        this.reviews,
        this.faq,
        this.address,
        this.contactPerson,
        this.pincode,
        this.description,
        this.mobileNo,
        this.emailId,
        this.upi,
        this.dearning,
        this.walletCanBeUsed});

  UsableWalletAmount.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    name = json['name'];
    img = json['img'];
    city = json['city'];
    cat = json['cat'];
    star = json['star'];
    today = json['today'];
    month = json['month'];
    todayc = json['todayc'];
    monthc = json['monthc'];
    products = json['products'];
    categories = json['categories'];
    users = json['users'];
    sms = json['sms'];
    pages = json['pages'];
    blogs = json['blogs'];
    images = json['images'];
    leads = json['leads'];
    reviews = json['reviews'];
    faq = json['faq'];
    address = json['address'];
    contactPerson = json['contact_person'];
    pincode = json['pincode'];
    description = json['description'];
    mobileNo = json['mobile_no'];
    emailId = json['email_id'];
    upi = json['upi'];
    dearning = json['dearning'];
    walletCanBeUsed = json['wallet_can_be_used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['name'] = this.name;
    data['img'] = this.img;
    data['city'] = this.city;
    data['cat'] = this.cat;
    data['star'] = this.star;
    data['today'] = this.today;
    data['month'] = this.month;
    data['todayc'] = this.todayc;
    data['monthc'] = this.monthc;
    data['products'] = this.products;
    data['categories'] = this.categories;
    data['users'] = this.users;
    data['sms'] = this.sms;
    data['pages'] = this.pages;
    data['blogs'] = this.blogs;
    data['images'] = this.images;
    data['leads'] = this.leads;
    data['reviews'] = this.reviews;
    data['faq'] = this.faq;
    data['address'] = this.address;
    data['contact_person'] = this.contactPerson;
    data['pincode'] = this.pincode;
    data['description'] = this.description;
    data['mobile_no'] = this.mobileNo;
    data['email_id'] = this.emailId;
    data['upi'] = this.upi;
    data['dearning'] = this.dearning;
    data['wallet_can_be_used'] = this.walletCanBeUsed;
    return data;
  }
}
