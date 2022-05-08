// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

Shop shopFromJson(String str) => Shop.fromJson(json.decode(str));

String shopToJson(Shop data) => json.encode(data.toJson());

class Shop {

  Shop({
    required this.address,
    required this.alias,
    required this.countryCode,
    required this.location,
    required this.phone,
    this.zipCode,
  });

  String phone;
  String address;
  String alias;
  String countryCode;
  Map<String, dynamic> location;
  int? zipCode;

  Shop copyWith({
    required String address,
    required String alias,
    required String countryCode,
    required String phone,
    required Map<String, dynamic> location,
    int? zipCode,
  }) =>
      Shop(
          phone: phone,
          address: address,
          alias: alias,
          countryCode: countryCode,
          location: location,
          zipCode: zipCode ?? this.zipCode,
      );

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
    address: json["address"],
    alias: json["alias"],
    countryCode: json["country_code"],
    location: {
      "lng": json["location"]["lng"],
      "lat": json["location"]["lat"]
    },
    phone: json["phone"],
    zipCode: json["zipcode"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "alias": alias,
    "country_code": countryCode,
    "location": {"lat": location["lat"], "lng": location["lng"]},
    "phone": phone,
    "zipcode": zipCode,
  };
}
