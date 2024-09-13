// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bus_location_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BusLocationResponse _$BusLocationResponseFromJson(Map<String, dynamic> json) {
  return _BusLocationResponse.fromJson(json);
}

/// @nodoc
mixin _$BusLocationResponse {
  @JsonKey(name: "success")
  bool get success => throw _privateConstructorUsedError;
  @JsonKey(name: "data")
  List<BusLocationModel> get data => throw _privateConstructorUsedError;

  /// Serializes this BusLocationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusLocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusLocationResponseCopyWith<BusLocationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusLocationResponseCopyWith<$Res> {
  factory $BusLocationResponseCopyWith(
          BusLocationResponse value, $Res Function(BusLocationResponse) then) =
      _$BusLocationResponseCopyWithImpl<$Res, BusLocationResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: "success") bool success,
      @JsonKey(name: "data") List<BusLocationModel> data});
}

/// @nodoc
class _$BusLocationResponseCopyWithImpl<$Res, $Val extends BusLocationResponse>
    implements $BusLocationResponseCopyWith<$Res> {
  _$BusLocationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusLocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<BusLocationModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusLocationResponseImplCopyWith<$Res>
    implements $BusLocationResponseCopyWith<$Res> {
  factory _$$BusLocationResponseImplCopyWith(_$BusLocationResponseImpl value,
          $Res Function(_$BusLocationResponseImpl) then) =
      __$$BusLocationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "success") bool success,
      @JsonKey(name: "data") List<BusLocationModel> data});
}

/// @nodoc
class __$$BusLocationResponseImplCopyWithImpl<$Res>
    extends _$BusLocationResponseCopyWithImpl<$Res, _$BusLocationResponseImpl>
    implements _$$BusLocationResponseImplCopyWith<$Res> {
  __$$BusLocationResponseImplCopyWithImpl(_$BusLocationResponseImpl _value,
      $Res Function(_$BusLocationResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of BusLocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
  }) {
    return _then(_$BusLocationResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<BusLocationModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusLocationResponseImpl implements _BusLocationResponse {
  const _$BusLocationResponseImpl(
      {@JsonKey(name: "success") required this.success,
      @JsonKey(name: "data") required final List<BusLocationModel> data})
      : _data = data;

  factory _$BusLocationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusLocationResponseImplFromJson(json);

  @override
  @JsonKey(name: "success")
  final bool success;
  final List<BusLocationModel> _data;
  @override
  @JsonKey(name: "data")
  List<BusLocationModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'BusLocationResponse(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusLocationResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, success, const DeepCollectionEquality().hash(_data));

  /// Create a copy of BusLocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusLocationResponseImplCopyWith<_$BusLocationResponseImpl> get copyWith =>
      __$$BusLocationResponseImplCopyWithImpl<_$BusLocationResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusLocationResponseImplToJson(
      this,
    );
  }
}

abstract class _BusLocationResponse implements BusLocationResponse {
  const factory _BusLocationResponse(
          {@JsonKey(name: "success") required final bool success,
          @JsonKey(name: "data") required final List<BusLocationModel> data}) =
      _$BusLocationResponseImpl;

  factory _BusLocationResponse.fromJson(Map<String, dynamic> json) =
      _$BusLocationResponseImpl.fromJson;

  @override
  @JsonKey(name: "success")
  bool get success;
  @override
  @JsonKey(name: "data")
  List<BusLocationModel> get data;

  /// Create a copy of BusLocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusLocationResponseImplCopyWith<_$BusLocationResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
