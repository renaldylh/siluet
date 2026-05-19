class AttireItem {
  final String id;
  final String name;
  final String category; 
  final List<String> items;
  final String photoUrl;
  final List<String> mediaUrls; // List of multiple images and videos
  final String? model3dUrl;
  final String status;

  AttireItem({
    required this.id,
    required this.name,
    required this.category,
    required this.items,
    required this.photoUrl,
    required this.mediaUrls,
    this.model3dUrl,
    this.status = 'Tersedia',
  });
}

