class Author {
  final int id;
  final dynamic profileImage;
  final bool isFake;
  final String username;
  final String name;
  final String? email;
  final String createdAt; // Change this to String
  final String updatedAt; // Change this to String

  Author({
    required this.id,
    this.profileImage,
    required this.isFake,
    required this.username,
    required this.name,
    this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      profileImage: json['profile_image'],
      isFake: json['is_fake'] == 1,
      username: json['username'],
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'], // Store as String
      updatedAt: json['updated_at'], // Store as String
    );
  }

  String? get profileImageUrl {
    if (profileImage is String) {
      return profileImage;
    } else if (profileImage is Map<String, dynamic>) {
      return profileImage['url'] as String?;
    }
    return null;
  }

  DateTime? get createdAtDateTime {
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      print('Error parsing date: $createdAt');
      return null;
    }
  }

  DateTime? get updatedAtDateTime {
    try {
      return DateTime.parse(updatedAt);
    } catch (e) {
      print('Error parsing date: $updatedAt');
      return null;
    }
  }
}