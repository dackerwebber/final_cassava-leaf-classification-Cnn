import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ForecastCard extends StatelessWidget {
  final Map<String, dynamic> forecast;

  const ForecastCard({
    Key? key,
    required this.forecast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      margin: EdgeInsets.only(right: 3.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            (forecast['day'] as String?) ?? 'Today',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.h),
          CustomIconWidget(
            iconName:
                _getWeatherIcon(forecast['condition'] as String? ?? 'clear'),
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 8.w,
          ),
          SizedBox(height: 1.h),
          Text(
            '${(forecast['high'] as num?)?.toInt() ?? 0}°',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          Text(
            '${(forecast['low'] as num?)?.toInt() ?? 0}°',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 0.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'grain',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 3.w,
              ),
              SizedBox(width: 1.w),
              Text(
                '${(forecast['precipitation'] as num?)?.toInt() ?? 0}%',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 10.sp,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return 'wb_sunny';
      case 'cloudy':
      case 'overcast':
        return 'cloud';
      case 'rainy':
      case 'rain':
        return 'grain';
      case 'stormy':
      case 'thunderstorm':
        return 'flash_on';
      case 'partly cloudy':
        return 'partly_cloudy_day';
      default:
        return 'wb_sunny';
    }
  }
}
