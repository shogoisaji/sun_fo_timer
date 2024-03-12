import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sun_fo_timer/models/app_state.dart';

part 'timer_model.freezed.dart';
part 'timer_model.g.dart';

@freezed
class TimerModel with _$TimerModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory TimerModel(
      {@Default(AppState.idle) AppState appState,
      @Default(0) int settingMinutes,
      @Default(Duration()) Duration pauseAmount,
      DateTime? startTime,
      DateTime? pauseStartTime,
      DateTime? pauseEndTime}) = _TimerModel;

  factory TimerModel.fromJson(Map<String, dynamic> json) => _$TimerModelFromJson(json);
}
