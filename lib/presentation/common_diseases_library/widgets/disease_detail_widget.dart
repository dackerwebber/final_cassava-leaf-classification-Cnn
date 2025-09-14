import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DiseaseDetailWidget extends StatefulWidget {
  final Map<String, dynamic> disease;
  final VoidCallback onClose;
  final VoidCallback onBookmark;
  final VoidCallback onShare;
  final bool isBookmarked;

  const DiseaseDetailWidget({
    Key? key,
    required this.disease,
    required this.onClose,
    required this.onBookmark,
    required this.onShare,
    this.isBookmarked = false,
  }) : super(key: key);

  @override
  State<DiseaseDetailWidget> createState() => _DiseaseDetailWidgetState();
}

class _DiseaseDetailWidgetState extends State<DiseaseDetailWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _imageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String diseaseName =
        widget.disease['name'] as String? ?? 'Unknown Disease';
    final String severity = widget.disease['severity'] as String? ?? 'Unknown';
    final String description = widget.disease['description'] as String? ?? '';
    final List<dynamic> images =
        widget.disease['images'] as List<dynamic>? ?? [];
    final List<dynamic> symptoms =
        widget.disease['symptoms'] as List<dynamic>? ?? [];
    final List<dynamic> prevention =
        widget.disease['prevention'] as List<dynamic>? ?? [];
    final List<dynamic> treatment =
        widget.disease['treatment'] as List<dynamic>? ?? [];
    final Map<String, dynamic> seasonalInfo =
        widget.disease['seasonalInfo'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image Gallery
          SliverAppBar(
            expandedHeight: 40.h,
            pinned: true,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            leading: IconButton(
              onPressed: widget.onClose,
              icon: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'arrow_back',
                  size: 20.sp,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: widget.onBookmark,
                icon: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName:
                        widget.isBookmarked ? 'bookmark' : 'bookmark_border',
                    size: 20.sp,
                    color: widget.isBookmarked
                        ? AppTheme.lightTheme.colorScheme.primary
                        : Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onShare,
                icon: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'share',
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Image Gallery
                  if (images.isNotEmpty)
                    PageView.builder(
                      controller: _imageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return CustomImageWidget(
                          imageUrl: images[index] as String,
                          width: double.infinity,
                          height: 40.h,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: 40.h,
                      color: AppTheme
                          .lightTheme.colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'image',
                          size: 40.sp,
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.3),
                        ),
                      ),
                    ),

                  // Image Indicators
                  if (images.length > 1)
                    Positioned(
                      bottom: 2.h,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: images.asMap().entries.map((entry) {
                          return Container(
                            width: 2.w,
                            height: 2.w,
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == entry.key
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Disease Name and Severity
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          diseaseName,
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: _getSeverityColor(severity)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getSeverityColor(severity),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          severity.toUpperCase(),
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: _getSeverityColor(severity),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Description
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Tab Bar
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: AppTheme.lightTheme.colorScheme.primary,
                    unselectedLabelColor: AppTheme
                        .lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    indicatorColor: AppTheme.lightTheme.colorScheme.primary,
                    tabs: [
                      Tab(text: 'Symptoms'),
                      Tab(text: 'Prevention'),
                      Tab(text: 'Treatment'),
                      Tab(text: 'Seasonal'),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Tab Content
                  SizedBox(
                    height: 50.h,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildSymptomsTab(symptoms),
                        _buildPreventionTab(prevention),
                        _buildTreatmentTab(treatment),
                        _buildSeasonalTab(seasonalInfo),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsTab(List<dynamic> symptoms) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: symptoms.length,
      itemBuilder: (context, index) {
        final symptom = symptoms[index] as String;
        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomIconWidget(
                iconName: 'check_circle_outline',
                size: 18.sp,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  symptom,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPreventionTab(List<dynamic> prevention) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: prevention.length,
      itemBuilder: (context, index) {
        final preventionStep = prevention[index] as String;
        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  preventionStep,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTreatmentTab(List<dynamic> treatment) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: treatment.length,
      itemBuilder: (context, index) {
        final treatmentStep = treatment[index] as String;
        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.warningLight.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.warningLight.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomIconWidget(
                iconName: 'medical_services',
                size: 18.sp,
                color: AppTheme.warningLight,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  treatmentStep,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeasonalTab(Map<String, dynamic> seasonalInfo) {
    final String bestSeason =
        seasonalInfo['bestSeason'] as String? ?? 'All seasons';
    final String riskPeriod =
        seasonalInfo['riskPeriod'] as String? ?? 'Unknown';
    final List<dynamic> tips = seasonalInfo['tips'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Best Season
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'wb_sunny',
                      size: 18.sp,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Best Prevention Season',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  bestSeason,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Risk Period
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'warning',
                      size: 18.sp,
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'High Risk Period',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  riskPeriod,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Seasonal Tips
          if (tips.isNotEmpty) ...[
            Text(
              'Seasonal Tips',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            ...tips
                .map((tip) => Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme
                            .lightTheme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomIconWidget(
                            iconName: 'lightbulb_outline',
                            size: 16.sp,
                            color: AppTheme.warningLight,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              tip as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ],
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
