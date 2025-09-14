import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/language_picker_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/settings_tile_widget.dart';
import './widgets/slider_setting_widget.dart';
import './widgets/storage_info_widget.dart';
import './widgets/toggle_switch_widget.dart';

class SettingsPanel extends StatefulWidget {
  @override
  _SettingsPanelState createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Settings state variables
  bool _useLocalModel = true;
  double _detectionThreshold = 0.7;
  String _selectedLanguage = 'en';
  bool _isDarkMode = false;
  bool _weatherAlerts = true;
  bool _farmingTips = true;
  bool _scanReminders = false;
  bool _locationSharing = true;
  bool _usageAnalytics = false;
  bool _voiceGuidance = false;
  bool _highContrast = false;
  double _textSize = 1.0;

  // Mock data
  final List<Map<String, dynamic>> _languages = [
    {
      'code': 'en',
      'name': 'English',
      'nativeName': 'English',
      'flag': '🇺🇸',
      'downloaded': true,
    },
    {
      'code': 'es',
      'name': 'Spanish',
      'nativeName': 'Español',
      'flag': '🇪🇸',
      'downloaded': true,
    },
    {
      'code': 'fr',
      'name': 'French',
      'nativeName': 'Français',
      'flag': '🇫🇷',
      'downloaded': false,
    },
    {
      'code': 'pt',
      'name': 'Portuguese',
      'nativeName': 'Português',
      'flag': '🇧🇷',
      'downloaded': false,
    },
    {
      'code': 'sw',
      'name': 'Swahili',
      'nativeName': 'Kiswahili',
      'flag': '🇹🇿',
      'downloaded': false,
    },
    {
      'code': 'yo',
      'name': 'Yoruba',
      'nativeName': 'Yorùbá',
      'flag': '🇳🇬',
      'downloaded': false,
    },
  ];

