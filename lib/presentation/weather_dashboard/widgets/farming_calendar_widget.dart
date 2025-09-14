import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FarmingCalendarWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const FarmingCalendarWidget({
    Key? key,
    required this.activities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calendar_today',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Farming Calendar',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (activities.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'event_available',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                    size: 8.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'No farming activities scheduled',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            )
          else
            ...activities
                .take(3)
                .map((activity) => _buildActivityItem(activity))
                .toList(),
          if (activities.length > 3) ...[
            SizedBox(height: 1.h),
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to full calendar view
                },
                child: Text(
                  'View All Activities (${activities.length - 3} more)',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: _getActivityBackgroundColor(
            activity['priority'] as String? ?? 'medium'),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getActivityBorderColor(
              activity['priority'] as String? ?? 'medium'),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getActivityIconBackgroundColor(
                  activity['priority'] as String? ?? 'medium'),
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomIconWidget(
              iconName:
                  _getActivityIcon(activity['type'] as String? ?? 'general'),
              color: _getActivityIconColor(
                  activity['priority'] as String? ?? 'medium'),
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (activity['title'] as String?) ?? 'Farming Activity',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  (activity['description'] as String?) ??
                      'Weather-dependent farming task',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (activity['date'] != null) ...[
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        (activity['date'] as String?) ?? 'Today',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
            decoration: BoxDecoration(
              color: _getActivityIconColor(
                      activity['priority'] as String? ?? 'medium')
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              (activity['priority'] as String? ?? 'Medium').toUpperCase(),
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: _getActivityIconColor(
                    activity['priority'] as String? ?? 'medium'),
                fontWeight: FontWeight.w600,
                fontSize: 9.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getActivityBackgroundColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.05);
      case 'medium':
        return AppTheme.warningLight.withValues(alpha: 0.05);
      case 'low':
        return AppTheme.successLight.withValues(alpha: 0.05);
      default:
        return AppTheme.infoLight.withValues(alpha: 0.05);
    }
  }

  Color _getActivityBorderColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.2);
      case 'medium':
        return AppTheme.warningLight.withValues(alpha: 0.2);
      case 'low':
        return AppTheme.successLight.withValues(alpha: 0.2);
      default:
        return AppTheme.infoLight.withValues(alpha: 0.2);
    }
  }

  Color _getActivityIconBackgroundColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
      case 'medium':
        return AppTheme.warningLight.withValues(alpha: 0.1);
      case 'low':
        return AppTheme.successLight.withValues(alpha: 0.1);
      default:
        return AppTheme.infoLight.withValues(alpha: 0.1);
    }
  }

  Color _getActivityIconColor(String priority) {
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

  String _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'planting':
        return 'eco';
      case 'watering':
      case 'irrigation':
        return 'water_drop';
      case 'fertilizing':
        return 'grass';
      case 'harvesting':
        return 'agriculture';
      case 'pest_control':
        return 'bug_report';
      case 'soil_preparation':
        return 'landscape';
      default:
        return 'event';
    }
  }
}
