import 'package:flutter/material.dart';

import 'global_configs.dart';

ButtonStyle buttonStyle = ButtonStyle(
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: globalBorderRadius * 1.5,
    ),
  ),
);
