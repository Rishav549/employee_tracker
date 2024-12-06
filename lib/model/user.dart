class UserModel {
  final String qr;
  final String macID;
  final String name;
  final String phoneNumber;
  final String email;
  final String designation;

  UserModel({
    required this.qr,
    required this.macID,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.designation,
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(qr: json['qr'],
        macID: json['macID'],
        name: json['name'],
        phoneNumber: json['phone_number'],
        email: json['email'],
        designation: json['designation']
    );
  }

  Map<String, dynamic> toJson() {
    return{
      'qr': qr,
      'macID': macID,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'designation': designation
    };
  }
}
