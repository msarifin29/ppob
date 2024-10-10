class LoginResponse {
  final String token;
  LoginResponse({required this.token});

  LoginResponse copyWith({String? token}) {
    return LoginResponse(token: token ?? this.token);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'token': token};
  }

  factory LoginResponse.fromJson(Map<String, dynamic> map) {
    return LoginResponse(token: map['token'] as String);
  }

  @override
  String toString() => 'LoginResponse(token: $token)';

  @override
  bool operator ==(covariant LoginResponse other) {
    if (identical(this, other)) return true;

    return other.token == token;
  }

  @override
  int get hashCode => token.hashCode;
}
