import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sun_fo_timer/models/app_state.dart';
import 'package:sun_fo_timer/models/timer_model.dart';
import 'package:sun_fo_timer/repository/shared_preferences_keys.dart';
import 'package:sun_fo_timer/repository/shared_preferences_repository.dart';
import 'package:sun_fo_timer/ui/timer/view_model/timer_state.dart';
import 'package:sun_fo_timer/ui/widgets/custom_bottom_sheet.dart';

part 'timer_view_model.g.dart';

@Riverpod(keepAlive: true)
class TimerViewModel extends _$TimerViewModel {
  @override
  TimerState build() => const TimerState(
        timerModel: TimerModel(appState: AppState.idle),
      );

  void updateRivePosition(Offset offset) {
    state = state.copyWith(rivePositionX: offset.dx, rivePositionY: offset.dy);
  }

  void updateRiveSize(Size size) {
    state = state.copyWith(riveWidth: size.width, riveHeight: size.height);
  }

  void getCurrentAnimation(String animationName) {
    print('Rive : $animationName');

    /// sliderから始まるanimationをまとめて処理
    if (animationName.startsWith('slider') &&
        (state.timerModel.appState == AppState.idle || state.timerModel.appState == AppState.standby)) {
      final minutesString = animationName.replaceFirst('slider', ''); // sliderを''に置換
      if (minutesString == '_init') {
        updateDisplayMinutes(0);
        return;
      }
      final minutes = int.tryParse(minutesString);
      if (minutes != null) {
        updateDisplayMinutes(minutes);
        HapticFeedback.selectionClick();
        print('slider displayMinutes: $minutes');
        return;
      }
    }
    switch (animationName) {
      case 'setting_off':
        if (state.timerModel.appState == AppState.idle || state.timerModel.appState == AppState.standby) {
          if (state.displayMinutes != state.timerModel.settingMinutes) {
            if (state.displayMinutes == 0) {
              resetTimer();
            } else {
              setTimer(state.displayMinutes);
            }
          }
        }
        break;
      case 'start':
        if (state.timerModel.appState == AppState.idle || state.timerModel.appState == AppState.standby) {
          startTimer();
        }
        break;
      case 'play':
        if (state.timerModel.appState == AppState.pause) {
          playTimer();
        }
        break;
      case 'pause':
        if (state.timerModel.appState == AppState.play) {
          pauseTimer();
        }
        break;
      case 'down_reset?':
        if (state.timerModel.appState != AppState.idle) {
          resetTimer();
        }
        break;
      case 'down_complete':
        resetTimer();
        break;
      default:
        break;
    }
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return CustomBottomSheet(
          state: state,
          width: MediaQuery.of(context).size.width,
        );
      },
    );
  }

  Future<TimerModel?> fetchTimerModel() async {
    final _pref = ref.read(sharedPreferencesRepositoryProvider);
    final _timer = await _pref.getString(SharedPreferencesKey.timer).catchError((error) {
      _handleError('fetchTimerModel', error);
      return null;
    });
    if (_timer != null) {
      final _timerModel = TimerModel.fromJson(jsonDecode(_timer));
      return _timerModel;
    }
    return null;
  }

  Future<void> loadTimerModel() async {
    final _fetchTimerModel = await fetchTimerModel();
    await Future.delayed(const Duration(milliseconds: 0), () {}); // build後に実行される
    if (_fetchTimerModel == null) {
      print('loaded TimerModel : null');
      resetTimer();
      return;
    }
    switch (_fetchTimerModel.appState) {
      case AppState.play:
        if (_fetchTimerModel.startTime == null) {
          print('repository timerModel is play -> startTime is null -> resetTimer');
          resetTimer();
          break;
        }
        final _endDateTime = _fetchTimerModel.startTime!
            .add(Duration(minutes: _fetchTimerModel.settingMinutes) + _fetchTimerModel.pauseAmount);
        if (DateTime.now().isAfter(_endDateTime)) {
          print('repository timerModel is play -> completed');
          resetTimer();
          break;
        }
      case AppState.complete:
        print('repository timerModel is completed');
        resetTimer();
        break;

      case AppState.standby:
        print('repository timerModel is standby: ${_fetchTimerModel.settingMinutes} minutes');
        state = state.copyWith(timerModel: _fetchTimerModel, displayMinutes: _fetchTimerModel.settingMinutes);
        break;

      case AppState.pause:
        print('repository timerModel is pause');
        state = state.copyWith(timerModel: _fetchTimerModel);

        /// タイマーを表示させるために一度再生してから一時停止する
        playTimer();
        Future.delayed(const Duration(milliseconds: 1000), () {
          pauseTimer();
        });
        break;

      default:
        break;
    }
    print('loaded TimerModel : ${_fetchTimerModel.appState}');
    state = state.copyWith(timerModel: _fetchTimerModel);
  }

  void updateDisplayMinutes(int minutes) {
    state = state.copyWith(displayMinutes: minutes);
  }

  Duration? calculateRemainingDuration() {
    if (state.timerModel.startTime == null) return null;
    final startTime = state.timerModel.startTime;
    final progressTime = startTime!.add(state.timerModel.pauseAmount).difference(DateTime.now()).abs();
    final remainingDuration = Duration(minutes: state.timerModel.settingMinutes) - progressTime;
    return remainingDuration;
  }

  Future<void> setTimer(int m) async {
    _updateTimerModel(
      state.timerModel.copyWith(appState: AppState.standby, settingMinutes: m),
      'setTimer',
    );
    print('<execute> setTimer $m minutes');
  }

  Future<void> startTimer() async {
    if (state.timerModel.appState == AppState.standby) {
      _updateTimerModel(
        state.timerModel.copyWith(appState: AppState.start, startTime: DateTime.now()),
        'startTimer',
      );
      print('<execute> startTimer');
    } else {
      print('<caution> startTimer:timer model is not standby');
    }
    Future.delayed(const Duration(milliseconds: 1900), () {
      playTimer();
    });
  }

  Future<void> pauseTimer() async {
    if (state.timerModel.appState == AppState.play) {
      _updateTimerModel(
        state.timerModel.copyWith(appState: AppState.pause, pauseStartTime: DateTime.now(), pauseEndTime: null),
        'pauseTimer',
      );
      print('<execute> pauseTimer');
    } else {
      print('<caution> pauseTimer:timer model is not play');
    }
  }

  Future<void> playTimer() async {
    if (state.timerModel.pauseStartTime != null) {
      final _pauseAmount = state.timerModel.pauseAmount + DateTime.now().difference(state.timerModel.pauseStartTime!);
      print('pauseAmount seconds: ${_pauseAmount.inSeconds}');
      _updateTimerModel(
        state.timerModel.copyWith(
            appState: AppState.play, pauseStartTime: null, pauseEndTime: DateTime.now(), pauseAmount: _pauseAmount),
        'playTimer',
      );
    } else {
      _updateTimerModel(
        state.timerModel.copyWith(appState: AppState.play),
        'playTimer',
      );
    }
    print('<execute> playTimer');
  }

  Future<void> resetTimer() async {
    _updateTimerModel(const TimerModel(appState: AppState.idle), 'resetTimer');
    state = state.copyWith(displayMinutes: 0, prevDisplayMinutes: 0);
    print('<execute> resetTimer');
  }

  Future<void> completeTimer() async {
    _updateTimerModel(state.timerModel.copyWith(appState: AppState.complete), 'completeTimer');
    print('<execute> completeTimer');
  }

  Future<void> _updateTimerModel(TimerModel? model, String methodName) async {
    if (model == null) {
      print('<caution> updateTimerModel:timer model in not exist');
      return;
    }
    final _pref = ref.read(sharedPreferencesRepositoryProvider);
    try {
      final jsonModel = jsonEncode(model.toJson());
      if (methodName == 'resetTimer') {
        await _pref.clearPref(SharedPreferencesKey.timer);
      } else {
        await _pref.setString(SharedPreferencesKey.timer, jsonModel);
      }
      state = state.copyWith(timerModel: model);
    } catch (error) {
      _handleError(methodName, error);
    }
  }

  void _handleError(String methodName, Object error) {
    print('Error $methodName: $error');
    throw Exception('$methodNameでエラーが発生しました。: $error');
  }
}
