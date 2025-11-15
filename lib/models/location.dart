class Location {
  int? id;
  String? name;
  int? pincode;

  Location({this.id, this.name, this.pincode});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pincode'] = pincode;
    return data;
  }
}

class Locationbase {
  List<Location>? location;

  Locationbase({this.location});

  Locationbase.fromJson(Map<String, dynamic> json) {
    if (json['location'] != null) {
      location = <Location>[];
      json['location'].forEach((v) {
        location!.add(new Location.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
