import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sun_fo_timer/models/app_state.dart';
import 'package:sun_fo_timer/repository/shared_preferences_keys.dart';
import 'package:sun_fo_timer/repository/shared_preferences_repository.dart';
import 'package:sun_fo_timer/string.dart';
import 'package:sun_fo_timer/ui/config/color_theme.dart';
import 'package:sun_fo_timer/ui/config/my_text_style.dart';
import 'package:sun_fo_timer/ui/timer/view_model/timer_state.dart';
import 'package:sun_fo_timer/ui/timer/view_model/timer_view_model.dart';
import 'package:sun_fo_timer/util/brightness_util.dart';

class CustomBottomSheet extends HookConsumerWidget {
  final TimerState state;
  final double width;
  const CustomBottomSheet({super.key, required this.state, required this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _pref = ref.read(sharedPreferencesRepositoryProvider);
    final _startTimeString =
        state.timerModel.startTime != null ? state.timerModel.startTime!.toString().toYMDHMString() : '-';
    final _brightness = ref.watch(timerViewModelProvider).myBrightness;
    final _isCustomBrightness = useState(true);
    useEffect(() {
      if (_brightness != null) {
        _isCustomBrightness.value = true;
      } else {
        _isCustomBrightness.value = false;
      }
      return null;
    }, [_brightness]);

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 32),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade900,
          border: Border.all(
            color: Colors.white,
            width: 5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(ColorTheme.grey),
            boxShadow: const [
              BoxShadow(
                color: Color(ColorTheme.grey),
                spreadRadius: 10,
                blurRadius: 7,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('背景色', style: MyTextStyle.bottomSheetStyle),
              const SizedBox(height: 2),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blueGrey.shade100,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...List.generate(
                        ColorTheme.bgColors.length,
                        (index) => GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                ref.read(timerViewModelProvider.notifier).changeBgColor(index);
                              },
                              child: Container(
                                height: 30,
                                width: (width - 150) / ColorTheme.bgColors.length,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(ColorTheme.bgColors[index][0]),
                                      Color(ColorTheme.bgColors[index][1]),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                  ],
                ),
              ),
              const Text('画面の明るさ', style: MyTextStyle.bottomSheetStyle),
              const SizedBox(height: 2),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blueGrey.shade100,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Switch(
                      value: _isCustomBrightness.value,
                      activeColor: Colors.blueGrey.shade800,
                      inactiveTrackColor: Colors.grey.shade600,
                      inactiveThumbColor: Colors.yellow.shade900,
                      thumbIcon: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Icon(Icons.brightness_medium, color: Colors.white, size: 18);
                        }
                        return const Icon(Icons.brightness_auto, color: Colors.white, size: 18);
                      }),
                      onChanged: (value) async {
                        _isCustomBrightness.value = value;
                        HapticFeedback.lightImpact();
                        if (value) {
                          if (_brightness == null) return;
                          BrightnessUtil().setBrightness(_brightness);
                        } else {
                          _pref.clearPref(SharedPreferencesKey.brightness);
                          ref.read(timerViewModelProvider.notifier).clearBrightness();
                          BrightnessUtil().resetBrightness();
                        }
                      },
                    ),
                    Expanded(
                      child: Slider(
                        value: _brightness ?? 0,
                        onChanged: (value) async {
                          if (!_isCustomBrightness.value) return;
                          ref.read(timerViewModelProvider.notifier).setBrightness(value);
                          BrightnessUtil().setBrightness(value);
                          HapticFeedback.lightImpact();
                          await _pref.setDouble(SharedPreferencesKey.brightness, value);
                        },
                        activeColor: _isCustomBrightness.value ? Colors.blueGrey.shade800 : Colors.blueGrey.shade400,
                        inactiveColor: Colors.blueGrey.shade300,
                        min: 0,
                        max: 0.5,
                        divisions: 10,
                        label: _isCustomBrightness.value ? ((_brightness ?? 0) * 20).toStringAsFixed(0) : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text('開始時間    $_startTimeString', style: MyTextStyle.bottomSheetStyle),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              Text('設定時間    ${state.timerModel.settingMinutes}分', style: MyTextStyle.bottomSheetStyle),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              Text(
                  '一時停止    ${state.timerModel.pauseAmount.inMinutes}分 ${state.timerModel.appState == AppState.pause ? '再開後に加算' : ''}',
                  style: MyTextStyle.bottomSheetStyle),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade100,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.blueGrey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text('確認'),
                        content: const Text('タイマーをリセットしますか？'),
                        actions: <Widget>[
                          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                              ),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                Navigator.pop(context);
                              },
                              child: Text('キャンセル', style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 16)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey.shade600,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                ref.read(timerViewModelProvider.notifier).resetTimer();
                              },
                              child: const Text('リセット', style: MyTextStyle.bottomSheetStyle),
                            ),
                          ]),
                        ],
                      ),
                    );
                  },
                  child: Text('タイマーリセット', style: MyTextStyle.bottomSheetStyleDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
