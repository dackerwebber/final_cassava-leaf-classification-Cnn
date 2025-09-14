import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/current_weather_card.dart';
import './widgets/farming_calendar_widget.dart';
import './widgets/farming_recommendation_card.dart';
import './widgets/forecast_card.dart';
import './widgets/weather_alert_banner.dart';

class WeatherDashboard extends StatefulWidget {
  const WeatherDashboard({Key? key}) : super(key: key);

  @override
  State<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isOfflineMode = false;
  String _lastUpdated = '2025-08-26 23:31';
  List<Map<String, dynamic>> _dismissedAlerts = [];
  List<String> _dismissedAlertIds = [];

  // Mock weather data
  final Map<String, dynamic> _currentWeather = {
    'location': 'Africa, Ghana',
    'temperature': 28,
    'condition': 'Partly Cloudy',
    'humidity': 75,
    'windSpeed': 12,
    'uvIndex': 6,
  };

  final List<Map<String, dynamic>> _forecast = [
    {
      'day': 'Today',
      'condition': 'Partly Cloudy',
      'high': 30,
      'low': 22,
      'precipitation': 20,
    },
    {
      'day': 'Tomorrow',
      'condition': 'Rainy',
      'high': 26,
      'low': 19,
      'precipitation': 80,
    },
    {
      'day': 'Wed',
      'condition': 'Sunny',
      'high': 32,
      'low': 24,
      'precipitation': 5,
    },
    {
      'day': 'Thu',
      'condition': 'Cloudy',
      'high': 29,
      'low': 21,
      'precipitation': 30,
    },
    {
      'day': 'Fri',
      'condition': 'Stormy',
      'high': 25,
      'low': 18,
      'precipitation': 90,
    },
  ];

  final List<Map<String, dynamic>> _farmingRecommendations = [
    {
      'title': 'Optimal Planting Conditions',
      'description':
          'Current soil moisture and temperature levels are ideal for cassava planting. Consider planting new crops in the next 2-3 days.',
      'type': 'success',
      'priority': 'high',
      'action': 'Prepare seedlings and plan planting schedule',
    },
    {
      'title': 'Irrigation Advisory',
      'description':
          'Expected rainfall tomorrow will provide adequate water. Reduce irrigation to prevent waterlogging.',
      'type': 'warning',
      'priority': 'medium',
      'action': 'Monitor soil drainage and adjust watering schedule',
    },
    {
      'title': 'Disease Risk Alert',
      'description':
          'High humidity levels increase risk of fungal diseases. Inspect cassava leaves regularly for early signs.',
      'type': 'alert',
      'priority': 'high',
      'action': 'Apply preventive fungicide treatment if necessary',
    },
  ];

  final List<Map<String, dynamic>> _weatherAlerts = [
    {
      'id': 'alert_1',
      'title': 'Heavy Rainfall Warning',
      'description':
          'Heavy rainfall expected tomorrow evening. Secure farming equipment and ensure proper drainage.',
      'severity': 'Moderate',
      'type': 'rain',
      'validUntil': 'Aug 28, 6:00 AM',
    },
    {
      'id': 'alert_2',
      'title': 'High UV Index',
      'description':
          'UV index will reach dangerous levels. Limit outdoor activities during peak hours (11 AM - 3 PM).',
      'severity': 'Minor',
      'type': 'temperature',
      'validUntil': 'Aug 27, 6:00 PM',
    },
  ];

  final List<Map<String, dynamic>> _farmingActivities = [
    {
      'title': 'Cassava Leaf Inspection',
      'description': 'Check for signs of mosaic virus and bacterial blight',
      'type': 'pest_control',
      'priority': 'high',
      'date': 'Today, 8:00 AM',
    },
    {
      'title': 'Soil Moisture Check',
      'description': 'Monitor soil conditions before expected rainfall',
      'type': 'irrigation',
      'priority': 'medium',
      'date': 'Tomorrow, 7:00 AM',
    },
    {
      'title': 'Fertilizer Application',
      'description': 'Apply organic fertilizer to 6-month old cassava plants',
      'type': 'fertilizing',
      'priority': 'medium',
      'date': 'Aug 28, 9:00 AM',
    },
    {
      'title': 'Harvest Planning',
      'description': 'Prepare for cassava harvest in mature plots',
      'type': 'harvesting',
      'priority': 'low',
      'date': 'Aug 30, 6:00 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshWeatherData,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isOfflineMode) _buildOfflineBanner(),
                _buildWeatherAlerts(),
                CurrentWeatherCard(currentWeather: _currentWeather),
                _buildForecastSection(),
                _buildFarmingRecommendationsSection(),
                FarmingCalendarWidget(activities: _farmingActivities),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      elevation: 0,
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'cloud',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
          SizedBox(width: 2.w),
          Text(
            'Weather Dashboard',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _showLocationSelector,
          icon: CustomIconWidget(
            iconName: 'location_on',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/settings-panel'),
          icon: CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: _isOfflineMode ? 'cloud_off' : 'cloud_done',
                color: _isOfflineMode
                    ? AppTheme.warningLight
                    : AppTheme.successLight,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Last updated: $_lastUpdated',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary
                      .withValues(alpha: 0.8),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.warningLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.warningLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'cloud_off',
            color: AppTheme.warningLight,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Offline Mode - Showing cached weather data',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.warningLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherAlerts() {
    final activeAlerts = _weatherAlerts
        .where((alert) => !_dismissedAlertIds.contains(alert['id']))
        .toList();

    if (activeAlerts.isEmpty) return SizedBox.shrink();

    return Column(
      children: activeAlerts
          .map((alert) => WeatherAlertBanner(
                alert: alert,
                onDismiss: () => _dismissAlert(alert['id'] as String),
              ))
          .toList(),
    );
  }

  Widget _buildForecastSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              '5-Day Forecast',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            height: 25.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _forecast.length,
              itemBuilder: (context, index) {
                return ForecastCard(forecast: _forecast[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmingRecommendationsSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'agriculture',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Farming Recommendations',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          ..._farmingRecommendations
              .map((recommendation) => FarmingRecommendationCard(
                    recommendation: recommendation,
                  ))
              .toList(),
        ],
      ),
    );
  }

  Future<void> _refreshWeatherData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _lastUpdated = DateTime.now().toString().substring(0, 16);
      _isOfflineMode = false;
    });

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text('Weather data updated successfully'),
          ],
        ),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _dismissAlert(String alertId) {
    setState(() {
      _dismissedAlertIds.add(alertId);
    });
  }

  void _showLocationSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Location',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'my_location',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Use Current Location'),
              subtitle: Text('Enable GPS for accurate weather data'),
              onTap: () {
                Navigator.pop(context);
                _getCurrentLocation();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Search Location'),
              subtitle: Text('Enter city or farm location'),
              onTap: () {
                Navigator.pop(context);
                _showLocationSearch();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _getCurrentLocation() {
    // Simulate location detection
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text('Location updated to current position'),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showLocationSearch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Search Location',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter city or location name',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _refreshWeatherData();
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }
}