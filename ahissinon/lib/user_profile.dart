class UserProfile {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final List<String> preferences;
  List<Map<String, dynamic>> orderHistory;

  UserProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.preferences,
    this.orderHistory = const [],
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    List<String>? preferences,
    List<Map<String, dynamic>>? orderHistory,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      preferences: preferences ?? this.preferences,
      orderHistory: orderHistory ?? this.orderHistory,
    );
  }
}