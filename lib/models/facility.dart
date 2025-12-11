class Facility {
  const Facility({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.phone,
  });

  final String id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final String address;
  final String? phone;
}
