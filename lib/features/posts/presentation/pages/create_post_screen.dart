import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/create_post_request.dart';
import '../bloc/create_post_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreatePostScreen extends StatefulWidget {
  final TransactionType transactionType;

  const CreatePostScreen({super.key, required this.transactionType});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _locationController = TextEditingController();
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText('Add Photo', fontSize: 18, fontWeight: FontWeight.bold, textAlign: TextAlign.center),
            SizedBox(height: 24.h),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary),
              title: AppText('Take Photo', fontSize: 16),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: AppText('Choose from Gallery', fontSize: 16),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = CreatePostRequest(
      content: _contentController.text.trim(),
      location: _locationController.text.trim(),
      transactionType: widget.transactionType,
    );

    File? imageFile;
    if (_selectedImage != null) {
      imageFile = File(_selectedImage!.path);
    }

    context.read<CreatePostBloc>().add(CreatePostSubmitted(request, image: imageFile));
  }

  @override
  void dispose() {
    _contentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String _getCategoryLabel(TransactionType type) {
    switch (type) {
      case TransactionType.sale:
        return 'Property for Sale';
      case TransactionType.rent:
        return 'Property for Rent';
      case TransactionType.general:
        return 'General Discussion';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreatePostBloc>(),
      child: BlocConsumer<CreatePostBloc, CreatePostState>(
        listener: (context, state) {
          if (state is CreatePostSuccess) {
            context.pop(true);
          } else if (state is CreatePostFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is CreatePostSubmitting;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              title: AppText('Create Post', fontSize: 18, fontWeight: FontWeight.w700),
              iconTheme: const IconThemeData(color: AppColors.text),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppText('Categories', fontSize: 16, fontWeight: FontWeight.w600),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: AppText(
                          _getCategoryLabel(widget.transactionType),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      AppText('Description', fontSize: 16, fontWeight: FontWeight.w600),
                      SizedBox(height: 8.h),
                      AppTextField(
                        controller: _contentController,
                        hintText: 'What do you want to share?',
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        validator: (val) => Validators.required(val, 'Content cannot be empty'),
                      ),
                    SizedBox(height: 16.h),
                    AppText('Location', fontSize: 16, fontWeight: FontWeight.w600),
                    SizedBox(height: 8.h),
                    AppTextField(
                      controller: _locationController,
                      labelText: 'Location (Optional)',
                      hintText: 'Add a location',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: SvgPicture.asset('assets/icons/MapPin.svg', width: 20.spMin, height: 20.spMin),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    AppText('Images', fontSize: 16, fontWeight: FontWeight.w600),
                    SizedBox(height: 8.h),
                    if (_selectedImage != null)
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              image: DecorationImage(
                                image: FileImage(File(_selectedImage!.path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: _showImageSourceActionSheet,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: AppText('Change', color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                GestureDetector(
                                  onTap: _removeImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.close, color: Colors.white, size: 16.spMin),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      GestureDetector(
                        onTap: _showImageSourceActionSheet,
                        child: Container(
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate, color: AppColors.hint, size: 32.spMin),
                                SizedBox(height: 8.h),
                                AppText('Add Photo', fontSize: 14, color: AppColors.hint),
                              ],
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 32.h),
                    AppButton(
                      text: 'Create Post',
                      isLoading: isLoading,
                      onPressed: isLoading ? null : () => _submit(context),
                    ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
