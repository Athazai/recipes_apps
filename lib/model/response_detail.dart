import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

ResponseDetail responseDetailFromJson(String string) =>
    ResponseDetail.fromJson(jsonDecode(string));

class ResponseDetail {
  List<Map<String, dynamic>> meals;

  ResponseDetail({required this.meals});

  factory ResponseDetail.fromJson(Map<String, dynamic> json) => ResponseDetail(
      meals: List<Map<String, dynamic>>.from(json['meals'].map(
              (x) => Map.from(x).map((key, value) => MapEntry<String, dynamic>(key, value == null ? null : value)))));

  Map<String, dynamic> toJson() => {
        "meals": List<dynamic>.from(meals.map(
                (x) => Map.from(x).map((key, value) => MapEntry<String, dynamic>(key, value == null ? null : value))))
      };
}
