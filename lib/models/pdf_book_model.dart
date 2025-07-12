class PdfBook {
  final String? id;
  final String? title;
  final String? url;
  bool? isLocked;
  final num? requiredPoint;
  DateTime? createdAt;

  PdfBook({
    this.id,
    this.title,
    this.url,
    this.isLocked,
    this.requiredPoint,
    this.createdAt
  });

  // Factory constructor to create a PdfBook from a Map
  factory PdfBook.fromMap(Map<String, dynamic> map) {
    return PdfBook(
      id: map['id'] as String?,
      title: map['title'] as String?,
      url: map['url'] as String?,
      isLocked: map['isLocked'] as bool?,
      requiredPoint: map['requiredPoint'] as num?,
      createdAt: map['createdAt']?.toDate(),
    );
  }

  // Convert PdfBook to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'url': url,
      'requiredPoint': requiredPoint,
    };
  }

  // CopyWith method
  PdfBook copyWith({
    String? id,
    String? title,
    String? url,
    bool? isLocked,
    num? requiredPoint,
    DateTime? createdAt,
  }) {
    return PdfBook(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      isLocked: isLocked ?? this.isLocked,
      requiredPoint: requiredPoint ?? this.requiredPoint,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}