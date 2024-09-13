// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bus_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BusLocationModel _$BusLocationModelFromJson(Map<String, dynamic> json) {
  return _BusLocationModel.fromJson(json);
}

/// @nodoc
mixin _$BusLocationModel {
  @JsonKey(name: "id")
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'bus_id')
  int get busId => throw _privateConstructorUsedError;
  @JsonKey(name: "latitude")
  String get latitude => throw _privateConstructorUsedError;
  @JsonKey(name: "longitude")
  String get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: "time")
  String get time => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BusLocationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusLocationModelCopyWith<BusLocationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusLocationModelCopyWith<$Res> {
  factory $BusLocationModelCopyWith(
          BusLocationModel value, $Res Function(BusLocationModel) then) =
      _$BusLocationModelCopyWithImpl<$Res, BusLocationModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int id,
      @JsonKey(name: 'bus_id') int busId,
      @JsonKey(name: "latitude") String latitude,
      @JsonKey(name: "longitude") String longitude,
      @JsonKey(name: "time") String time,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class _$BusLocationModelCopyWithImpl<$Res, $Val extends BusLocationModel>
    implements $BusLocationModelCopyWith<$Res> {
  _$BusLocationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? busId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? time = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      busId: null == busId
          ? _value.busId
          : busId // ignore: cast_nullable_to_non_nullable
              as int,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as String,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusLocationModelImplCopyWith<$Res>
    implements $BusLocationModelCopyWith<$Res> {
  factory _$$BusLocationModelImplCopyWith(_$BusLocationModelImpl value,
          $Res Function(_$BusLocationModelImpl) then) =
      __$$BusLocationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") int id,
      @JsonKey(name: 'bus_id') int busId,
      @JsonKey(name: "latitude") String latitude,
      @JsonKey(name: "longitude") String longitude,
      @JsonKey(name: "time") String time,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class __$$BusLocationModelImplCopyWithImpl<$Res>
    extends _$BusLocationModelCopyWithImpl<$Res, _$BusLocationModelImpl>
    implements _$$BusLocationModelImplCopyWith<$Res> {
  __$$BusLocationModelImplCopyWithImpl(_$BusLocationModelImpl _value,
      $Res Function(_$BusLocationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BusLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? busId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? time = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BusLocationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      busId: null == busId
          ? _value.busId
          : busId // ignore: cast_nullable_to_non_nullable
              as int,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as String,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusLocationModelImpl extends _BusLocationModel {
  _$BusLocationModelImpl(
      {@JsonKey(name: "id") required this.id,
      @JsonKey(name: 'bus_id') required this.busId,
      @JsonKey(name: "latitude") required this.latitude,
      @JsonKey(name: "longitude") required this.longitude,
      @JsonKey(name: "time") required this.time,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : super._();

  factory _$BusLocationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusLocationModelImplFromJson(json);

  @override
  @JsonKey(name: "id")
  final int id;
  @override
  @JsonKey(name: 'bus_id')
  final int busId;
  @override
  @JsonKey(name: "latitude")
  final String latitude;
  @override
  @JsonKey(name: "longitude")
  final String longitude;
  @override
  @JsonKey(name: "time")
  final String time;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'BusLocationModel(id: $id, busId: $busId, latitude: $latitude, longitude: $longitude, time: $time, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusLocationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.busId, busId) || other.busId == busId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, busId, latitude, longitude, time, createdAt, updatedAt);

  /// Create a copy of BusLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusLocationModelImplCopyWith<_$BusLocationModelImpl> get copyWith =>
      __$$BusLocationModelImplCopyWithImpl<_$BusLocationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusLocationModelImplToJson(
      this,
    );
  }
}

abstract class _BusLocationModel extends BusLocationModel {
  factory _BusLocationModel(
          {@JsonKey(name: "id") required final int id,
          @JsonKey(name: 'bus_id') required final int busId,
          @JsonKey(name: "latitude") required final String latitude,
          @JsonKey(name: "longitude") required final String longitude,
          @JsonKey(name: "time") required final String time,
          @JsonKey(name: 'created_at') required final String? createdAt,
          @JsonKey(name: 'updated_at') required final String? updatedAt}) =
      _$BusLocationModelImpl;
  _BusLocationModel._() : super._();

  factory _BusLocationModel.fromJson(Map<String, dynamic> json) =
      _$BusLocationModelImpl.fromJson;

  @override
  @JsonKey(name: "id")
  int get id;
  @override
  @JsonKey(name: 'bus_id')
  int get busId;
  @override
  @JsonKey(name: "latitude")
  String get latitude;
  @override
  @JsonKey(name: "longitude")
  String get longitude;
  @override
  @JsonKey(name: "time")
  String get time;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of BusLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusLocationModelImplCopyWith<_$BusLocationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
