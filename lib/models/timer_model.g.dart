// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimerModelImpl _$$TimerModelImplFromJson(Map<String, dynamic> json) =>
    _$TimerModelImpl(
      appState: $enumDecodeNullable(_$AppStateEnumMap, json['appState']) ??
          AppState.idle,
      settingMinutes: json['settingMinutes'] as int? ?? 0,
      pauseAmount: json['pauseAmount'] == null
          ? const Duration()
          : Duration(microseconds: json['pauseAmount'] as int),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      pauseStartTime: json['pauseStartTime'] == null
          ? null
          : DateTime.parse(json['pauseStartTime'] as String),
      pauseEndTime: json['pauseEndTime'] == null
          ? null
          : DateTime.parse(json['pauseEndTime'] as String),
    );

Map<String, dynamic> _$$TimerModelImplToJson(_$TimerModelImpl instance) =>
    <String, dynamic>{
      'appState': _$AppStateEnumMap[instance.appState]!,
      'settingMinutes': instance.settingMinutes,
      'pauseAmount': instance.pauseAmount.inMicroseconds,
      'startTime': instance.startTime?.toIso8601String(),
      'pauseStartTime': instance.pauseStartTime?.toIso8601String(),
      'pauseEndTime': instance.pauseEndTime?.toIso8601String(),
    };

const _$AppStateEnumMap = {
  AppState.idle: 'idle',
  AppState.standby: 'standby',
  AppState.start: 'start',
  AppState.play: 'play',
  AppState.pause: 'pause',
  AppState.complete: 'complete',
};
