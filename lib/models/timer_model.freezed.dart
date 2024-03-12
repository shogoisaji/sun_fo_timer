// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TimerModel _$TimerModelFromJson(Map<String, dynamic> json) {
  return _TimerModel.fromJson(json);
}

/// @nodoc
mixin _$TimerModel {
  AppState get appState => throw _privateConstructorUsedError;
  int get settingMinutes => throw _privateConstructorUsedError;
  Duration get pauseAmount => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get pauseStartTime => throw _privateConstructorUsedError;
  DateTime? get pauseEndTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TimerModelCopyWith<TimerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimerModelCopyWith<$Res> {
  factory $TimerModelCopyWith(
          TimerModel value, $Res Function(TimerModel) then) =
      _$TimerModelCopyWithImpl<$Res, TimerModel>;
  @useResult
  $Res call(
      {AppState appState,
      int settingMinutes,
      Duration pauseAmount,
      DateTime? startTime,
      DateTime? pauseStartTime,
      DateTime? pauseEndTime});
}

/// @nodoc
class _$TimerModelCopyWithImpl<$Res, $Val extends TimerModel>
    implements $TimerModelCopyWith<$Res> {
  _$TimerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appState = null,
    Object? settingMinutes = null,
    Object? pauseAmount = null,
    Object? startTime = freezed,
    Object? pauseStartTime = freezed,
    Object? pauseEndTime = freezed,
  }) {
    return _then(_value.copyWith(
      appState: null == appState
          ? _value.appState
          : appState // ignore: cast_nullable_to_non_nullable
              as AppState,
      settingMinutes: null == settingMinutes
          ? _value.settingMinutes
          : settingMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      pauseAmount: null == pauseAmount
          ? _value.pauseAmount
          : pauseAmount // ignore: cast_nullable_to_non_nullable
              as Duration,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pauseStartTime: freezed == pauseStartTime
          ? _value.pauseStartTime
          : pauseStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pauseEndTime: freezed == pauseEndTime
          ? _value.pauseEndTime
          : pauseEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimerModelImplCopyWith<$Res>
    implements $TimerModelCopyWith<$Res> {
  factory _$$TimerModelImplCopyWith(
          _$TimerModelImpl value, $Res Function(_$TimerModelImpl) then) =
      __$$TimerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AppState appState,
      int settingMinutes,
      Duration pauseAmount,
      DateTime? startTime,
      DateTime? pauseStartTime,
      DateTime? pauseEndTime});
}

/// @nodoc
class __$$TimerModelImplCopyWithImpl<$Res>
    extends _$TimerModelCopyWithImpl<$Res, _$TimerModelImpl>
    implements _$$TimerModelImplCopyWith<$Res> {
  __$$TimerModelImplCopyWithImpl(
      _$TimerModelImpl _value, $Res Function(_$TimerModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appState = null,
    Object? settingMinutes = null,
    Object? pauseAmount = null,
    Object? startTime = freezed,
    Object? pauseStartTime = freezed,
    Object? pauseEndTime = freezed,
  }) {
    return _then(_$TimerModelImpl(
      appState: null == appState
          ? _value.appState
          : appState // ignore: cast_nullable_to_non_nullable
              as AppState,
      settingMinutes: null == settingMinutes
          ? _value.settingMinutes
          : settingMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      pauseAmount: null == pauseAmount
          ? _value.pauseAmount
          : pauseAmount // ignore: cast_nullable_to_non_nullable
              as Duration,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pauseStartTime: freezed == pauseStartTime
          ? _value.pauseStartTime
          : pauseStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pauseEndTime: freezed == pauseEndTime
          ? _value.pauseEndTime
          : pauseEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$TimerModelImpl implements _TimerModel {
  const _$TimerModelImpl(
      {this.appState = AppState.idle,
      this.settingMinutes = 0,
      this.pauseAmount = const Duration(),
      this.startTime,
      this.pauseStartTime,
      this.pauseEndTime});

  factory _$TimerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimerModelImplFromJson(json);

  @override
  @JsonKey()
  final AppState appState;
  @override
  @JsonKey()
  final int settingMinutes;
  @override
  @JsonKey()
  final Duration pauseAmount;
  @override
  final DateTime? startTime;
  @override
  final DateTime? pauseStartTime;
  @override
  final DateTime? pauseEndTime;

  @override
  String toString() {
    return 'TimerModel(appState: $appState, settingMinutes: $settingMinutes, pauseAmount: $pauseAmount, startTime: $startTime, pauseStartTime: $pauseStartTime, pauseEndTime: $pauseEndTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerModelImpl &&
            (identical(other.appState, appState) ||
                other.appState == appState) &&
            (identical(other.settingMinutes, settingMinutes) ||
                other.settingMinutes == settingMinutes) &&
            (identical(other.pauseAmount, pauseAmount) ||
                other.pauseAmount == pauseAmount) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.pauseStartTime, pauseStartTime) ||
                other.pauseStartTime == pauseStartTime) &&
            (identical(other.pauseEndTime, pauseEndTime) ||
                other.pauseEndTime == pauseEndTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, appState, settingMinutes,
      pauseAmount, startTime, pauseStartTime, pauseEndTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerModelImplCopyWith<_$TimerModelImpl> get copyWith =>
      __$$TimerModelImplCopyWithImpl<_$TimerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimerModelImplToJson(
      this,
    );
  }
}

abstract class _TimerModel implements TimerModel {
  const factory _TimerModel(
      {final AppState appState,
      final int settingMinutes,
      final Duration pauseAmount,
      final DateTime? startTime,
      final DateTime? pauseStartTime,
      final DateTime? pauseEndTime}) = _$TimerModelImpl;

  factory _TimerModel.fromJson(Map<String, dynamic> json) =
      _$TimerModelImpl.fromJson;

  @override
  AppState get appState;
  @override
  int get settingMinutes;
  @override
  Duration get pauseAmount;
  @override
  DateTime? get startTime;
  @override
  DateTime? get pauseStartTime;
  @override
  DateTime? get pauseEndTime;
  @override
  @JsonKey(ignore: true)
  _$$TimerModelImplCopyWith<_$TimerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
