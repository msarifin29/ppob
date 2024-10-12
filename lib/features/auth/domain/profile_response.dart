import 'package:equatable/equatable.dart';

class ProfileResponse extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String profileImage;
  const ProfileResponse({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
  });
  @override
  List<Object> get props => [email, firstName, lastName, profileImage];

  ProfileResponse copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? profileImage,
  }) {
    return ProfileResponse(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'profile_image': profileImage,
    };
  }

  factory ProfileResponse.fromJson(Map<String, dynamic> map) {
    return ProfileResponse(
      email: map['email'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      profileImage: map['profile_image'] as String,
    );
  }

  @override
  bool get stringify => true;
}
