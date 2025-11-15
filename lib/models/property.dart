class Propertybase {
  List<Properties>? properties;

  Propertybase({this.properties});

  Propertybase.fromJson(Map<String, dynamic> json) {
    if (json['properties'] != null) {
      properties = <Properties>[];
      json['properties'].forEach((v) {
        properties!.add(new Properties.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.properties != null) {
      data['properties'] = this.properties!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Properties {
  int? id;
  String? createdAt;
  int? locationid;
  int? price;
  bool? residential;
  String? date;
  int? advance;
  bool? sharing;
  int? peoples;
  bool? rent;
  bool? query;
  int? toPrice;
  String? description;
  int? status;
  String? locationName;
  int? userid;
  String? username;
  int? phoneNumber;
  String? imageurl;
  String? imageurl2;
  String? title;

  Properties({
    this.id,
    this.createdAt,
    this.locationid,
    this.price,
    this.residential,
    this.date,
    this.advance,
    this.sharing,
    this.peoples,
    this.rent,
    this.query,
    this.toPrice,
    this.description,
    this.status,
    this.locationName,
    this.userid,
    this.username,
    this.phoneNumber,
    this.imageurl,
    this.title,
  });

  Properties.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    locationid = json['locationid'];
    price = json['price'];
    residential = json['residential'];
    date = json['date'];
    advance = json['advance'];
    sharing = json['sharing'];
    peoples = json['peoples'];
    rent = json['rent'];
    query = json['query'];
    toPrice = json['to_price'];
    description = json['description'];
    status = json['status'];
    locationName = json['location_name'];
    userid = json['userid'];
    username = json['username'];
    phoneNumber = json['phone_number'];
    imageurl = json['imageurl'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    if (createdAt != null) {
      data['created_at'] = createdAt;
    }
    if (locationid != null) {
      data['locationid'] = locationid;
    }
    if (price != null) {
      data['price'] = price;
    }
    if (residential != null) {
      data['residential'] = residential;
    }
    if (date != null) {
      data['date'] = date;
    }
    if (advance != null) {
      data['advance'] = advance;
    }
    if (sharing != null) {
      data['sharing'] = sharing;
    }
    if (peoples != null) {
      data['peoples'] = peoples;
    }
    if (rent != null) {
      data['rent'] = rent;
    }
    if (query != null) {
      data['query'] = query;
    }
    if (toPrice != null) {
      data['to_price'] = toPrice;
    }
    if (description != null) {
      data['description'] = description;
    }
    if (status != null) {
      data['status'] = status;
    }
    if (locationName != null) {
      data['location_name'] = locationName;
    }
    if (userid != null) {
      data['userid'] = userid;
    }
    if (username != null) {
      data['username'] = username;
    }
    if (phoneNumber != null) {
      data['phone_number'] = phoneNumber;
    }
    if (imageurl != null) {
      data['imageurl'] = imageurl;
    }
    if (title != null) {
      data['title'] = title;
    }
    return data;
  }
}
