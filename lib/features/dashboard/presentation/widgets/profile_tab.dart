import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../auth/presentation/bloc/profile_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/profile_skeleton.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: AppText('Logout', fontSize: 18, fontWeight: FontWeight.w600),
        content: AppText('Are you sure you want to logout?'),
        backgroundColor: AppColors.background,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: AppText('Cancel', color: AppColors.hint),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: AppText('Logout', color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileUnauthenticated) {
                context.read<AuthBloc>().add(LogoutRequested());
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthInitial) {
                context.go('/login');
              }
            },
          ),
        ],
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Expanded(
                  child: BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoading) {
                        return const ProfileSkeleton();
                      } else if (state is ProfileError) {
                        return Center(
                          child: AppText(
                            state.message,
                            color: Colors.red,
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else if (state is ProfileLoaded) {
                        final user = state.user;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText('Personal Information', fontSize: 16, fontWeight: FontWeight.w600),
                            SizedBox(height: 16.h),
                            InfoTile(label: 'First Name', value: user.firstName),
                            SizedBox(height: 12.h),
                            InfoTile(label: 'Last Name', value: user.lastName),
                            SizedBox(height: 12.h),
                            InfoTile(label: 'Email', value: user.email),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () => _showLogoutDialog(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout,color:  Colors.red,),
                      SizedBox(width: 3,),
                      AppText('Logout', fontSize: 14, fontWeight: FontWeight.w400,color:  Colors.red,),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(label, color: AppColors.hint, fontSize: 14),
          AppText(value.isNotEmpty ? value : 'N/A', fontWeight: FontWeight.w600, fontSize: 14),
        ],
      ),
    );
  }
}
