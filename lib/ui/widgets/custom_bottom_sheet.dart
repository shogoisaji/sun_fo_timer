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
    final _brightness = useState(0.0);
    final _isCustomBrightness = useState(true);

    useEffect(() {
      _pref.getDouble(SharedPreferencesKey.brightness).then((value) {
        if (value != null) {
          _brightness.value = value;
          _isCustomBrightness.value = true;
          BrightnessUtil().setBrightness(value);
        } else {
          _isCustomBrightness.value = false;
        }
      });
      return null;
    }, const []);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32),
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
                        HapticFeedback.selectionClick();
                        if (value) {
                          BrightnessUtil().setBrightness(_brightness.value);
                        } else {
                          _pref.clearPref(SharedPreferencesKey.brightness);
                          BrightnessUtil().resetBrightness();
                        }
                      },
                    ),
                    Expanded(
                      child: Slider(
                        value: _brightness.value,
                        onChanged: (value) async {
                          if (!_isCustomBrightness.value) return;
                          _brightness.value = value;
                          BrightnessUtil().setBrightness(value);
                          HapticFeedback.selectionClick();
                          await _pref.setDouble(SharedPreferencesKey.brightness, value);
                        },
                        activeColor: _isCustomBrightness.value ? Colors.blueGrey.shade800 : Colors.blueGrey.shade400,
                        inactiveColor: Colors.blueGrey.shade300,
                        min: 0,
                        max: 0.5,
                        divisions: 10,
                        label: _isCustomBrightness.value ? (_brightness.value * 20).toStringAsFixed(0) : null,
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
            ],
          ),
        ),
      ),
    );
  }
}
