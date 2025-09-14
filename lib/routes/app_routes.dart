import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/scan_history/scan_history.dart';
import '../presentation/disease_detection_results/disease_detection_results.dart';
import '../presentation/ai_chat_assistant/ai_chat_assistant.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/settings_panel/settings_panel.dart';
import '../presentation/weather_dashboard/weather_dashboard.dart';
import '../presentation/common_diseases_library/common_diseases_library.dart';
import '../ui/screens/select_scan_page.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/splash-screen';
  static const String splash = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String scanHistory = '/scan-history';
  static const String diseaseDetectionResults = '/disease-detection-results';
  static const String aiChatAssistant = '/ai-chat-assistant';
  static const String onboardingFlow = '/onboarding-flow';
  static const String settingsPanel = '/settings-panel';
  static const String weatherDashboard = '/weather-dashboard';
  static const String commonDiseasesLibrary = '/common-diseases-library';
  static const String cameraScanScreen = '/camera-scan-screen';
  static const String selectScan = '/select-scan';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    scanHistory: (context) => const ScanHistory(),
    diseaseDetectionResults: (context) => const DiseaseDetectionResults(),
    aiChatAssistant: (context) => const AiChatAssistant(),
    onboardingFlow: (context) => const OnboardingFlow(),
    settingsPanel: (context) => SettingsPanel(),
    weatherDashboard: (context) => const WeatherDashboard(),
    commonDiseasesLibrary: (context) => const CommonDiseasesLibrary(),
    selectScan: (context) => const SelectScanPage(),
    // TODO: Add your other routes here
  };
}