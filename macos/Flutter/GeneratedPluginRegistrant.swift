//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import package_info_plus
import rive_common
import screen_brightness_macos
import shared_preferences_foundation
import wakelock_plus

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FPPPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FPPPackageInfoPlusPlugin"))
  RivePlugin.register(with: registry.registrar(forPlugin: "RivePlugin"))
  ScreenBrightnessMacosPlugin.register(with: registry.registrar(forPlugin: "ScreenBrightnessMacosPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  WakelockPlusMacosPlugin.register(with: registry.registrar(forPlugin: "WakelockPlusMacosPlugin"))
}
