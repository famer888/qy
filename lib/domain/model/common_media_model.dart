class CommonMediaModel {
  final int? id;
  final int? aff;
  final String? mediaCover;
  final String? mediaUrl;
  final int? thumbWidth;
  final int? thumbHeight;
  final int? relatedType;
  final int? relatedId;
  final int? mediaType;
  final int? status;
  final int? duration;
  final String? createdAt;
  final String? updatedAt;

  CommonMediaModel(
      {this.id,
      this.aff,
      this.mediaCover,
      this.mediaUrl,
      this.thumbWidth,
      this.thumbHeight,
      this.relatedType,
      this.relatedId,
      this.mediaType,
      this.status,
      this.duration,
      this.createdAt,
      this.updatedAt});

  factory CommonMediaModel.fromJson(Map<String, dynamic> json) {
    return CommonMediaModel(
      id: json['id'],
      aff: json['aff'],
      mediaCover: json['media_cover'],
      mediaUrl: json['media_url'],
      thumbWidth: json['thumb_width'],
      thumbHeight: json['thumb_height'],
      relatedType: json['related_type'],
      relatedId: json['related_id'],
      mediaType: json['media_type'],
      status: json['status'],
      duration: json['duration'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aff': aff,
      'media_cover': mediaCover,
      'media_url': mediaUrl,
      'thumb_width': thumbWidth,
      'thumb_height': thumbHeight,
      'related_type': relatedType,
      'related_id': relatedId,
      'media_type': mediaType,
      'status': status,
      'duration': duration,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
