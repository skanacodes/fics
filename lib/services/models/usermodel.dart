import 'dart:convert';

List<User> forestFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String forestToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  int id;
  int statusfetch;
  String fname;
  String lname;
  String email;
  String password;
  String roles;

  User(
      {this.id,
      this.email,
      this.fname,
      this.lname,
      this.password,
      this.roles,
      this.statusfetch});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': fname,
      'last_name': lname,
      'email': email,
      'password': password,
      'role': roles,
      'statusfetch': statusfetch
    };
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      fname: json["first_name"],
      lname: json["last_name"],
      email: json["email"],
      password: json["password"],
      roles: json["role"],
      statusfetch: json["statusfetch"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": fname,
        "last_name": lname,
        "email": email,
        "password": password,
        "role": roles,
        "statusfetch": statusfetch,
      };
}
