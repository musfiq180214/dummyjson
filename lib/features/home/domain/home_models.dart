// domain/location_update.dart
class PlacemarkData {
  final String? street;
  final String? subLocality;
  final String? locality;
  final String? administrativeArea;
  final String? postalCode;
  final String? country;
  final String? name;
  final String? isoCountryCode;
  final String? subAdministrativeArea;
  final String? subThoroughfare;
  final String? thoroughfare;

  PlacemarkData({
    this.street,
    this.subLocality,
    this.locality,
    this.administrativeArea,
    this.postalCode,
    this.country,
    this.name,
    this.isoCountryCode,
    this.subAdministrativeArea,
    this.subThoroughfare,
    this.thoroughfare,
  });

  factory PlacemarkData.fromJson(Map<String, dynamic> json) => PlacemarkData(
    street: json['street'],
    subLocality: json['subLocality'],
    locality: json['locality'],
    administrativeArea: json['administrativeArea'],
    postalCode: json['postalCode'],
    country: json['country'],
    name: json['name'],
    isoCountryCode: json['isoCountryCode'],
    subAdministrativeArea: json['subAdministrativeArea'],
    subThoroughfare: json['subThoroughfare'],
    thoroughfare: json['thoroughfare'],
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "subLocality": subLocality,
    "locality": locality,
    "administrativeArea": administrativeArea,
    "postalCode": postalCode,
    "country": country,
    "name": name,
    "isoCountryCode": isoCountryCode,
    "subAdministrativeArea": subAdministrativeArea,
    "subThoroughfare": subThoroughfare,
    "thoroughfare": thoroughfare,
  };
}

class LocationUpdate {
  final double latitude;
  final double longitude;
  final PlacemarkData placemark;

  LocationUpdate({
    required this.latitude,
    required this.longitude,
    required this.placemark,
  });

  factory LocationUpdate.fromJson(Map<String, dynamic> json) => LocationUpdate(
    latitude: json['latitude'],
    longitude: json['longitude'],
    placemark: PlacemarkData.fromJson(json['placemark']),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "placemark": placemark.toJson(),
  };
}

// domain/user.dart
class User {
  final int id;
  final String username;
  final String email;

  User({required this.id, required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json['id'], username: json['username'], email: json['email']);

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
  };
}
