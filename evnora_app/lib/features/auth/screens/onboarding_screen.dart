import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';

import '../../../config/routes.dart';
import '../../../config/themes.dart';
import '../../../config/constants.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Form controllers
  final _designationController = TextEditingController();
  final _locationController = TextEditingController();
  final _experienceController = TextEditingController();
  
  String? _selectedResumeFile;
  String? _selectedFileName;
  List<String> _selectedSkills = [];
  
  final List<String> _availableSkills = [
    'Welding', 'Fabrication', 'Electrical', 'Plumbing', 'HVAC',
    'Project Management', 'AutoCAD', 'Safety Management', 'Quality Control',
    'Machine Operation', 'Pipe Fitting', 'Rigging', 'Scaffolding',
    'NDT', 'HSE', 'Planning', 'Civil Works', 'Mechanical', 'Instrumentation',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _designationController.dispose();
    _locationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: AppConstants.allowedResumeFormats,
    );

    if (result != null) {
      final file = result.files.first;
      if (file.size <= AppConstants.maxResumeSize) {
        setState(() {
          _selectedResumeFile = file.path;
          _selectedFileName = file.name;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size must be less than 5MB'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _completeOnboarding() async {
    // Upload resume if selected
    if (_selectedResumeFile != null && _selectedFileName != null) {
      await ref.read(authStateProvider.notifier).uploadResume(
            filePath: _selectedResumeFile!,
            fileName: _selectedFileName!,
          );
    }

    // Update profile
    await ref.read(authStateProvider.notifier).updateProfile({
      'designation': _designationController.text.trim(),
      'location': _locationController.text.trim(),
      'experience': _experienceController.text.trim(),
      'skills': _selectedSkills,
    });

    await ref.read(authStateProvider.notifier).completeOnboarding();

    if (mounted) {
      context.go(AppRoutes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back_ios),
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: index == _currentPage ? 32 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: index <= _currentPage
                                ? AppColors.primary
                                : AppColors.grey200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildProfilePage(user?.fullName ?? ''),
                  _buildSkillsPage(),
                  _buildResumePage(),
                ],
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(24),
              child: CustomButton(
                text: _currentPage == 2 ? 'Complete Setup' : 'Continue',
                onPressed: _nextPage,
                isLoading: authState.isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage(String userName) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi ${userName.split(' ').first}! 👋',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            "Let's complete your profile to find the best opportunities for you.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.grey500,
                ),
          ),
          const SizedBox(height: 32),

          // Designation
          CustomTextField(
            controller: _designationController,
            label: 'Current/Desired Designation',
            hint: 'e.g. Mechanical Engineer, Welder',
            prefixIcon: Icons.work_outline,
          ),
          const SizedBox(height: 20),

          // Location
          CustomTextField(
            controller: _locationController,
            label: 'Preferred Job Location',
            hint: 'e.g. Mumbai, Dubai, Singapore',
            prefixIcon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 20),

          // Experience
          CustomTextField(
            controller: _experienceController,
            label: 'Years of Experience',
            hint: 'e.g. 5',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.timeline,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What are your skills?',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Select the skills that match your expertise',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.grey500,
                ),
          ),
          const SizedBox(height: 24),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableSkills.map((skill) {
              final isSelected = _selectedSkills.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedSkills.add(skill);
                    } else {
                      _selectedSkills.remove(skill);
                    }
                  });
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.grey700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          if (_selectedSkills.isNotEmpty) ...[
            Text(
              'Selected Skills (${_selectedSkills.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedSkills.map((skill) {
                return Chip(
                  label: Text(skill),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() => _selectedSkills.remove(skill));
                  },
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  labelStyle: const TextStyle(color: AppColors.primary),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResumePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Your Resume',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Help employers find you faster with your resume',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.grey500,
                ),
          ),
          const SizedBox(height: 32),

          // Upload area
          GestureDetector(
            onTap: _pickResume,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _selectedFileName != null
                      ? AppColors.success
                      : AppColors.grey200,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: _selectedFileName != null
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _selectedFileName != null
                          ? Icons.check_circle
                          : Icons.cloud_upload_outlined,
                      size: 32,
                      color: _selectedFileName != null
                          ? AppColors.success
                          : AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_selectedFileName != null) ...[
                    Text(
                      'Resume Selected',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.success,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedFileName!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _pickResume,
                      child: const Text('Change File'),
                    ),
                  ] else ...[
                    Text(
                      'Tap to upload your resume',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Supported formats: PDF, DOC, DOCX\nMax file size: 5MB',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.grey500,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Benefits
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Why upload a resume?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildBenefitItem('Get noticed by top employers'),
                _buildBenefitItem('Apply to jobs with one click'),
                _buildBenefitItem('Increase your chances by 500%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: AppColors.success),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
