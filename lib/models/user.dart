class User {
  final String firebaseId;
  final String name;
  final String email;
  final String houseCode;

  User(this.firebaseId, this.name, this.email, [this.houseCode]);

  User.fromJson(Map<String, dynamic> json)
      : firebaseId = json['firebaseId'],
        name = json['name'],
        email = json['email'],
        houseCode = json['houseCode'];

  Map<String, dynamic> toJson() => {
        "firebaseId": firebaseId,
        "name": name,
        "email": email,
        "houseCode": houseCode
      };
}
