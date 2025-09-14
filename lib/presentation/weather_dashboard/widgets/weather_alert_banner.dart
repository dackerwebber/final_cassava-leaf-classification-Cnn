import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherAlertBanner extends StatelessWidget {
  final Map<String, dynamic> alert;
  final VoidCallback? onDismiss;

  const WeatherAlertBanner({
    Key? key,
    required this.alert,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: _getAlertBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getAlertBorderColor(),
          width: 2,
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
                  color: _getAlertIconBackgroundColor(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: _getAlertIcon(),
                  color: _getAlertIconColor(),
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (alert['title'] as String?) ?? 'Weather Alert',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getAlertTextColor(),
                      ),
                    ),
                    if (alert['severity'] != null)
                      Container(
                        margin: EdgeInsets.only(top: 0.5.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getAlertIconColor().withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          (alert['severity'] as String?) ?? 'Moderate',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: _getAlertIconColor(),
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (onDismiss != null)
                GestureDetector(
                  onTap: onDismiss,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: _getAlertTextColor().withValues(alpha: 0.7),
                      size: 5.w,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            (alert['description'] as String?) ??
                'Weather conditions may affect farming activities',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: _getAlertTextColor().withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
          if (alert['validUntil'] != null) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: _getAlertTextColor().withValues(alpha: 0.7),
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Valid until: ${alert['validUntil'] as String}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _getAlertTextColor().withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getAlertBackgroundColor() {
    final severity = alert['severity'] as String? ?? 'moderate';
    switch (severity.toLowerCase()) {
      case 'severe':
      case 'extreme':
        return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
      case 'moderate':
        return AppTheme.warningLight.withValues(alpha: 0.1);
      case 'minor':
        return AppTheme.infoLight.withValues(alpha: 0.1);
      default:
        return AppTheme.warningLight.withValues(alpha: 0.1);
    }
  }

  Color _getAlertBorderColor() {
    final severity = alert['severity'] as String? ?? 'moderate';
    switch (severity.toLowerCase()) {
      case 'severe':
      case 'extreme':
        return AppTheme.lightTheme.colorScheme.error;
      case 'moderate':
        return AppTheme.warningLight;
      case 'minor':
        return AppTheme.infoLight;
      default:
        return AppTheme.warningLight;
    }
  }

  Color _getAlertIconBackgroundColor() {
    final severity = alert['severity'] as String? ?? 'moderate';
    switch (severity.toLowerCase()) {
      case 'severe':
      case 'extreme':
        return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.2);
      case 'moderate':
        return AppTheme.warningLight.withValues(alpha: 0.2);
      case 'minor':
        return AppTheme.infoLight.withValues(alpha: 0.2);
      default:
        return AppTheme.warningLight.withValues(alpha: 0.2);
    }
  }

  Color _getAlertIconColor() {
    final severity = alert['severity'] as String? ?? 'moderate';
    switch (severity.toLowerCase()) {
      case 'severe':
      case 'extreme':
        return AppTheme.lightTheme.colorScheme.error;
      case 'moderate':
        return AppTheme.warningLight;
      case 'minor':
        return AppTheme.infoLight;
      default:
        return AppTheme.warningLight;
    }
  }

  Color _getAlertTextColor() {
    final severity = alert['severity'] as String? ?? 'moderate';
    switch (severity.toLowerCase()) {
      case 'severe':
      case 'extreme':
        return AppTheme.lightTheme.colorScheme.error;
      case 'moderate':
        return AppTheme.warningLight;
      case 'minor':
        return AppTheme.infoLight;
      default:
        return AppTheme.warningLight;
    }
  }

  String _getAlertIcon() {
    final type = alert['type'] as String? ?? 'weather';
    switch (type.toLowerCase()) {
      case 'storm':
      case 'thunderstorm':
        return 'flash_on';
      case 'rain':
      case 'flood':
        return 'grain';
      case 'wind':
        return 'air';
      case 'temperature':
      case 'heat':
        return 'thermostat';
      case 'drought':
        return 'wb_sunny';
      default:
        return 'warning';
    }
  }
}
