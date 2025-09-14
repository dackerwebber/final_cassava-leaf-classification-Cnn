import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> selectedFilters;
  final Function(String) onFilterToggle;
  final VoidCallback onClearFilters;

  const FilterChipsWidget({
    Key? key,
    required this.selectedFilters,
    required this.onFilterToggle,
    required this.onClearFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filterOptions = [
      {'label': 'High Severity', 'value': 'high', 'icon': 'warning'},
      {'label': 'Medium Severity', 'value': 'medium', 'icon': 'info'},
      {'label': 'Low Severity', 'value': 'low', 'icon': 'check_circle'},
      {'label': 'Dry Season', 'value': 'dry', 'icon': 'wb_sunny'},
      {'label': 'Wet Season', 'value': 'wet', 'icon': 'water_drop'},
      {'label': 'All Regions', 'value': 'all_regions', 'icon': 'public'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter by:',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              if (selectedFilters.isNotEmpty)
                TextButton(
                  onPressed: onClearFilters,
                  child: Text(
                    'Clear All',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filterOptions.map((filter) {
                final bool isSelected =
                    selectedFilters.contains(filter['value']);
                return Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: FilterChip(
                    selected: isSelected,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: filter['icon'],
                          size: 14.sp,
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          filter['label'],
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    onSelected: (selected) => onFilterToggle(filter['value']),
                    backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                    selectedColor: AppTheme.lightTheme.colorScheme.primary,
                    checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
