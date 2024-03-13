import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sun_fo_timer/ui/config/color_theme.dart';
import 'package:sun_fo_timer/ui/timer/view_model/timer_view_model.dart';
import 'package:sun_fo_timer/ui/widgets/rive_widget.dart';

class TimerView extends HookConsumerWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _timerState = ref.watch(timerViewModelProvider);
    final _bgColorIndex = _timerState.bgColor;

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

    useEffect(() {
      initialLoad();
      return;
    }, []);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-1.5, -1.0),
            end: const Alignment(1.5, 1.0),
            colors: [
              Color(ColorTheme.bgColors[_bgColorIndex][0]),
              Color(ColorTheme.bgColors[_bgColorIndex][1]),
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
                    timerState: _timerState,
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
