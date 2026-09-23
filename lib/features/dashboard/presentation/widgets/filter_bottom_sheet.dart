import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../posts/domain/entities/post_filters.dart';
import '../bloc/feed_bloc.dart';

class FilterBottomSheet extends StatefulWidget {
  final PostFilters initialFilters;

  const FilterBottomSheet({
    super.key,
    required this.initialFilters,
  });

  static Future<void> show(BuildContext context, PostFilters initialFilters) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<FeedBloc>(),
        child: FilterBottomSheet(initialFilters: initialFilters),
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedTransactionType;
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTransactionType = widget.initialFilters.transactionType;
    _locationController.text = widget.initialFilters.location ?? '';
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final location = _locationController.text.trim();
    final filters = PostFilters(
      transactionType: _selectedTransactionType,
      location: location.isEmpty ? null : location,
    );
    
    if (filters.isEmpty) {
      context.read<FeedBloc>().add(FeedFilterCleared());
    } else {
      context.read<FeedBloc>().add(FeedFilterApplied(filters));
    }
    
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedTransactionType = null;
      _locationController.clear();
    });
    context.read<FeedBloc>().add(FeedFilterCleared());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24.w,
        right: 24.w,
        top: 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText('Filters', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                color: AppColors.hint,
              ),
            ],
          ),
          SizedBox(height: 24.h),
          
          AppText('Transaction Type', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            children: [
              _buildFilterChip('All', null),
              _buildFilterChip('For Rent', 'FOR_RENT'),
              _buildFilterChip('For Sale', 'FOR_SALE'),
            ],
          ),
          
          SizedBox(height: 24.h),
          AppText('Location', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text),
          SizedBox(height: 12.h),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'Enter location',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
          
          SizedBox(height: 32.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearFilters,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: AppText('Clear', color: AppColors.text, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    elevation: 0,
                  ),
                  child: AppText('Apply Filters', color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _selectedTransactionType == value;
    return ChoiceChip(
      label: AppText(
        label,
        color: isSelected ? Colors.white : AppColors.text,
        fontSize: 13,
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedTransactionType = selected ? value : null;
        });
      },
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      showCheckmark: false,
    );
  }
}
