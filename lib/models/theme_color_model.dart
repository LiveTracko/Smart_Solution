import 'dart:convert';

Themecolor themecolorFromJson(String str) =>
    Themecolor.fromJson(json.decode(str));

String themecolorToJson(Themecolor data) => json.encode(data.toJson());

class Themecolor {
  String telecallerId;
  String themeColor;

  Themecolor({
    required this.telecallerId,
    required this.themeColor,
  });

  factory Themecolor.fromJson(Map<String, dynamic> json) => Themecolor(
        telecallerId: json["telecaller_id"],
        themeColor: json["theme_color"],
      );

  Map<String, dynamic> toJson() => {
        "telecaller_id": telecallerId,
        "theme_color": themeColor,
      };
}
