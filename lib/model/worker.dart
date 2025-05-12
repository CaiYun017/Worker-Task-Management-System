class Worker {
  /*//String? id;
  int id;
  String? full_name;
  String? email;
  String? password;
  String? phone;
  String? address;

  Worker({
    this.id,
    this.full_name,
    this.email,
    this.password,
    this.phone,
    this.address,
  });

  Worker.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      full_name = json['full_name'];
      email = json['email'];
      password = json['password'];
      phone = json['phone'];
      address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = full_name;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['address'] = address;
    return data;
  }*/
  
  int id;  // 修改为 int
  String full_name;
  String email;
  String password;
  String phone;
  String address;

  Worker({
    required this.id,
    required this.full_name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
  });

  // 将 JSON 数据转化为 Worker 对象
  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'],  // 这里 id 是 int 类型
      full_name: json['full_name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      address: json['address'],
    );
  }

}
