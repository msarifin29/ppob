import 'package:equatable/equatable.dart';

class BannerResponse extends Equatable {
  final String bannerName;
  final String bannerImage;
  final String description;
  const BannerResponse({
    required this.bannerName,
    required this.bannerImage,
    required this.description,
  });
  @override
  List<Object> get props => [bannerName, bannerImage, description];

  BannerResponse copyWith({
    String? bannerName,
    String? bannerImage,
    String? description,
  }) {
    return BannerResponse(
      bannerName: bannerName ?? this.bannerName,
      bannerImage: bannerImage ?? this.bannerImage,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'banner_name': bannerName,
      'banner_image': bannerImage,
      'description': description,
    };
  }

  factory BannerResponse.fromJson(Map<String, dynamic> map) {
    return BannerResponse(
      bannerName: map['banner_name'] as String,
      bannerImage: map['banner_image'] as String,
      description: map['description'] as String,
    );
  }

  @override
  bool get stringify => true;
}
