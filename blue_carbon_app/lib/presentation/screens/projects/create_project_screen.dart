import 'package:flutter/material.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/presentation/widgets/common/custom_button.dart';
import 'package:blue_carbon_app/presentation/widgets/common/custom_text_field.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();
  String _selectedType = 'Mangrove';

  final List<String> _projectTypes = ['Mangrove', 'Seagrass', 'Saltmarsh'];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _createProject() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Replace with actual API call
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Project created successfully'), backgroundColor: Colors.green));

        Navigator.pop(context);
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Project name is required';
    }
    return null;
  }

  String? _validateArea(String? value) {
    if (value == null || value.isEmpty) {
      return 'Area is required';
    }
    final area = double.tryParse(value);
    if (area == null || area <= 0) {
      return 'Please enter a valid area';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Project'), backgroundColor: AppColors.deepOceanBlue),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Project Information'),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nameController,
                label: 'Project Name',
                hint: 'Enter project name',
                validator: _validateName,
              ),
              const SizedBox(height: 24),
              _buildProjectTypeDropdown(),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _areaController,
                label: 'Area (hectares)',
                hint: 'Enter area in hectares',
                keyboardType: TextInputType.number,
                validator: _validateArea,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Project Location'),
              const SizedBox(height: 16),
              _buildMapPlaceholder(),
              const SizedBox(height: 40),
              CustomButton(label: 'Create Project', isLoading: _isLoading, onPressed: _createProject),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.deepOceanBlue),
    );
  }

  Widget _buildProjectTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Type',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.charcoal),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.deepOceanBlue.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedType,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: AppColors.charcoal, fontSize: 16),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedType = newValue;
                  });
                }
              },
              items: _projectTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.seaFoam,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.deepOceanBlue.withOpacity(0.2)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location_alt, size: 48, color: AppColors.deepOceanBlue.withOpacity(0.5)),
            const SizedBox(height: 8),
            Text('Tap to select location', style: TextStyle(color: AppColors.charcoal.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }
}
