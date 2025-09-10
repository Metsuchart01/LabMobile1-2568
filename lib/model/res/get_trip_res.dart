// To parse this JSON data, do
//
//     final tripGetResponses = tripGetResponsesFromJson(jsonString);

import 'dart:convert';

List<TripGetResponses> tripGetResponsesFromJson(String str) =>
    List<TripGetResponses>.from(
      json.decode(str).map((x) => TripGetResponses.fromJson(x)),
    );

String tripGetResponsesToJson(List<TripGetResponses> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripGetResponses {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  TripGetResponses({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripGetResponses.fromJson(Map<String, dynamic> json) =>
      TripGetResponses(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
      );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "name": name,
    "country": country,
    "coverimage": coverimage,
    "detail": detail,
    "price": price,
    "duration": duration,
    "destination_zone": destinationZone,
  };
}
