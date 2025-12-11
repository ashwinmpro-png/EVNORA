import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/themes.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';

class ResumeBuilderScreen extends ConsumerStatefulWidget {
  const ResumeBuilderScreen({super.key});

  @override
  ConsumerState<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends ConsumerState<ResumeBuilderScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  // Personal Info
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _summaryController = TextEditingController();
  
  // Experience
  final List<Map<String, dynamic>> _experiences = [];
  
  // Education
  final List<Map<String, dynamic>> _educations = [];
  
  // Skills
  final List<String> _skills = [];
  final _skillController = TextEditingController();
  
  // Certifications
  final List<Map<String, dynamic>> _certifications = [];

  final List<String> _steps = [
    'Personal Info',
    'Experience',
    'Education',
    'Skills',
    'Preview',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _summaryController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _addExperience() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _ExperienceForm(
        onSave: (experience) {
          setState(() => _experiences.add(experience));
        },
      ),
    );
  }

  void _addEducation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _EducationForm(
        onSave: (education) {
          setState(() => _educations.add(education));
        },
      ),
    );
  }

  void _addSkill(String skill) {
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  void _generateResume() {
    // TODO: Generate PDF resume
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resume generated successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Resume Builder'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Progress Steps
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.white,
            child: Column(
              children: [
                Row(
                  children: List.generate(_steps.length, (index) {
                    final isCompleted = index < _currentStep;
                    final isCurrent = index == _currentStep;
                    return Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isCompleted || isCurrent
                                        ? AppColors.primary
                                        : AppColors.grey200,
                                  ),
                                  child: Center(
                                    child: isCompleted
                                        ? const Icon(Icons.check, color: AppColors.white, size: 16)
                                        : Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              color: isCurrent ? AppColors.white : AppColors.grey500,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _steps[index],
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: isCurrent ? AppColors.primary : AppColors.grey500,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          if (index < _steps.length - 1)
                            Expanded(
                              child: Container(
                                height: 2,
                                color: isCompleted ? AppColors.primary : AppColors.grey200,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          
          // Page Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) => setState(() => _currentStep = page),
              children: [
                _buildPersonalInfoPage(),
                _buildExperiencePage(),
                _buildEducationPage(),
                _buildSkillsPage(),
                _buildPreviewPage(),
              ],
            ),
          ),
          
          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey900.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: CustomButton(
                      text: 'Back',
                      variant: ButtonVariant.outlined,
                      onPressed: _previousStep,
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: _currentStep == _steps.length - 1 ? 'Generate Resume' : 'Next',
                    onPressed: _currentStep == _steps.length - 1 ? _generateResume : _nextStep,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Start with your basic contact details',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                ),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _phoneController,
            label: 'Phone',
            hint: 'Enter your phone number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _locationController,
            label: 'Location',
            hint: 'City, Country',
            prefixIcon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _summaryController,
            label: 'Professional Summary',
            hint: 'Write a brief summary about yourself',
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildExperiencePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Work Experience',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your work history, starting with the most recent',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                ),
          ),
          const SizedBox(height: 24),
          
          // Experience List
          ..._experiences.asMap().entries.map((entry) {
            final exp = entry.value;
            return _buildExperienceCard(exp, entry.key);
          }),
          
          // Add Experience Button
          OutlinedButton.icon(
            onPressed: _addExperience,
            icon: const Icon(Icons.add),
            label: const Text('Add Experience'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(Map<String, dynamic> exp, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exp['title'] ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      exp['company'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.grey600,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () => setState(() => _experiences.removeAt(index)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEducationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your educational background',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                ),
          ),
          const SizedBox(height: 24),
          
          // Education List
          ..._educations.asMap().entries.map((entry) {
            final edu = entry.value;
            return _buildEducationCard(edu, entry.key);
          }),
          
          // Add Education Button
          OutlinedButton.icon(
            onPressed: _addEducation,
            icon: const Icon(Icons.add),
            label: const Text('Add Education'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard(Map<String, dynamic> edu, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  edu['degree'] ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  edu['institution'] ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey600,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => setState(() => _educations.removeAt(index)),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your technical and soft skills',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                ),
          ),
          const SizedBox(height: 24),
          
          CustomTextField(
            controller: _skillController,
            label: 'Add Skill',
            hint: 'Type a skill and press enter',
            prefixIcon: Icons.add,
            onSubmitted: _addSkill,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.primary),
              onPressed: () => _addSkill(_skillController.text),
            ),
          ),
          
          const SizedBox(height: 16),
          
          if (_skills.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills.map((skill) {
                return Chip(
                  label: Text(skill),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => setState(() => _skills.remove(skill)),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  labelStyle: const TextStyle(color: AppColors.primary),
                  deleteIconColor: AppColors.primary,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Review your resume before generating',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                ),
          ),
          const SizedBox(height: 24),
          
          // Resume Preview Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey900.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  _nameController.text.isEmpty ? 'Your Name' : _nameController.text,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${_emailController.text} • ${_phoneController.text}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey600,
                      ),
                ),
                if (_locationController.text.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _locationController.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey600,
                        ),
                  ),
                ],
                
                if (_summaryController.text.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Summary',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(_summaryController.text),
                ],
                
                if (_experiences.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Experience',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ..._experiences.map((exp) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('• ${exp['title']} at ${exp['company']}'),
                      )),
                ],
                
                if (_educations.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Education',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ..._educations.map((edu) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('• ${edu['degree']} - ${edu['institution']}'),
                      )),
                ],
                
                if (_skills.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Skills',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _skills.map((skill) => Chip(
                          label: Text(skill, style: const TextStyle(fontSize: 12)),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        )).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const _ExperienceForm({required this.onSave});

  @override
  State<_ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<_ExperienceForm> {
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Experience',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: _titleController,
            label: 'Job Title',
            hint: 'e.g. Project Manager',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _companyController,
            label: 'Company',
            hint: 'Company name',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Describe your responsibilities',
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Add',
            onPressed: () {
              widget.onSave({
                'title': _titleController.text,
                'company': _companyController.text,
                'description': _descriptionController.text,
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _EducationForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const _EducationForm({required this.onSave});

  @override
  State<_EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<_EducationForm> {
  final _degreeController = TextEditingController();
  final _institutionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Education',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: _degreeController,
            label: 'Degree',
            hint: 'e.g. Bachelor of Engineering',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _institutionController,
            label: 'Institution',
            hint: 'University/College name',
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Add',
            onPressed: () {
              widget.onSave({
                'degree': _degreeController.text,
                'institution': _institutionController.text,
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
