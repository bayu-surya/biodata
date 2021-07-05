import 'dart:convert';

class Biodata {
  Biodata({
    this.id,
    this.name,
    this.address,
    this.birthDate,
    this.height,
    this.weight,
    this.photo,
  });

  String id;
  String name;
  String address;
  String birthDate;
  String height;
  String weight;
  String photo;

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "birth_date": birthDate,
    "height": height,
    "weight": weight,
    "photo": photo,
  };

  factory Biodata.fromJson(Map<dynamic, dynamic> json) => Biodata(
    id: json["id"].toString(),
    name: json["name"],
    address: json["address"],
    birthDate: json["birth_date"],
    height: json["height"],
    weight: json["weight"],
    photo: json["photo"],
  );

  List<Biodata> parseBiodata(String json) {
    if (json == null) {
      return [];
    }

    final List parsed = jsonDecode(json);
    return parsed.map((json) => Biodata.fromJson(json)).toList();
  }
}