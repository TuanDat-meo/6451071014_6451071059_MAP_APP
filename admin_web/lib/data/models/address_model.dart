class AddressModel {
  String? id;
  String street;
  String city;
  String state;
  String zipCode;
  String country;

  AddressModel({
    this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
    'street': street,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'country': country,
  };

  factory AddressModel.fromJson(Map<String, dynamic> json, String docId) => AddressModel(
    id: docId,
    street: json['street'] ?? '',
    city: json['city'] ?? '',
    state: json['state'] ?? '',
    zipCode: json['zipCode'] ?? '',
    country: json['country'] ?? '',
  );
}
