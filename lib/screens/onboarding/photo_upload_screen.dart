// lib/screens/onboarding/photo_upload_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/generated/app_localizations.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../services/api_service.dart';
import '../main_screen.dart';
import 'basic_info_screen.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  List<File?> _photos = List.filled(9, null);
  int _mainPhotoIndex = -1;
  bool _isLoading = false;
  bool _isUploading = false;
  String? _errorMessage;
  int _uploadProgress = 0;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSavedPhotos();
  }

  void _loadSavedPhotos() {
    final onboarding = Provider.of<OnboardingProvider>(context, listen: false);
    if (onboarding.photos != null && onboarding.photos!.isNotEmpty) {
      // Convert paths to File objects (for display)
      for (int i = 0; i < onboarding.photos!.length && i < 9; i++) {
        final path = onboarding.photos![i];
        _photos[i] = File(path);
        if (i == 0) _mainPhotoIndex = 0;
      }
    }
  }

  Future<void> _pickImage(int index) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _photos[index] = File(image.path);
          if (_mainPhotoIndex == -1) {
            _mainPhotoIndex = index;
          }
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image';
      });
    }
  }

  Future<void> _takePhoto(int index) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _photos[index] = File(image.path);
          if (_mainPhotoIndex == -1) {
            _mainPhotoIndex = index;
          }
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to take photo';
      });
    }
  }

  void _showImagePickerOptions(int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto(index);
              },
            ),
            if (_photos[index] != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Remove Photo'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _photos[index] = null;
                    if (_mainPhotoIndex == index) {
                      _mainPhotoIndex = _photos.indexWhere((p) => p != null);
                    }
                  });
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  int get _photoCount => _photos.where((p) => p != null).length;

  bool get _canProceed => _photoCount >= 3;

  void _setMainPhoto(int index) {
    setState(() {
      _mainPhotoIndex = index;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_canProceed) {
      setState(() {
        _errorMessage = 'Please upload at least 3 photos';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
      _errorMessage = null;
    });

    final onboarding = Provider.of<OnboardingProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      // Get the actual photos from provider (they should already be saved)
      // For now, we'll just proceed to completion
      // In real implementation, you would upload photos to the server here
      
      // Build complete request
      final data = onboarding.buildCompleteRequest();

      final success = await authProvider.registerComplete(data, context);

      setState(() => _isUploading = false);

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } else if (mounted) {
        setState(() {
          _errorMessage = authProvider.errorMessage ?? 'Failed to complete profile';
        });
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final bgColor = isDark ? AppTheme.darkBackground : AppTheme.lightBackground;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
    final textMutedColor = isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;
    final onSurfaceColor = colors.onSurface;
    final errorColor = AppTheme.lightError;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurfaceColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Upload Photos',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: onSurfaceColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload Your Photos',
                style: AppTheme.headlineMedium.copyWith(
                  color: onSurfaceColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add at least 3 photos. Tap to upload.',
                style: AppTheme.bodyLarge.copyWith(
                  color: textMutedColor,
                ),
              ),
              const SizedBox(height: 16),

              // Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Uploaded: $_photoCount / 3 (min)',
                    style: AppTheme.labelLarge.copyWith(
                      color: _canProceed ? Colors.green : primaryColor,
                    ),
                  ),
                  Text(
                    'Max 9 photos',
                    style: AppTheme.bodyMedium.copyWith(
                      color: textMutedColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: errorColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: errorColor, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: errorColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_errorMessage != null) const SizedBox(height: 16),

              // Photo grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    final isMain = _mainPhotoIndex == index;
                    final hasPhoto = _photos[index] != null;
                    final isFirstSlot = index == 0;

                    return GestureDetector(
                      onTap: () {
                        if (hasPhoto) {
                          _showImagePickerOptions(index);
                        } else {
                          _showImagePickerOptions(index);
                        }
                      },
                      onLongPress: hasPhoto
                          ? () => _showImagePickerOptions(index)
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isMain
                                ? primaryColor
                                : hasPhoto
                                    ? Colors.transparent
                                    : borderColor,
                            width: isMain ? 3 : 1,
                          ),
                          image: hasPhoto
                              ? DecorationImage(
                                  image: FileImage(_photos[index]!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: Stack(
                          children: [
                            if (!hasPhoto)
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      index == 0
                                          ? Icons.add_a_photo
                                          : Icons.add_photo_alternate,
                                      color: textMutedColor,
                                      size: 28,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      index == 0 ? 'Main' : 'Add',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10,
                                        color: textMutedColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (hasPhoto && isMain)
                              Positioned(
                                top: 4,
                                left: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Main',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            if (hasPhoto && !isMain)
                              Positioned(
                                top: 4,
                                left: 4,
                                child: GestureDetector(
                                  onTap: () => _setMainPhoto(index),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Set Main',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (hasPhoto)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _photos[index] = null;
                                      if (_mainPhotoIndex == index) {
                                        _mainPhotoIndex = _photos.indexWhere(
                                          (p) => p != null,
                                        );
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            // Add badge for empty slots
                            if (!hasPhoto)
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isUploading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textMutedColor,
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size(0, 56),
                      ),
                      child: Text(
                        'Back',
                        style: AppTheme.buttonText.copyWith(
                          color: textMutedColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: (_isUploading || !_canProceed) ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canProceed ? primaryColor : Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        minimumSize: const Size(0, 56),
                      ),
                      child: _isUploading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Uploading...',
                                  style: AppTheme.buttonText,
                                ),
                              ],
                            )
                          : Text(
                              _photoCount >= 3 ? 'Complete' : 'Add 3+ Photos',
                              style: AppTheme.buttonText,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}