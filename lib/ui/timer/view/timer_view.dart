import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sun_fo_timer/ui/config/color_theme.dart';
import 'package:sun_fo_timer/ui/timer/view_model/timer_view_model.dart';
import 'package:sun_fo_timer/ui/widgets/rive_widget.dart';

class TimerView extends ConsumerWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _timerState = ref.watch(timerViewModelProvider);

    void getCurrentAnimation(String animationName) {
      ref.read(timerViewModelProvider.notifier).getCurrentAnimation(animationName);
      if (animationName == 'selector') {
        ref.read(timerViewModelProvider.notifier).showBottomSheet(context);
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-1.5, -1.0),
            end: const Alignment(1.5, 1.0),
            colors: [
              Color(ColorTheme.bg1[0]),
              Color(ColorTheme.bg1[1]),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: RiveWidget(
                    timerState: _timerState,
                    // setTimer: setTimer,
                    // startTimer: startTimer,
                    // pauseTimer: pauseTimer,
                    // playTimer: playTimer,
                    // resetTimer: resetTimer,
                    // completeTimer: completeTimer,
                    // updateDisplayMinutes: updateDisplayMinutes,
                    getCurrentAnimation: getCurrentAnimation,
                  ),
                ),
                // _timerState.timerModel.appState == AppState.complete
                //     ? Center(
                //         child: Container(
                //           width: 200,
                //           height: 200,
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(20),
                //           ),
                //           child: Column(
                //             children: [
                //               const Center(
                //                 child: Text(
                //                   'Complete!',
                //                   style: TextStyle(
                //                     fontSize: 32,
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.blue,
                //                   ),
                //                 ),
                //               ),
                //               ElevatedButton(
                //                 onPressed: () {
                //                   resetTimer();
                //                 },
                //                 child: const Text('Reset'),
                //               ),
                //             ],
                //           ),
                //         ),
                //       )
                //     : Container(),
                Align(alignment: Alignment.topCenter, child: Text(_timerState.timerModel.appState.toString())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
