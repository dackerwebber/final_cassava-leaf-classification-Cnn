import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dashboard_card_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/weather_summary_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;

  // Mock data for dashboard
  final Map<String, dynamic> farmerData = {
    "name": "Great Farmer",
    "location": "Africa, Ghana",
    "totalScans": 47,
    "healthyPlants": 32,
    "diseasedPlants": 15,
    "lastScanDate": "...",
  };

  final Map<String, dynamic> weatherData = {
    "temperature": "28°C",
    "condition": "Partly Cloudy",
    "humidity": "65%",
    "windSpeed": "12 km/h",
    "icon": "wb_cloudy",
  };

  final List<Map<String, dynamic>> recentScans = [
    {
      "id": 1,
      "plantName": "Cassava Plant #1",
      "result": "Healthy",
      "confidence": 94.5,
      "date": "2025-08-26 14:30",
      "status": "healthy"
    },
    {
      "id": 2,
      "plantName": "Cassava Plant #2",
      "result": "Cassava Mosaic Disease",
      "confidence": 87.2,
      "date": "2025-08-26 12:15",
      "status": "diseased"
    },
    {
      "id": 3,
      "plantName": "Cassava Plant #3",
      "result": "Brown Leaf Spot",
      "confidence": 91.8,
      "date": "2025-08-25 16:45",
      "status": "diseased"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticFeedback.lightImpact();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dashboard updated successfully'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToScreen(String route) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, route);
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Text(
                    'Quick Actions',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickActionButton(
                        'Camera Scan',
                        'camera_alt',
                        () => _navigateToScreen('/select-scan'), // <-- Use selectScan route
                      ),
                      _buildQuickActionButton(
                        'Chat Assistant',
                        'chat',
                        () => _navigateToScreen('/ai-chat-assistant'),
                      ),
                      _buildQuickActionButton(
                        'Weather',
                        'wb_sunny',
                        () => _navigateToScreen('/weather-dashboard'),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
      String label, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'home',
                      color: _tabController.index == 0
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Home',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'local_hospital',
                      color: _tabController.index == 1
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Diseases',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'wb_cloudy',
                      color: _tabController.index == 2
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Weather',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'history',
                      color: _tabController.index == 3
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'History',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'settings',
                      color: _tabController.index == 4
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Settings',
                  ),
                ],
                onTap: (index) {
                  if (index != 0) {
                    // Navigate to other screens
                    switch (index) {
                      case 1:
                        _navigateToScreen('/common-diseases-library');
                        break;
                      case 2:
                        _navigateToScreen('/weather-dashboard');
                        break;
                      case 3:
                        _navigateToScreen('/scan-history');
                        break;
                      case 4:
                        _navigateToScreen('/settings-panel');
                        break;
                    }
                    // Reset to home tab
                    _tabController.animateTo(0);
                  }
                },
              ),
            ),

            // Main Content
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refreshDashboard,
                color: AppTheme.lightTheme.primaryColor,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Header
                      GreetingHeaderWidget(
                        farmerName: farmerData["name"] as String,
                        greeting: _getGreeting(),
                      ),

                      // Weather Summary
                      WeatherSummaryWidget(
                        location: farmerData["location"] as String,
                        temperature: weatherData["temperature"] as String,
                        condition: weatherData["condition"] as String,
                        humidity: weatherData["humidity"] as String,
                        windSpeed: weatherData["windSpeed"] as String,
                        iconName: weatherData["icon"] as String,
                      ),

                      // Quick Stats
                      QuickStatsWidget(
                        totalScans: farmerData["totalScans"] as int,
                        healthyPlants: farmerData["healthyPlants"] as int,
                        diseasedPlants: farmerData["diseasedPlants"] as int,
                      ),

                      SizedBox(height: 2.h),

                      // Section Title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          'Quick Actions',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Primary Scan Card
                      DashboardCardWidget(
                        title: 'Scan Cassava Leaf',
                        subtitle: 'Take a photo to detect diseases instantly',
                        iconName: 'camera_alt',
                        isPrimary: true,
                        backgroundColor: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.05),
                        iconColor: AppTheme.lightTheme.primaryColor,
                        onTap: () => _navigateToScreen('/camera-scan-screen'),
                      ),

                      // Secondary Cards Grid
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            DashboardCardWidget(
                              title: 'Common Diseases',
                              subtitle: 'Learn about cassava diseases',
                              iconName: 'local_hospital',
                              iconColor: AppTheme.diseaseRed,
                              onTap: () =>
                                  _navigateToScreen('/common-diseases-library'),
                            ),
                            DashboardCardWidget(
                              title: 'Weather Forecast',
                              subtitle: 'Check farming conditions',
                              iconName: 'wb_sunny',
                              iconColor: AppTheme.sunYellow,
                              onTap: () =>
                                  _navigateToScreen('/weather-dashboard'),
                            ),
                            DashboardCardWidget(
                              title: 'Chat Assistant',
                              subtitle: 'Get farming advice',
                              iconName: 'chat',
                              iconColor: AppTheme.infoBlue,
                              onTap: () =>
                                  _navigateToScreen('/ai-chat-assistant'),
                            ),
                            DashboardCardWidget(
                              title: 'Recent Scans',
                              subtitle: 'View scan history',
                              iconName: 'history',
                              badgeText: recentScans.length.toString(),
                              onTap: () => _navigateToScreen('/scan-history'),
                            ),
                          ],
                        ),
                      ),

                      // Recent Activity Section
                      if (recentScans.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Activity',
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _navigateToScreen('/scan-history'),
                                child: Text(
                                  'View All',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 1.h),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: recentScans.take(3).length,
                          itemBuilder: (context, index) {
                            final scan = recentScans[index];
                            final isHealthy =
                                (scan["status"] as String) == "healthy";

                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 0.5.h),
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      color: (isHealthy
                                              ? AppTheme.healthyGreen
                                              : AppTheme.diseaseRed)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: isHealthy ? 'eco' : 'warning',
                                      color: isHealthy
                                          ? AppTheme.healthyGreen
                                          : AppTheme.diseaseRed,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          scan["plantName"] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          scan["result"] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: isHealthy
                                                ? AppTheme.healthyGreen
                                                : AppTheme.diseaseRed,
                                          ),
                                        ),
                                        Text(
                                          scan["date"] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${(scan["confidence"] as double).toStringAsFixed(1)}%',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.lightTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],

                      SizedBox(height: 10.h), // Bottom padding for FAB
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickActions(context),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'Quick Scan',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
