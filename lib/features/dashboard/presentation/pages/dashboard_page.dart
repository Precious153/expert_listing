import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/profile_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/feed_bloc.dart';
import '../../../../core/network/connectivity_cubit.dart';
import '../../../posts/presentation/widgets/post_category_bottom_sheet.dart';
import '../widgets/bottom_nav_bar_widget.dart';
import '../widgets/feed_tab.dart';
import '../widgets/placeholder_tab.dart';
import '../widgets/profile_tab.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 1; // Default to Feed tab based on current active tab visually

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProfileBloc>()..add(ProfileFetched())),
        BlocProvider.value(value: sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<FeedBloc>()..add(FeedFetched())),
        BlocProvider.value(value: sl<ConnectivityCubit>()),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              surfaceTintColor: AppColors.background,
              elevation: 0,
              title: Row(
                children: [
                  Image.asset('assets/images/Logo.png',height: 22.h,),
                ],
              ),
              actions: [
                if (_currentIndex == 1) ...[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.black.withValues(alpha: .1)),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.mail_outline, color: AppColors.text, size: 24.spMin),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 12.w,),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.black.withValues(alpha: .1)),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: AppColors.text, size: 24.spMin),
                      onPressed: () async {
                        final type = await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => const PostCategoryBottomSheet(),
                        );
                        if (type != null && context.mounted) {
                          final result = await context.push<bool>('/create-post', extra: type);
                          if (result == true && context.mounted) {
                            context.read<FeedBloc>().refresh();
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
              ],
            ),
            body: IndexedStack(
              index: _currentIndex,
              children: const [
                PlaceholderTab(title: 'Home'),
                FeedTab(),
                PlaceholderTab(title: 'Wishlist'),
                PlaceholderTab(title: 'Notifications'),
                ProfileTab(),
              ],
            ),
            bottomNavigationBar: BottomNavBarWidget(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          );
        }
      ),
    );
  }
}
