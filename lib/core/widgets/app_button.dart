import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 50.0,
    this.borderRadius = 8.0,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: width?.w ?? double.infinity,
      height: height.h,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          disabledBackgroundColor: (backgroundColor ?? AppColors.primary).withValues(alpha: 0.5),
          disabledForegroundColor: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: const CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) ...[
                    leadingIcon!,
                    SizedBox(width: 8.w),
                  ],
                  AppText(
                    text,
                    color: textColor ?? Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16, // AppText handles .spMin natively
                  ),
                  if (trailingIcon != null) ...[
                    SizedBox(width: 8.w),
                    trailingIcon!,
                  ],
                ],
              ),
      ),
    );
  }
}

