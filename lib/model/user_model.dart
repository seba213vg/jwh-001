class UserModel {
  final String name;
  final String email;
  final String bio;
  final String link;
  final String uid;
  final String photoUrl;
  final double volume;
  final double textsize;
  final bool notification;

  UserModel({
    required this.name,
    required this.bio,
    required this.email,
    required this.link,
    required this.uid,
    required this.photoUrl,
    required this.volume,
    required this.textsize,
    required this.notification,
  });

  UserModel.empty()
    : uid = "",
      email = "",
      name = "",
      bio = "",
      link = "",
      photoUrl = "",
      volume = 1.0,
      textsize = 1.0,
      notification = true;

  UserModel.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      email = json['email'],
      bio = json['bio'],
      link = json['link'],
      uid = json['uid'],
      photoUrl = json['photoUrl'],
      volume = (json['volume'] as num?)?.toDouble() ?? 1.0,
      textsize = (json['textsize'] as num?)?.toDouble() ?? 1.0,
      notification = json['notification'] ?? true;

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "link": link,
      "bio": bio,
      "photoUrl": photoUrl,
      "volume": volume,
      "textsize": textsize,
      "notification": notification,
    };
  }
}
