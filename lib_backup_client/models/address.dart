class DeliveryAddress {
  String id;
  String label;
  String street;
  String city;
  String? postalCode;
  String? residence;
  String? buildingNumber;
  String? floor;
  String? apartment;
  String? instructions;
  double? latitude;
  double? longitude;
  bool isDefault;

  DeliveryAddress({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    this.postalCode,
    this.residence,
    this.buildingNumber,
    this.floor,
    this.apartment,
    this.instructions,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  String get fullAddress {
    final parts = <String>[];
    parts.add(street);
    parts.add(city);
    if (postalCode != null && postalCode!.isNotEmpty) {
      parts.add(postalCode!);
    }
    if (residence != null && residence!.isNotEmpty) {
      parts.add('Rés. $residence');
    }
    if (buildingNumber != null && buildingNumber!.isNotEmpty) {
      parts.add('Imm. $buildingNumber');
    }
    if (floor != null && floor!.isNotEmpty) {
      parts.add('Étage $floor');
    }
    if (apartment != null && apartment!.isNotEmpty) {
      parts.add('Appt $apartment');
    }
    return parts.join(', ');
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'street': street,
    'city': city,
    'postalCode': postalCode,
    'residence': residence,
    'buildingNumber': buildingNumber,
    'floor': floor,
    'apartment': apartment,
    'instructions': instructions,
    'latitude': latitude,
    'longitude': longitude,
    'isDefault': isDefault,
  };
}
