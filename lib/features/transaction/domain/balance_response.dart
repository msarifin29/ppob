import 'package:equatable/equatable.dart';

class BalanceResponse extends Equatable {
  final int balance;
  const BalanceResponse({required this.balance});

  @override
  List<Object> get props => [balance];

  BalanceResponse copyWith({
    int? balance,
  }) {
    return BalanceResponse(
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'balance': balance,
    };
  }

  factory BalanceResponse.fromJson(Map<String, dynamic> map) {
    return BalanceResponse(
      balance: map['balance'] as int,
    );
  }

  @override
  bool get stringify => true;
}
