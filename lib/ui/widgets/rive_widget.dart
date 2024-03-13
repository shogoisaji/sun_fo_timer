import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:sun_fo_timer/models/app_state.dart';
import 'package:sun_fo_timer/ui/timer/view_model/timer_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_fo_timer/ui/timer/view_model/timer_view_model.dart';

class RiveWidget extends StatefulHookConsumerWidget {
  final TimerState timerState;
  final Function getCurrentAnimation;
  const RiveWidget({
    super.key,
    required this.timerState,
    required this.getCurrentAnimation,
  });

  @override
  ConsumerState<RiveWidget> createState() => _RiveWidgetState();
}

class _RiveWidgetState extends ConsumerState<RiveWidget> with TickerProviderStateMixin {
  late Timer _timeTimer;
  late Timer _tickTimer;

  SMIInput<double>? _slider;
  SMIInput<double>? _sunRise;
  SMIInput<double>? _count0;
  SMIInput<double>? _count10;
  SMIInput<double>? _time1;
  SMIInput<double>? _time2;
  SMIInput<double>? _time3;
  SMIInput<double>? _time4;
  SMIInput<double>? _countType;
  SMIInput<bool>? _isPlay;
  SMIInput<bool>? _isPause;
  SMIInput<bool>? _isShowReset;
  SMIInput<bool>? _isSunRotate;
  SMIInput<bool>? _isSunStartRotate;
  SMIInput<bool>? _isAppearStart;
  SMIInput<bool>? _isSliderEnable;
  SMIInput<bool>? _isComplete;

  /// Riveの表示Minutesを更新
  void _updateRiveDisplayMinutes() {
    if (_count10 == null || _count0 == null) {
      print('updateRiveDisplayMinutes():count10 or count0 is null');
      return;
    }
    final m = widget.timerState.displayMinutes;
    _count10!.value = (m ~/ 10).toDouble(); // 10の位
    _count0!.value = (m % 10).toDouble(); // 1の位
  }

  /// 現在時刻を更新
  void _updateCurrentTime() {
    final DateTime now = DateTime.now();
    if (_time4 == null || _time3 == null || _time2 == null || _time1 == null) return;
    _time4!.value = (now.hour ~/ 10).toDouble();
    _time3!.value = (now.hour % 10).toDouble();
    _time2!.value = (now.minute ~/ 10).toDouble();
    _time1!.value = (now.minute % 10).toDouble();
  }

  /// RiveAnimationからのコールバック 変更があったAnimation名がStringで返される
  _onStateChange(String stateMachineName, String stateName) {
    widget.getCurrentAnimation(stateName);
  }

