import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NavigationButtonsWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onGetStarted;

  const NavigationButtonsWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
    required this.onGetStarted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = currentPage == totalPages - 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skip button (only show if not last page)
          isLastPage
              ? SizedBox(width: 20.w)
              : TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onSkip();
                  },
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    minimumSize: Size(20.w, 6.h),
                  ),
                  child: Text(
                    'Skip',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ),

          // Next/Get Started button
          ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              isLastPage ? onGetStarted() : onNext();
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              minimumSize: Size(30.w, 6.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.h),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isLastPage ? 'Get Started' : 'Next',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: isLastPage ? 'check' : 'arrow_forward',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
