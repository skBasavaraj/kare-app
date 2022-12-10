class loginInfo {
  String? token;
  String? error;
  String? id;
  String? message;
  String? name;
  String? email;
  String? address;
  String? city;
  String? state;
  String? lastName;
  String? photo;


  loginInfo(this.token, this.error, this.id, this.message, this.email,this.name,
      this.address, this.city, this.state, this.lastName, this.photo);

  loginInfo.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    error = json['error'];
    id = json['id'];
    message = json['message'];
    email = json['email'];
    name = json['name'];
    city = json['city'];
    state = json['state'];
    lastName = json['lastName'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['error'] = this.error;
    data['id'] = this.id;
    data['message'] = this.message;
    return data;
  }
}