  /// RiveAnimationの初期化
  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'state',
      onStateChange: _onStateChange,
    );
    artboard.addController(controller!);

    _time1 = controller.findInput<double>('time1') as SMINumber; //__:_0
    _time2 = controller.findInput<double>('time2') as SMINumber; //__:0_
    _time3 = controller.findInput<double>('time3') as SMINumber; //_0:__
    _time4 = controller.findInput<double>('time4') as SMINumber; //0_:__
    _count0 = controller.findInput<double>('count0') as SMINumber;
    _count10 = controller.findInput<double>('count10') as SMINumber;
    _slider = controller.findInput<double>('slider') as SMINumber;
    _sunRise = controller.findInput<double>('sun_rise') as SMINumber;
    _isPlay = controller.findInput<bool>('is_play') as SMIBool;
    _isPause = controller.findInput<bool>('is_pause') as SMIBool;
    _isShowReset = controller.findInput<bool>('is_show_reset') as SMIBool;
    _isAppearStart = controller.findInput<bool>('is_appear_start') as SMIBool;
    _isSunRotate = controller.findInput<bool>('is_sun_rotate') as SMIBool;
    _isSunStartRotate = controller.findInput<bool>('is_sun_start_rotate') as SMIBool;
    _isSliderEnable = controller.findInput<bool>('is_slider_enable') as SMIBool;
    _isComplete = controller.findInput<bool>('is_complete') as SMIBool;
    _countType = controller.findInput<double>('count') as SMINumber;

    _isPlay!.value = false;
    _isPause!.value = false;
    _isSliderEnable!.value = true;
    _sunRise!.value = 100;
    _slider!.value = 100;
    _countType!.value = 5;
    _isSunRotate!.value = false;
    _isShowReset!.value = false;
    _isAppearStart!.value = false;
    _isComplete!.value = false;
  }

  void updateRiveState() {
    switch (widget.timerState.timerModel.appState) {
      case AppState.idle:
        print('AppState.idle');
        _countType!.value = widget.timerState.countType.toDouble();
        _sunRise!.value = 100;
        _slider!.value = 100;
        _isPlay!.value = false;
        _isPause!.value = false;
        _isSliderEnable!.value = true;
        _isSunRotate!.value = false;
        _isSunStartRotate!.value = false;
        _isShowReset!.value = false;
        _isAppearStart!.value = false;
        _isComplete!.value = false;
        break;

      case AppState.standby:
        print('AppState.standby');
        _sunRise!.value = 100;
        _isPlay!.value = false;
        _isPause!.value = false;
        _isSliderEnable!.value = true;
        _isSunRotate!.value = false;
        _isSunStartRotate!.value = false;
        _isShowReset!.value = false;
        _isAppearStart!.value = true;
        _isComplete!.value = false;
        break;
      case AppState.start:
        print('AppState.start');
        _countType!.value = 0;
        _isPlay!.value = true;
        _isPause!.value = false;
        _isSliderEnable!.value = false;
        _isSunRotate!.value = true;
        _isSunStartRotate!.value = true;
        _isShowReset!.value = false;
        _isAppearStart!.value = false;
        _isComplete!.value = false;

        break;
      case AppState.play:
        print('AppState.play');
        _countType!.value = 0;
        _isPlay!.value = true;
        _isPause!.value = false;
        _isSliderEnable!.value = false;
        _isSunRotate!.value = true;
        _isSunStartRotate!.value = false;
        _isShowReset!.value = true;
        _isAppearStart!.value = false;
        _isComplete!.value = false;

        break;
      case AppState.pause:
        print('AppState.pause');
        _countType!.value = 0;
        _isPlay!.value = true;
        _isPause!.value = true;
        _isSliderEnable!.value = false;
        _isSunRotate!.value = false;
        _isSunStartRotate!.value = false;
        _isShowReset!.value = true;
        _isAppearStart!.value = false;
        _isComplete!.value = false;

        break;
      case AppState.complete:
        print('AppState.complete');
        _sunRise!.value = 100;
        _isPlay!.value = false;
        _isPause!.value = false;
        _isSliderEnable!.value = false;
        _isSunRotate!.value = false;
        _isSunStartRotate!.value = false;
        _isShowReset!.value = false;
        _isAppearStart!.value = false;
        _isComplete!.value = true;
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _timeTimer.cancel();
    _tickTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final _timerState = ref.watch(timerViewModelProvider);
    final _isRiveBuilded = useState(false);

    void calculateSunPosition(Duration remainingDuration) {
      final progressRate = remainingDuration.inMilliseconds / widget.timerState.timerModel.settingMinutes / 60000;
      if (progressRate < 0.0) {
        ref.read(timerViewModelProvider.notifier).completeTimer();
      }
      _sunRise!.value = (1 - progressRate) * 100;
    }

    void updateDisplayMinutes() {
      final remainingDuration = ref.read(timerViewModelProvider.notifier).calculateRemainingDuration();
      if (remainingDuration == null) return;
      ref.read(timerViewModelProvider.notifier).updateDisplayMinutes((remainingDuration.inSeconds / 60).ceil());
      calculateSunPosition(remainingDuration);
    }

    useEffect(() {
      /// 常時更新用
      _tickTimer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
        /// Rive Widget Build Check
        if (_isPlay != null && !_isRiveBuilded.value) {
          _isRiveBuilded.value = true;
        }
        if (!_isRiveBuilded.value || widget.timerState.timerModel.appState != AppState.play) return;
        updateDisplayMinutes();
      });

      /// このタイマーで現在時刻を更新
      _timeTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        _updateCurrentTime();
      });
      return () {
        [_tickTimer.cancel(), _timeTimer.cancel()];
      };
    }, []);

    useEffect(() {
      if (!_isRiveBuilded.value) return;
      updateRiveState();
      return null;
    }, [_timerState.timerModel.appState]);

    useEffect(() {
      _updateRiveDisplayMinutes();
      return null;
    }, [_timerState.displayMinutes]);

    return Stack(
      children: [
        Center(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              SizedBox(
                width: w > h ? null : w,
                height: w > h ? h : null,
                child: AspectRatio(
                  aspectRatio: 740 / 1200,
                  child: RiveAnimation.asset(
                    'assets/rive/time.riv',
                    fit: BoxFit.contain,
                    onInit: _onRiveInit,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
