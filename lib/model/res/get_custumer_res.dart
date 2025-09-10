// To parse this JSON data, do
//
//     final getCustumerRes = getCustumerResFromJson(jsonString);

import 'dart:convert';

GetCustumerRes getCustumerResFromJson(String str) => GetCustumerRes.fromJson(json.decode(str));

String getCustumerResToJson(GetCustumerRes data) => json.encode(data.toJson());

class GetCustumerRes {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    GetCustumerRes({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory GetCustumerRes.fromJson(Map<String, dynamic> json) => GetCustumerRes(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
    };
}
