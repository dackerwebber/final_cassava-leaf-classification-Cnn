import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ToggleSwitchWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const ToggleSwitchWidget({
    Key? key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: AppTheme.lightTheme.colorScheme.primary,
      inactiveThumbColor: AppTheme.lightTheme.colorScheme.outline,
      inactiveTrackColor:
          AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
