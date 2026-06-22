class User {
  final String id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String? avatarUrl;
  String? deliveryAddress;
  String? deliveryCity;
  String? deliveryInstructions;
  String? residence;
  String? buildingNumber;
  String? floor;
  String? apartment;
  double? latitude;
  double? longitude;

  User({
    required this.id,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.avatarUrl,
    this.deliveryAddress,
    this.deliveryCity,
    this.deliveryInstructions,
    this.residence,
    this.buildingNumber,
    this.floor,
    this.apartment,
    this.latitude,
    this.longitude,
  });

  String get fullName => '$firstName $lastName';

  bool get hasAddress => deliveryAddress != null && deliveryAddress!.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'avatarUrl': avatarUrl,
    'deliveryAddress': deliveryAddress,
    'deliveryCity': deliveryCity,
    'deliveryInstructions': deliveryInstructions,
    'residence': residence,
    'buildingNumber': buildingNumber,
    'floor': floor,
    'apartment': apartment,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    firstName: json['firstName'] as String? ?? '',
    lastName: json['lastName'] as String? ?? '',
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    avatarUrl: json['avatarUrl'] as String?,
    deliveryAddress: json['deliveryAddress'] as String?,
    deliveryCity: json['deliveryCity'] as String?,
    deliveryInstructions: json['deliveryInstructions'] as String?,
    residence: json['residence'] as String?,
    buildingNumber: json['buildingNumber'] as String?,
    floor: json['floor'] as String?,
    apartment: json['apartment'] as String?,
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
  );
}
