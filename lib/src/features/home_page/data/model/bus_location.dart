import 'package:freezed_annotation/freezed_annotation.dart';

part 'bus_location.freezed.dart';
part 'bus_location.g.dart';

@freezed
class BusLocationModel with _$BusLocationModel{
  BusLocationModel._();

  factory BusLocationModel({
    @JsonKey(name : "id")required int id,
    @JsonKey(name: 'bus_id') required int busId,
    @JsonKey(name : "latitude")required String latitude,
    @JsonKey(name : "longitude")required String longitude,
    @JsonKey(name: "time")required String time,
    @JsonKey(name: 'created_at') required String? createdAt,
    @JsonKey(name: 'updated_at') required String? updatedAt,
}) = _BusLocationModel;

  factory BusLocationModel.fromJson(Map<String,dynamic> json) => _$BusLocationModelFromJson(json);
}