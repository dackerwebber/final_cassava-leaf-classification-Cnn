import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/navigation_buttons_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;
  final int _totalPages = 3;

  // Mock onboarding data
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Welcome to CassavaGuard",
      "description":
          "Your smart farming companion that helps protect your cassava crops from diseases using advanced AI technology.",
      "image":
          "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y2Fzc2F2YSUyMHBsYW50fGVufDB8fDB8fHww",
    },
    {
      "title": "AI-Powered Disease Detection",
      "description":
          "Simply take a photo of your cassava leaves and get instant disease identification with treatment recommendations.",
      "image":
          "https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGhvbmUlMjBjYW1lcmF8ZW58MHx8MHx8fDA%3D",
    },
    {
      "title": "Improve Your Harvest",
      "description":
          "Join thousands of farmers who have increased their crop yield and reduced losses with CassavaGuard's expert guidance.",
      "image":
          "https://images.unsplash.com/photo-1500937386664-56d1dfef3854?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8aGFwcHklMjBmYXJtZXJ8ZW58MHx8MHx8fDA%3D",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _navigateToHome();
  }

  void _getStarted() {
    _requestPermissions();
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  Future<void> _requestPermissions() async {
    // Show permission explanation dialog
    final bool? shouldProceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.w),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Flexible(
                child: Text(
                  'Permissions Required',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CassavaGuard needs the following permissions to work effectively:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              _buildPermissionItem(
                'camera',
                'Camera Access',
                'To capture photos of cassava leaves for disease detection',
              ),
              SizedBox(height: 1.h),
              _buildPermissionItem(
                'location_on',
                'Location Access',
                'To provide weather updates and location-specific farming tips',
              ),
              SizedBox(height: 2.h),
              Text(
                'These permissions help us provide you with the best farming experience.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Maybe Later',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
              ),
              child: Text(
                'Allow Permissions',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldProceed == true) {
      // Simulate permission request process
      _showPermissionProgress();
    } else {
      _navigateToHome();
    }
  }

  Widget _buildPermissionItem(
      String iconName, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPermissionProgress() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.w),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(height: 3.h),
              Text(
                'Setting up CassavaGuard...',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Please allow the requested permissions when prompted.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    // Simulate setup process
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close progress dialog
      _navigateToHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: Column(
        children: [
          // Skip button in top-right (only show if not last page)
          if (_currentPage < _totalPages - 1)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 2.h, right: 6.w),
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _skipOnboarding();
                    },
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    ),
                    child: Text(
                      'Skip',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // PageView with onboarding screens
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
                HapticFeedback.selectionClick();
              },
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return OnboardingPageWidget(
                  title: data["title"] as String,
                  description: data["description"] as String,
                  imageUrl: data["image"] as String,
                  isLastPage: index == _totalPages - 1,
                );
              },
            ),
          ),

          // Page indicator
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: PageIndicatorWidget(
              currentPage: _currentPage,
              totalPages: _totalPages,
            ),
          ),

          // Navigation buttons
          NavigationButtonsWidget(
            currentPage: _currentPage,
            totalPages: _totalPages,
            onNext: _nextPage,
            onSkip: _skipOnboarding,
            onGetStarted: _getStarted,
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
