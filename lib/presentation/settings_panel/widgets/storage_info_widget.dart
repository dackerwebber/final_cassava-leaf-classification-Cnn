import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StorageInfoWidget extends StatelessWidget {
  final double usedStorage;
  final double totalStorage;
  final Map<String, double> storageBreakdown;

  const StorageInfoWidget({
    Key? key,
    required this.usedStorage,
    required this.totalStorage,
    required this.storageBreakdown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usagePercentage = (usedStorage / totalStorage).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Storage Usage',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_formatBytes(usedStorage)} / ${_formatBytes(totalStorage)}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: usagePercentage,
              child: Container(
                decoration: BoxDecoration(
                  color: usagePercentage > 0.8
                      ? AppTheme.errorLight
                      : usagePercentage > 0.6
                          ? AppTheme.warningLight
                          : AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          ...storageBreakdown.entries
              .map((entry) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.5.h),
                    child: Row(
                      children: [
                        Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                            color: _getColorForCategory(entry.key),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Text(
                          _formatBytes(entry.value),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  String _formatBytes(double bytes) {
    if (bytes < 1024) return '${bytes.toInt()} B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'app data':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'images':
        return AppTheme.successLight;
      case 'cache':
        return AppTheme.warningLight;
      case 'models':
        return AppTheme.infoLight;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }
}
