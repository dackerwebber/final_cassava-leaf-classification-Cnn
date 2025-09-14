import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheet({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _filters;
  DateTimeRange? _selectedDateRange;

  final List<String> _diseaseTypes = [
    'Cassava Mosaic Disease',
    'Cassava Brown Streak',
    'Cassava Bacterial Blight',
    'Cassava Green Mite',
    'Healthy',
  ];

  final List<String> _confidenceLevels = [
    'High (80-100%)',
    'Medium (60-79%)',
    'Low (0-59%)',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);

    if (_filters['dateRange'] != null) {
      _selectedDateRange = _filters['dateRange'] as DateTimeRange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Results',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Date Range Filter
                  _buildSectionTitle('Date Range'),
                  SizedBox(height: 1.h),
                  _buildDateRangeSelector(),

                  SizedBox(height: 3.h),

                  // Disease Type Filter
                  _buildSectionTitle('Disease Type'),
                  SizedBox(height: 1.h),
                  _buildDiseaseTypeFilter(),

                  SizedBox(height: 3.h),

                  // Confidence Level Filter
                  _buildSectionTitle('Confidence Level'),
                  SizedBox(height: 1.h),
                  _buildConfidenceLevelFilter(),

                  SizedBox(height: 3.h),

                  // Location Filter
                  _buildSectionTitle('Location'),
                  SizedBox(height: 1.h),
                  _buildLocationFilter(),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 15.sp,
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return GestureDetector(
      onTap: _selectDateRange,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'date_range',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                _selectedDateRange != null
                    ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                    : 'Select date range',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: _selectedDateRange != null
                      ? AppTheme.lightTheme.colorScheme.onSurface
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (_selectedDateRange != null)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDateRange = null;
                    _filters.remove('dateRange');
                  });
                },
                child: CustomIconWidget(
                  iconName: 'clear',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseTypeFilter() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _diseaseTypes.map((disease) {
        final bool isSelected =
            (_filters['diseases'] as List<String>? ?? []).contains(disease);
        return FilterChip(
          label: Text(
            disease,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              fontSize: 11.sp,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.onPrimary
                  : AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              List<String> diseases =
                  List<String>.from(_filters['diseases'] ?? []);
              if (selected) {
                diseases.add(disease);
              } else {
                diseases.remove(disease);
              }
              _filters['diseases'] = diseases;
            });
          },
          selectedColor: AppTheme.lightTheme.colorScheme.primary,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          side: BorderSide(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConfidenceLevelFilter() {
    return Column(
      children: _confidenceLevels.map((level) {
        final bool isSelected =
            (_filters['confidenceLevels'] as List<String>? ?? [])
                .contains(level);
        return CheckboxListTile(
          title: Text(
            level,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 13.sp,
            ),
          ),
          value: isSelected,
          onChanged: (selected) {
            setState(() {
              List<String> levels =
                  List<String>.from(_filters['confidenceLevels'] ?? []);
              if (selected == true) {
                levels.add(level);
              } else {
                levels.remove(level);
              }
              _filters['confidenceLevels'] = levels;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildLocationFilter() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Enter location to filter by',
        prefixIcon: Padding(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: 'location_on',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      ),
      onChanged: (value) {
        _filters['location'] = value.isEmpty ? null : value;
      },
    );
  }

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _filters['dateRange'] = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _selectedDateRange = null;
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
