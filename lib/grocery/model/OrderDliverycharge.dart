import 'package:flutter/cupertino.dart';

class DeliveryCharge {
  String? success;
  String? Min_Order;
  String? Fee;
  String? Gateway;
  String? COD;
  String? Insta_client_id;
  String? Insta_client_secret;
  String? razorpay_key;
  String? razorpay_sec;
  String? fast_price;
  String? fast_text;
  String? imGatway;
  String? rpGatway;
  String? per_km_fee;

  DeliveryCharge(
      this.success,
      this.Min_Order,
      this.Fee,
      this.Gateway,
      this.COD,
      this.Insta_client_id,
      this.Insta_client_secret,
      this.razorpay_key,
      this.razorpay_sec,
      this.fast_price,
      this.fast_text,
      this.imGatway,
      this.rpGatway,
      this.per_km_fee);

  factory DeliveryCharge.fromJson(dynamic json) {
    return DeliveryCharge(
        json['success'],
        json['Min_Order'],
        json['Fee'],
        json['Gateway'],
        json['COD'],
        json['Insta_client_id'],
        json['Insta_client_secret'],
        json['razorpay_key'],
        json['razorpay_sec'],
        json['fast_price'],
        json['fast_text'],
        json['im_gateway'],
        json['rp_gateway'],
        json['per_km_fee']);
  }
}
