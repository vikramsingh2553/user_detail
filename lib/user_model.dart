class UserModel {
  int? id;
  late final String? firstName;
  late final String? lastName;
  late final String? email;
  final String? imageUrl;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.imageUrl,
  });
  UserModel.fromJson(Map<String, dynamic> json, this.id, this.firstName, this.lastName, this.email, this.imageUrl) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    var avatar = json['avatar'];
  }

  get avatar => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['avatar'] = avatar;
    return data;
  }
}

class Support {
  String? url;
  String? text;

  Support({this.url, this.text});

  Support.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['text'] = text;
    return data;
  }
}