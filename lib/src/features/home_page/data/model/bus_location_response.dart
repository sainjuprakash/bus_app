import 'package:bus_app/src/features/home_page/data/model/bus_location.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bus_location_response.freezed.dart';
part 'bus_location_response.g.dart';

@freezed
class BusLocationResponse with _$BusLocationResponse {
  const factory BusLocationResponse({
    @JsonKey(name: "success") required bool success,
    @JsonKey(name: "data") required List<BusLocationModel> data,
  }) = _BusLocationResponse;

  factory BusLocationResponse.fromJson(Map<String, dynamic> json) =>
      _$BusLocationResponseFromJson(json);
}