  final Map<String, double> _storageBreakdown = {
    'App Data': 45.2 * 1024 * 1024,
    'Images': 128.7 * 1024 * 1024,
    'Cache': 23.1 * 1024 * 1024,
    'Models': 89.4 * 1024 * 1024,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.7),
          indicatorColor: AppTheme.lightTheme.colorScheme.onPrimary,
          indicatorWeight: 3,
          labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium,
          tabs: [
            Tab(text: 'General'),
            Tab(text: 'AI & Detection'),
            Tab(text: 'Privacy'),
            Tab(text: 'About'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGeneralTab(),
          _buildAIDetectionTab(),
          _buildPrivacyTab(),
          _buildAboutTab(),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          SettingsSectionWidget(
            title: 'Appearance',
            children: [
              SettingsTileWidget(
                title: 'Dark Mode',
                subtitle: 'Switch between light and dark themes',
                iconName: 'dark_mode',
                trailing: ToggleSwitchWidget(
                  value: _isDarkMode,
                  onChanged: (value) => setState(() => _isDarkMode = value),
                ),
                showDivider: true,
              ),
              SliderSettingWidget(
                title: 'Text Size',
                subtitle: 'Adjust text size for better readability',
                value: _textSize,
                min: 0.8,
                max: 1.4,
                divisions: 6,
                onChanged: (value) => setState(() => _textSize = value),
                valueFormatter: (value) => '${(value * 100).toInt()}%',
              ),
              SettingsTileWidget(
                title: 'High Contrast',
                subtitle: 'Increase contrast for better visibility',
                iconName: 'contrast',
                trailing: ToggleSwitchWidget(
                  value: _highContrast,
                  onChanged: (value) => setState(() => _highContrast = value),
                ),
                showDivider: false,
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Language & Region',
            children: [
              SettingsTileWidget(
                title: 'Language',
                subtitle: _languages.firstWhere(
                        (lang) => lang['code'] == _selectedLanguage)['name']
                    as String,
                iconName: 'language',
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showLanguagePicker(),
                showDivider: false,
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Notifications',
            children: [
              SettingsTileWidget(
                title: 'Weather Alerts',
                subtitle: 'Get notified about weather conditions',
                iconName: 'cloud',
                trailing: ToggleSwitchWidget(
                  value: _weatherAlerts,
                  onChanged: (value) => setState(() => _weatherAlerts = value),
                ),
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Farming Tips',
                subtitle: 'Receive daily farming recommendations',
                iconName: 'lightbulb',
                trailing: ToggleSwitchWidget(
                  value: _farmingTips,
                  onChanged: (value) => setState(() => _farmingTips = value),
                ),
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Scan Reminders',
                subtitle: 'Reminders to check your crops regularly',
                iconName: 'schedule',
                trailing: ToggleSwitchWidget(
                  value: _scanReminders,
                  onChanged: (value) => setState(() => _scanReminders = value),
                ),
                showDivider: false,
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Accessibility',
            children: [
              SettingsTileWidget(
                title: 'Voice Guidance',
                subtitle: 'Enable audio instructions and feedback',
                iconName: 'record_voice_over',
                trailing: ToggleSwitchWidget(
                  value: _voiceGuidance,
                  onChanged: (value) => setState(() => _voiceGuidance = value),
                ),
                showDivider: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIDetectionTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          SettingsSectionWidget(
            title: 'AI Model Configuration',
            children: [
              SettingsTileWidget(
                title: 'Use Local Model',
                subtitle: _useLocalModel
                    ? 'Processing on device - works offline, faster but less accurate'
                    : 'Processing on server - requires internet, slower but more accurate',
                iconName: _useLocalModel ? 'phone_android' : 'cloud',
                trailing: ToggleSwitchWidget(
                  value: _useLocalModel,
                  onChanged: (value) => setState(() => _useLocalModel = value),
                ),
                showDivider: false,
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Detection Settings',
            children: [
              SliderSettingWidget(
                title: 'Detection Threshold',
                subtitle: _getThresholdDescription(_detectionThreshold),
                value: _detectionThreshold,
                min: 0.3,
                max: 0.9,
                divisions: 6,
                onChanged: (value) =>
                    setState(() => _detectionThreshold = value),
                valueFormatter: (value) => '${(value * 100).toInt()}%',
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Model Information',
            children: [
              SettingsTileWidget(
                title: 'Local Model Version',
                subtitle: 'CassavaGuard v2.1.3 - Updated Aug 2025',
                iconName: 'info',
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Model Size',
                subtitle: '89.4 MB',
                iconName: 'storage',
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Update Model',
                subtitle: 'Check for model updates',
                iconName: 'system_update',
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showUpdateDialog(),
                showDivider: false,
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Performance',
            children: [
              SettingsTileWidget(
                title: 'Processing Speed',
                subtitle: 'Average: 2.3 seconds per scan',
                iconName: 'speed',
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Accuracy Rate',
                subtitle: 'Local: 87% | Server: 94%',
                iconName: 'verified',
                showDivider: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyTab() {
    final totalStorage = _storageBreakdown.values.reduce((a, b) => a + b);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          SettingsSectionWidget(
            title: 'Privacy Controls',
            children: [
              SettingsTileWidget(
                title: 'Location Sharing',
                subtitle: 'Allow app to access your location for weather data',
                iconName: 'location_on',
                trailing: ToggleSwitchWidget(
                  value: _locationSharing,
                  onChanged: (value) =>
                      setState(() => _locationSharing = value),
                ),
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Usage Analytics',
                subtitle:
                    'Help improve the app by sharing anonymous usage data',
                iconName: 'analytics',
                trailing: ToggleSwitchWidget(
                  value: _usageAnalytics,
                  onChanged: (value) => setState(() => _usageAnalytics = value),
                ),
                showDivider: false,
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Data Management',
            children: [
              StorageInfoWidget(
                usedStorage: totalStorage,
                totalStorage: 500 * 1024 * 1024, // 500 MB total
                storageBreakdown: _storageBreakdown,
              ),
              Divider(
                height: 1,
                thickness: 0.5,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              SettingsTileWidget(
                title: 'Clear Cache',
                subtitle:
                    'Free up ${((_storageBreakdown['Cache'] ?? 0) / (1024 * 1024)).toStringAsFixed(1)} MB of storage',
                iconName: 'delete_sweep',
                onTap: () => _showClearCacheDialog(),
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Download Offline Content',
                subtitle: 'Download disease library for offline use',
                iconName: 'download',
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showOfflineContentDialog(),
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Export Scan History',
                subtitle: 'Export your scan results as CSV',
                iconName: 'file_download',
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _exportScanHistory(),
                showDivider: false,
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Reset Options',
            children: [
              SettingsTileWidget(
                title: 'Reset Preferences',
                subtitle: 'Reset all settings to default values',
                iconName: 'restore',
                titleColor: AppTheme.warningLight,
                onTap: () => _showResetDialog('preferences'),
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Factory Reset',
                subtitle: 'Clear all data and reset app to initial state',
                iconName: 'restore_from_trash',
                titleColor: AppTheme.errorLight,
                onTap: () => _showResetDialog('factory'),
                showDivider: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            child: Column(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'eco',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'CassavaGuard',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Version 1.2.0 (Build 120)',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'AI-powered cassava disease detection for farmers',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SettingsSectionWidget(
            title: 'App Information',
            children: [
              SettingsTileWidget(
                title: 'What\'s New',
                subtitle: 'See the latest features and improvements',
                iconName: 'new_releases',
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showWhatsNewDialog(),
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Tutorial',
                subtitle: 'Replay the app introduction',
                iconName: 'play_circle',
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => Navigator.pushNamed(context, '/onboarding-flow'),
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Help & FAQ',
                subtitle: 'Get answers to common questions',
                iconName: 'help',
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showHelpDialog(),
                showDivider: false,
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Support',
            children: [
              SettingsTileWidget(
                title: 'Contact Support',
                subtitle: 'Get help from agricultural extension officers',
                iconName: 'support_agent',
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showContactDialog(),
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Rate App',
                subtitle: 'Help us improve by rating the app',
                iconName: 'star_rate',
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showRatingDialog(),
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Share App',
                subtitle: 'Recommend CassavaGuard to other farmers',
                iconName: 'share',
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _shareApp(),
                showDivider: false,
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Legal',
            children: [
              SettingsTileWidget(
                title: 'Privacy Policy',
                subtitle: 'How we protect your data',
                iconName: 'privacy_tip',
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showPrivacyPolicy(),
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Terms of Service',
                subtitle: 'App usage terms and conditions',
                iconName: 'description',
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showTermsOfService(),
                showDivider: true,
              ),
              SettingsTileWidget(
                title: 'Open Source Licenses',
                subtitle: 'Third-party software licenses',
                iconName: 'code',
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showLicenses(),
                showDivider: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getThresholdDescription(double threshold) {
    if (threshold <= 0.4) return 'Very sensitive - may detect false positives';
    if (threshold <= 0.6) return 'Sensitive - good for early detection';
    if (threshold <= 0.8) return 'Balanced - recommended for most users';
    return 'Conservative - only high-confidence detections';
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LanguagePickerWidget(
        currentLanguage: _selectedLanguage,
        languages: _languages,
        onLanguageChanged: (languageCode) {
          setState(() => _selectedLanguage = languageCode);
        },
      ),
    );
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Model Update'),
        content: Text(
            'Your model is up to date. The latest version (v2.1.3) is already installed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cache'),
        content: Text(
            'This will free up storage space but may slow down the app temporarily. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _storageBreakdown['Cache'] = 0;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showOfflineContentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Download Offline Content'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Download content for offline use:'),
            SizedBox(height: 2.h),
            Text('• Disease library (12 MB)'),
            Text('• Treatment guides (8 MB)'),
            Text('• Prevention tips (5 MB)'),
            SizedBox(height: 2.h),
            Text('Total: 25 MB', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Download started in background')),
              );
            },
            child: Text('Download'),
          ),
        ],
      ),
    );
  }

  void _exportScanHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scan history exported to Downloads folder')),
    );
  }

  void _showResetDialog(String type) {
    final isFactory = type == 'factory';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isFactory ? 'Factory Reset' : 'Reset Preferences'),
        content: Text(
          isFactory
              ? 'This will delete all your data, scan history, and reset all settings. This action cannot be undone.'
              : 'This will reset all settings to their default values. Your scan history will be preserved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isFactory) {
                // Reset all data
                setState(() {
                  _useLocalModel = true;
                  _detectionThreshold = 0.7;
                  _selectedLanguage = 'en';
                  _isDarkMode = false;
                  _weatherAlerts = true;
                  _farmingTips = true;
                  _scanReminders = false;
                  _locationSharing = true;
                  _usageAnalytics = false;
                  _voiceGuidance = false;
                  _highContrast = false;
                  _textSize = 1.0;
                });
              } else {
                // Reset only preferences
                setState(() {
                  _useLocalModel = true;
                  _detectionThreshold = 0.7;
                  _isDarkMode = false;
                  _weatherAlerts = true;
                  _farmingTips = true;
                  _scanReminders = false;
                  _voiceGuidance = false;
                  _highContrast = false;
                  _textSize = 1.0;
                });
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(isFactory
                        ? 'Factory reset completed'
                        : 'Preferences reset to defaults')),
              );
            },
            child: Text(
              'Reset',
              style: TextStyle(color: AppTheme.errorLight),
            ),
          ),
        ],
      ),
    );
  }

  void _showWhatsNewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('What\'s New in v1.2.0'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🔬 Improved AI accuracy by 12%'),
              SizedBox(height: 1.h),
              Text('🌍 Added 3 new languages'),
              SizedBox(height: 1.h),
              Text('📱 Better offline mode support'),
              SizedBox(height: 1.h),
              Text('🎨 Enhanced user interface'),
              SizedBox(height: 1.h),
              Text('🐛 Fixed camera issues on older devices'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help & FAQ'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Q: How accurate is the disease detection?',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                  'A: Our AI model has 94% accuracy when using server processing and 87% with local processing.'),
              SizedBox(height: 2.h),
              Text('Q: Can I use the app without internet?',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                  'A: Yes! The local AI model works completely offline for disease detection.'),
              SizedBox(height: 2.h),
              Text('Q: How do I get the best scan results?',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                  'A: Take photos in good lighting, focus on diseased areas, and hold the camera steady.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Get help from our agricultural experts:'),
            SizedBox(height: 2.h),
            Text('📧 Email: support@cassavaguard.org'),
            SizedBox(height: 1.h),
            Text('📱 WhatsApp: +1-555-CASSAVA'),
            SizedBox(height: 1.h),
            Text('🌐 Website: www.cassavaguard.org'),
            SizedBox(height: 2.h),
            Text('Response time: 24-48 hours'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rate CassavaGuard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Help other farmers discover CassavaGuard by rating us on the app store!'),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => CustomIconWidget(
                  iconName: 'star',
                  color: AppTheme.warningLight,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Later'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Thank you for your feedback!')),
              );
            },
            child: Text('Rate Now'),
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share link copied to clipboard')),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(
            'CassavaGuard Privacy Policy\n\n'
            'We are committed to protecting your privacy. This app:\n\n'
            '• Only collects data necessary for disease detection\n'
            '• Processes images locally when possible\n'
            '• Does not share personal information with third parties\n'
            '• Allows you to control data sharing preferences\n\n'
            'For the full privacy policy, visit: www.cassavaguard.org/privacy',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms of Service'),
        content: SingleChildScrollView(
          child: Text(
            'CassavaGuard Terms of Service\n\n'
            'By using this app, you agree to:\n\n'
            '• Use the app for agricultural purposes only\n'
            '• Not rely solely on AI predictions for critical decisions\n'
            '• Consult agricultural experts when needed\n'
            '• Respect intellectual property rights\n\n'
            'For complete terms, visit: www.cassavaguard.org/terms',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLicenses() {
    showLicensePage(
      context: context,
      applicationName: 'CassavaGuard',
      applicationVersion: '1.2.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: 'eco',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 32,
          ),
        ),
      ),
    );
  }
}
