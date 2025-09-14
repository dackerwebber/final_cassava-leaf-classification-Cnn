import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DiseaseCardWidget extends StatelessWidget {
  final Map<String, dynamic> disease;
  final VoidCallback onTap;

  const DiseaseCardWidget({
    Key? key,
    required this.disease,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String diseaseName = disease['name'] as String? ?? 'Unknown Disease';
    final String severity = disease['severity'] as String? ?? 'Unknown';
    final String imageUrl = disease['imageUrl'] as String? ?? '';
    final String description = disease['description'] as String? ?? '';
    final List<dynamic> affectedRegions =
        disease['affectedRegions'] as List<dynamic>? ?? [];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(3.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disease Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: imageUrl,
                  width: 20.w,
                  height: 15.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.w),

              // Disease Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Disease Name
                    Text(
                      diseaseName,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),

                    // Severity Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color:
                            _getSeverityColor(severity).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getSeverityColor(severity),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        severity.toUpperCase(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: _getSeverityColor(severity),
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),

                    // Description Preview
                    Text(
                      description,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),

                    // Affected Regions
                    if (affectedRegions.isNotEmpty) ...[
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            size: 14.sp,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              (affectedRegions).take(2).join(', '),
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow Icon
              CustomIconWidget(
                iconName: 'chevron_right',
                size: 20.sp,
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
      case 'severe':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
      case 'moderate':
        return AppTheme.warningLight;
      case 'low':
      case 'mild':
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface;
    }
  }
}
