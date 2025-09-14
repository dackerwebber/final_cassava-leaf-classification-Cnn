import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingAnimation;

  bool _isModelLoading = true;
  bool _hasError = false;
  double _loadingProgress = 0.0;
  String _loadingText = "Initializing CassavaGuard...";

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Loading animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate model loading with progress updates
      await _loadTensorFlowModel();

      // Check onboarding status
      await _checkOnboardingStatus();

      // Load user preferences
      await _loadUserPreferences();

      // Prepare cached content
      await _prepareCachedContent();

      // Initialize camera permissions
      await _initializeCameraPermissions();

      // Navigate to appropriate screen
      await _navigateToNextScreen();
    } catch (e) {
      setState(() {
        _hasError = true;
        _isModelLoading = false;
        _loadingText = "Initialization failed";
      });
    }
  }

  Future<void> _loadTensorFlowModel() async {
    setState(() {
      _loadingText = "Loading AI model...";
      _loadingProgress = 0.1;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _loadingProgress = 0.4;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      _loadingText = "Preparing disease detection...";
      _loadingProgress = 0.7;
    });

    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _checkOnboardingStatus() async {
    setState(() {
      _loadingText = "Checking user preferences...";
      _loadingProgress = 0.8;
    });

    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _loadUserPreferences() async {
    setState(() {
      _loadingProgress = 0.85;
    });

    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> _prepareCachedContent() async {
    setState(() {
      _loadingText = "Preparing educational content...";
      _loadingProgress = 0.9;
    });

    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _initializeCameraPermissions() async {
    setState(() {
      _loadingText = "Setting up camera...";
      _loadingProgress = 0.95;
    });

    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> _navigateToNextScreen() async {
    setState(() {
      _loadingText = "Ready to go!";
      _loadingProgress = 1.0;
      _isModelLoading = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate checking if user has completed onboarding
    bool hasCompletedOnboarding =
        false; // This would come from SharedPreferences

    if (mounted) {
      if (hasCompletedOnboarding) {
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      }
    }
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _isModelLoading = true;
      _loadingProgress = 0.0;
      _loadingText = "Retrying initialization...";
    });

    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hide system status bar on Android
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primaryContainer,
              AppTheme.lightTheme.colorScheme.secondary,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo section
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Opacity(
                          opacity: _logoFadeAnimation.value,
                          child: _buildLogo(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Loading section
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isModelLoading && !_hasError) ...[
                        _buildLoadingIndicator(),
                        SizedBox(height: 3.h),
                        _buildLoadingText(),
                        SizedBox(height: 2.h),
                        _buildProgressBar(),
                      ] else if (_hasError) ...[
                        _buildErrorSection(),
                      ] else ...[
                        _buildSuccessSection(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 35.w,
      height: 35.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'eco',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 12.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'CassavaGuard',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _loadingAnimation.value * 2 * 3.14159,
          child: Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: CustomPaint(
              painter: _LoadingPainter(
                progress: _loadingProgress,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingText() {
    return Text(
      _loadingText,
      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        color: Colors.white,
        fontSize: 14.sp,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildProgressBar() {
    return Container(
      width: double.infinity,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(0.25.h),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: _loadingProgress,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0.25.h),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorSection() {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: Colors.white,
          size: 8.w,
        ),
        SizedBox(height: 2.h),
        Text(
          'Initialization failed',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Text(
          'Please check your connection and try again',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 3.h),
        ElevatedButton(
          onPressed: _retryInitialization,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.lightTheme.colorScheme.primary,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Retry',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessSection() {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'check_circle',
          color: Colors.white,
          size: 8.w,
        ),
        SizedBox(height: 2.h),
        Text(
          'Ready to protect your cassava!',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LoadingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _LoadingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start from top
      2 * 3.14159 * progress, // Progress arc
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
