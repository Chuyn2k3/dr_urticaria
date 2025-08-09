enum UserRole { doctor, nurse }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? specialization;
  final String? roomNumber;
  final String? department;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.specialization,
    this.roomNumber,
    this.department,
  });

  String get roleDisplayName {
    switch (role) {
      case UserRole.doctor:
        return 'Bác sĩ';
      case UserRole.nurse:
        return 'Y tá';
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
      ),
      specialization: json['specialization'],
      roomNumber: json['roomNumber'],
      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.toString().split('.').last,
      'specialization': specialization,
      'roomNumber': roomNumber,
      'department': department,
    };
  }
}
