// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusLocationModelImpl _$$BusLocationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BusLocationModelImpl(
      id: (json['id'] as num).toInt(),
      busId: (json['bus_id'] as num).toInt(),
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      time: json['time'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$BusLocationModelImplToJson(
        _$BusLocationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bus_id': instance.busId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'time': instance.time,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
