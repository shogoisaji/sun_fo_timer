import 'package:sun_fo_timer/models/timer_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_state.freezed.dart';

@freezed
class TimerState with _$TimerState {
  const factory TimerState({
    required TimerModel timerModel,
    @Default(0) int displayMinutes,
    @Default(0) int prevDisplayMinutes,
    @Default(0.0) double rivePositionX,
    @Default(0.0) double rivePositionY,
    @Default(0.0) double riveWidth,
    @Default(0.0) double riveHeight,
  }) = _TimerState;
}
