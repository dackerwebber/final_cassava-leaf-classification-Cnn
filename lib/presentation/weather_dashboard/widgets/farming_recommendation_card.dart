import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FarmingRecommendationCard extends StatelessWidget {
  final Map<String, dynamic> recommendation;

  const FarmingRecommendationCard({
    Key? key,
    required this.recommendation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: _getRecommendationIcon(),
                  color: _getIconColor(),
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (recommendation['title'] as String?) ?? 'Farming Tip',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    if (recommendation['priority'] != null)
                      Container(
                        margin: EdgeInsets.only(top: 0.5.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getPriorityColor().withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          (recommendation['priority'] as String?) ?? 'Medium',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: _getPriorityColor(),
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            (recommendation['description'] as String?) ??
                'Weather-based farming recommendation',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
          if (recommendation['action'] != null) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      (recommendation['action'] as String?) ??
                          'Take action based on weather conditions',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    final type = recommendation['type'] as String? ?? 'info';
    switch (type.toLowerCase()) {
      case 'warning':
        return AppTheme.warningLight.withValues(alpha: 0.05);
      case 'alert':
        return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.05);
      case 'success':
        return AppTheme.successLight.withValues(alpha: 0.05);
      default:
        return AppTheme.infoLight.withValues(alpha: 0.05);
    }
  }

  Color _getBorderColor() {
    final type = recommendation['type'] as String? ?? 'info';
    switch (type.toLowerCase()) {
      case 'warning':
        return AppTheme.warningLight.withValues(alpha: 0.3);
      case 'alert':
        return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3);
      case 'success':
        return AppTheme.successLight.withValues(alpha: 0.3);
      default:
        return AppTheme.infoLight.withValues(alpha: 0.3);
    }
  }

  Color _getIconBackgroundColor() {
    final type = recommendation['type'] as String? ?? 'info';
    switch (type.toLowerCase()) {
      case 'warning':
        return AppTheme.warningLight.withValues(alpha: 0.1);
      case 'alert':
        return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
      case 'success':
        return AppTheme.successLight.withValues(alpha: 0.1);
      default:
        return AppTheme.infoLight.withValues(alpha: 0.1);
    }
  }

  Color _getIconColor() {
    final type = recommendation['type'] as String? ?? 'info';
    switch (type.toLowerCase()) {
      case 'warning':
        return AppTheme.warningLight;
      case 'alert':
        return AppTheme.lightTheme.colorScheme.error;
      case 'success':
        return AppTheme.successLight;
      default:
        return AppTheme.infoLight;
    }
  }

  Color _getPriorityColor() {
    final priority = recommendation['priority'] as String? ?? 'medium';
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.successLight;
      default:
        return AppTheme.infoLight;
    }
  }

  String _getRecommendationIcon() {
    final type = recommendation['type'] as String? ?? 'info';
    switch (type.toLowerCase()) {
      case 'warning':
        return 'warning';
      case 'alert':
        return 'error';
      case 'success':
        return 'check_circle';
      case 'planting':
        return 'eco';
      case 'irrigation':
        return 'water_drop';
      case 'disease':
        return 'bug_report';
      default:
        return 'info';
    }
  }
}
