import 'package:equatable/equatable.dart';

class ServiceResponse extends Equatable {
  final String serviceCode;
  final String serviceName;
  final String serviceIcon;
  final int serviceTariff;
  const ServiceResponse({
    required this.serviceCode,
    required this.serviceName,
    required this.serviceIcon,
    required this.serviceTariff,
  });
  @override
  List<Object> get props => [serviceCode, serviceName, serviceIcon, serviceTariff];

  ServiceResponse copyWith({
    String? serviceCode,
    String? serviceName,
    String? serviceIcon,
    int? serviceTariff,
  }) {
    return ServiceResponse(
      serviceCode: serviceCode ?? this.serviceCode,
      serviceName: serviceName ?? this.serviceName,
      serviceIcon: serviceIcon ?? this.serviceIcon,
      serviceTariff: serviceTariff ?? this.serviceTariff,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'service_code': serviceCode,
      'service_name': serviceName,
      'service_icon': serviceIcon,
      'service_tariff': serviceTariff,
    };
  }

  factory ServiceResponse.fromJson(Map<String, dynamic> map) {
    return ServiceResponse(
      serviceCode: map['service_code'] as String,
      serviceName: map['service_name'] as String,
      serviceIcon: map['service_icon'] as String,
      serviceTariff: map['service_tariff'] as int,
    );
  }

  @override
  bool get stringify => true;
}
