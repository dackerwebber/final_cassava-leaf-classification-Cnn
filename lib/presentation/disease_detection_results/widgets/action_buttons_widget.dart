import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onSaveToHistory;
  final VoidCallback? onShareResults;
  final VoidCallback? onScanAnother;
  final String? resultSummary;

  const ActionButtonsWidget({
    Key? key,
    this.onSaveToHistory,
    this.onShareResults,
    this.onScanAnother,
    this.resultSummary,
  }) : super(key: key);

  void _handleSaveToHistory() {
    if (onSaveToHistory != null) {
      onSaveToHistory!();
      HapticFeedback.lightImpact();
      Fluttertoast.showToast(
        msg: "Results saved to history",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: Colors.white,
      );
    }
  }

  void _handleShareResults(BuildContext context) {
    if (onShareResults != null) {
      onShareResults!();
      HapticFeedback.lightImpact();
    } else if (resultSummary != null) {
      // Fallback sharing implementation
      _showShareDialog(context);
    }
  }

  void _showShareDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Share Results',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  context,
                  'Copy Text',
                  Icons.copy,
                  () {
                    Clipboard.setData(ClipboardData(text: resultSummary ?? ''));
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "Results copied to clipboard",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  },
                ),
                _buildShareOption(
                  context,
                  'Save Image',
                  Icons.download,
                  () {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "Feature coming soon",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  },
                ),
                _buildShareOption(
                  context,
                  'More Options',
                  Icons.more_horiz,
                  () {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "More sharing options coming soon",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(
      BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Save to History Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _handleSaveToHistory,
                icon: CustomIconWidget(
                  iconName: 'bookmark',
                  size: 18,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                label: Text(
                  'Save',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Share Results Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _handleShareResults(context),
                icon: CustomIconWidget(
                  iconName: 'share',
                  size: 18,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                label: Text(
                  'Share',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Scan Another Button
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: onScanAnother,
                icon: CustomIconWidget(
                  iconName: 'camera_alt',
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  'Scan Another',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
