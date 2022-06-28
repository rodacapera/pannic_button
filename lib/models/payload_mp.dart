// To parse this JSON data, do
//
//     final PayloadMp = PayloadMpFromJson(jsonString);

import 'dart:convert';

PayloadMp payloadMpFromJson(String str) => PayloadMp.fromJson(json.decode(str));

String payloadMpToJson(PayloadMp data) => json.encode(data.toJson());

class PayloadMp {
  PayloadMp({
    required this.title,
    required this.description,
    required this.quantity,
    required this.unit_price,
    required this.email,
    required this.app,
  });

  String title;
  String description;
  int? quantity;
  int? unit_price;
  String email;
  String app;

  factory PayloadMp.fromJson(Map<String, dynamic> json) => PayloadMp(
        title: json["title"],
        description: json["description"],
        quantity: json["quantity"],
        unit_price: json["unit_price"],
        email: json["email"],
        app: json["app"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "quantity": quantity,
        "unit_price": unit_price,
        "email": email,
        "app": app,
      };
}
