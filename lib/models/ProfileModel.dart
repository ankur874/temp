class ProfileModel {
  List<Data>? data;

  ProfileModel({this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? about;
  String? address;
  String? description;
  String? email;
  String? messagingProduct;
  String? profilePictureUrl;
  List<String>? websites;
  String? vertical;

  Data(
      {this.about,
      this.address,
      this.description,
      this.email,
      this.messagingProduct,
      this.profilePictureUrl,
      this.websites,
      this.vertical});

  Data.fromJson(Map<String, dynamic> json) {
    about = json['about'];
    address = json['address'];
    description = json['description'];
    email = json['email'];
    messagingProduct = json['messaging_product'];
    profilePictureUrl = json['profile_picture_url'];
    websites = json['websites'];
    vertical = json['vertical'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about'] = this.about;
    data['address'] = this.address;
    data['description'] = this.description;
    data['email'] = this.email;
    data['messaging_product'] = this.messagingProduct;
    data['profile_picture_url'] = this.profilePictureUrl;
    data['websites'] = this.websites;
    data['vertical'] = this.vertical;
    return data;
  }
}
