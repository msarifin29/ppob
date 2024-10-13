import 'package:equatable/equatable.dart';

class TransactionResponse extends Equatable {
  final List<TransactionRecord> records;
  final int offset;
  final int limit;
  const TransactionResponse({
    required this.records,
    required this.offset,
    required this.limit,
  });
  @override
  List<Object> get props => [records, offset, limit];

  TransactionResponse copyWith({
    List<TransactionRecord>? records,
    int? offset,
    int? limit,
  }) {
    return TransactionResponse(
      records: records ?? this.records,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'records': records.map((x) => x.toJson()).toList(),
      'offset': offset,
      'limit': limit,
    };
  }

  factory TransactionResponse.fromJson(Map<String, dynamic> map) {
    return TransactionResponse(
      records: List<TransactionRecord>.from(
        (map['records'] as List<dynamic>).map<TransactionRecord>(
          (x) => TransactionRecord.fromJson(x as Map<String, dynamic>),
        ),
      ),
      offset: map['offset'] is String
          ? int.tryParse(map['offset'] as String) ?? 0
          : map['offset'] as int,
      limit:
          map['limit'] is String ? int.tryParse(map['limit'] as String) ?? 0 : map['limit'] as int,
    );
  }

  @override
  bool get stringify => true;
}

class TransactionRecord extends Equatable {
  final String invoiceNumber;
  final String transactionType;
  final String description;
  final int totalAmount;
  final String createdOn;

  const TransactionRecord({
    required this.invoiceNumber,
    required this.transactionType,
    required this.description,
    required this.totalAmount,
    required this.createdOn,
  });

  @override
  List<Object> get props {
    return [
      invoiceNumber,
      transactionType,
      description,
      totalAmount,
      createdOn,
    ];
  }

  @override
  bool get stringify => true;

  TransactionRecord copyWith({
    String? invoiceNumber,
    String? transactionType,
    String? description,
    int? totalAmount,
    String? createdOn,
  }) {
    return TransactionRecord(
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      transactionType: transactionType ?? this.transactionType,
      description: description ?? this.description,
      totalAmount: totalAmount ?? this.totalAmount,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'invoice_number': invoiceNumber,
      'transaction_type': transactionType,
      'description': description,
      'total_amount': totalAmount,
      'created_on': createdOn,
    };
  }

  factory TransactionRecord.fromJson(Map<String, dynamic> map) {
    return TransactionRecord(
      invoiceNumber: map['invoice_number'] as String,
      transactionType: map['transaction_type'] as String,
      description: map['description'] as String,
      totalAmount: map['total_amount'] is String
          ? int.tryParse(map['total_amount'] as String) ?? 0 // Handle string that can be parsed
          : map['total_amount'] as int,
      createdOn: map['created_on'] as String,
    );
  }
}
