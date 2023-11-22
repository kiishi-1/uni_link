import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:uni_link/resources/navigation_service.dart';

class UniLinkFlushBar {
  static void showFailure({
    // required BuildContext context,
    required String message,
    String? title,
    bool showTitle = true,
    Color? color,
    Duration? duration,
  }) {
    Flushbar<dynamic>(
      flushbarPosition: FlushbarPosition.BOTTOM,
      duration: duration ?? const Duration(seconds: 5),
      backgroundColor: color ?? Colors.redAccent,
      margin: const EdgeInsets.all(2),
      borderRadius: BorderRadius.circular(8),
      message: message,
      title: showTitle ? title ?? title : null,
    ).show(NavigationService.instance.navigatorKey.currentContext!);
  }

  /// show success indication
  static void showSuccess({
    // required BuildContext context,
    required String message,
    String? title,
    Color? color,
    Duration? duration,
  }) {
    Flushbar<dynamic>(
      flushbarPosition: FlushbarPosition.TOP,
      duration: duration ?? const Duration(seconds: 5),
      backgroundColor: color ?? Colors.greenAccent,
      margin: const EdgeInsets.all(2),
      borderRadius: BorderRadius.circular(8),
      message: message,
      title: title,
    ).show(
      NavigationService.instance.navigatorKey.currentContext!
    );
  }

  static void showGeneric({
    // required BuildContext context,
    required String message,
    String? title,
    Color? color,
    Duration? duration,
  }) {
    Flushbar<dynamic>(
      flushbarPosition: FlushbarPosition.TOP,
      duration: duration ?? const Duration(seconds: 5),
      backgroundColor: color ?? Colors.greenAccent,
      margin: const EdgeInsets.all(2),
      borderRadius: BorderRadius.circular(8),
      message: message,
      title: title,
    ).show(NavigationService.instance.navigatorKey.currentContext!);
  }
}
