class ExploreModel {
  final String name;
  final double latitude;
  final double longitude;
  final String type;
  final String? description;
  final String? imageUrl;

  ExploreModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.description,
    this.imageUrl,
  });
}
