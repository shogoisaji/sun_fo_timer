import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sun_fo_timer/ui/config/color_theme.dart';
import 'package:sun_fo_timer/ui/timer/view_model/timer_view_model.dart';
import 'package:sun_fo_timer/ui/widgets/rive_widget.dart';
import 'package:sun_fo_timer/util/app_lifecycle_state_provider.dart';
import 'package:sun_fo_timer/util/brightness_util.dart';

class TimerView extends HookConsumerWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerViewModelProvider);
    final bgColorIndex = timerState.bgColor;
    final brightness = timerState.myBrightness;

    final isResumed = ref.watch(appLifecycleStateProvider) == AppLifecycleState.resumed;

    void getCurrentAnimation(String animationName) {
      ref.read(timerViewModelProvider.notifier).getCurrentAnimation(animationName);

      /// contextが必要なのでbottomSheetはここで呼ぶ
      if (animationName == 'selector') {
        ref.read(timerViewModelProvider.notifier).showBottomSheet(context);
      }
    }

    void initialLoad() {
      ref.read(timerViewModelProvider.notifier).loadSettings();
      ref.read(timerViewModelProvider.notifier).loadTimerModel();
    }

    void rotateInit() {
      Future.delayed(const Duration(milliseconds: 500), () {
        ref.read(timerViewModelProvider.notifier).loadTimerModel();
      });
    }

    useEffect(() {
      rotateInit();
      return;
    }, [isResumed]);
    useEffect(() {
      initialLoad();
      return;
    }, [isResumed]);
    useEffect(() {
      if (brightness == null) {
        BrightnessUtil().resetBrightness();
      } else {
        BrightnessUtil().setBrightness(brightness);
      }
      return;
    }, [brightness]);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-1.5, -1.0),
            end: const Alignment(1.5, 1.0),
            colors: [
              Color(ColorTheme.bgColors[bgColorIndex][0]),
              Color(ColorTheme.bgColors[bgColorIndex][1]),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Stack(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: RiveWidget(
                    timerState: timerState,
                    getCurrentAnimation: getCurrentAnimation,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
