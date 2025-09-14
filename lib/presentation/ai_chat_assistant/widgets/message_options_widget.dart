import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageOptionsWidget extends StatelessWidget {
  final String message;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onSave;
  final VoidCallback? onPlayAudio;

  const MessageOptionsWidget({
    Key? key,
    required this.message,
    required this.onCopy,
    required this.onShare,
    required this.onSave,
    this.onPlayAudio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10.w,
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Message Options',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          _buildOptionTile(
            icon: 'content_copy',
            title: 'Copy Message',
            subtitle: 'Copy to clipboard',
            onTap: () {
              onCopy();
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            icon: 'share',
            title: 'Share Message',
            subtitle: 'Share with others',
            onTap: () {
              onShare();
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            icon: 'bookmark',
            title: 'Save Message',
            subtitle: 'Save for later',
            onTap: () {
              onSave();
              Navigator.pop(context);
            },
          ),
          if (onPlayAudio != null)
            _buildOptionTile(
              icon: 'volume_up',
              title: 'Play Audio',
              subtitle: 'Listen to message',
              onTap: () {
                onPlayAudio!();
                Navigator.pop(context);
              },
            ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 5.w,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'chevron_right',
        color: AppTheme.lightTheme.colorScheme.outline,
        size: 5.w,
      ),
    );
  }
}
