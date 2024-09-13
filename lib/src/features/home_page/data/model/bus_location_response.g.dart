// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_location_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusLocationResponseImpl _$$BusLocationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$BusLocationResponseImpl(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => BusLocationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BusLocationResponseImplToJson(
        _$BusLocationResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };
