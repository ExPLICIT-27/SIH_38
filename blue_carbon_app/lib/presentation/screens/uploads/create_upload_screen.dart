import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/presentation/widgets/common/custom_button.dart';
import 'package:blue_carbon_app/presentation/widgets/common/custom_text_field.dart';
import 'package:blue_carbon_app/data/services/api_service.dart';
import 'package:blue_carbon_app/data/models/project_model.dart';

class CreateUploadScreen extends StatefulWidget {
  final String? projectId;

  const CreateUploadScreen({super.key, this.projectId});

  @override
  State<CreateUploadScreen> createState() => _CreateUploadScreenState();
}

class _CreateUploadScreenState extends State<CreateUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  File? _selectedFile;
  String? _selectedProjectId;
  bool _isLoading = false;
  bool _hasGpsData = true;

  List<ProjectModel> _projects = [];
  bool _loadingProjects = false;

  @override
  void initState() {
    super.initState();
    _selectedProjectId = widget.projectId;
    _loadProjects();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _loadingProjects = true;
    });
    try {
      final api = ApiService();
      final items = await api.getProjects();
      if (!mounted) return;
      setState(() {
        _projects = items;
        // Keep preselected projectId if provided and present; else default to first
        _selectedProjectId = _selectedProjectId ?? (_projects.isNotEmpty ? _projects.first.id : null);
        _loadingProjects = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingProjects = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.coralPink));
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip', 'jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = File(result.files.first.path!);
      });
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.camera);

    if (result != null) {
      setState(() {
        _selectedFile = File(result.path);
      });
    }
  }

  Future<void> _uploadData() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedFile == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a file to upload'), backgroundColor: Colors.red));
        return;
      }

      setState(() {
        _isLoading = true;
      });
      try {
        final api = ApiService();
        final metadata = <String, dynamic>{
          'projectId': _selectedProjectId,
          'notes': _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          'hasGps': _hasGpsData,
          if (!_hasGpsData) 'location': _locationController.text.trim(),
        }..removeWhere((key, value) => value == null || (value is String && value.isEmpty));

        await api.uploadFile(_selectedFile!, metadata);
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('File uploaded successfully'), backgroundColor: Colors.green));
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.coralPink));
      }
    }
  }

  String? _validateProject(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a project';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    if (!_hasGpsData && (value == null || value.isEmpty)) {
      return 'Location is required when GPS data is not available';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Data'), backgroundColor: AppColors.deepOceanBlue),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Select File'),
              const SizedBox(height: 16),
              _buildFileSelector(),
              const SizedBox(height: 24),
              _buildSectionTitle('Project Information'),
              const SizedBox(height: 16),
              _buildProjectDropdown(),
              const SizedBox(height: 24),
              _buildGpsSwitch(),
              const SizedBox(height: 16),
              if (!_hasGpsData)
                CustomTextField(
                  controller: _locationController,
                  label: 'Location',
                  hint: 'Enter location details',
                  validator: _validateLocation,
                ),
              if (!_hasGpsData) const SizedBox(height: 24),
              CustomTextField(
                controller: _notesController,
                label: 'Notes (Optional)',
                hint: 'Enter any additional notes',
                maxLines: 3,
              ),
              const SizedBox(height: 40),
              CustomButton(label: 'Upload Data', isLoading: _isLoading, onPressed: _uploadData),
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

  Widget _buildFileSelector() {
    return Column(
      children: [
        if (_selectedFile != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.deepOceanBlue.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(_getFileIcon(_selectedFile!.path), color: AppColors.coastalTeal, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getFileName(_selectedFile!.path),
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      FutureBuilder<int>(
                        future: _selectedFile!.length(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              _formatFileSize(snapshot.data!),
                              style: TextStyle(color: AppColors.charcoal.withOpacity(0.7), fontSize: 14),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedFile = null;
                    });
                  },
                  icon: Icon(Icons.close, color: AppColors.charcoal.withOpacity(0.7)),
                ),
              ],
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: 'Choose File',
                  icon: Icons.file_upload,
                  isOutlined: true,
                  onPressed: _pickFile,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  label: 'Take Photo',
                  icon: Icons.camera_alt,
                  isOutlined: true,
                  onPressed: _takePhoto,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildProjectDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project',
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
          child: _loadingProjects
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child:
                      Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                )
              : DropdownButtonFormField<String>(
                  value: _selectedProjectId,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  decoration: const InputDecoration(border: InputBorder.none),
                  style: TextStyle(color: AppColors.charcoal, fontSize: 16),
                  validator: _validateProject,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedProjectId = newValue;
                      });
                    }
                  },
                  items: _projects
                      .map<DropdownMenuItem<String>>((ProjectModel project) =>
                          DropdownMenuItem<String>(value: project.id, child: Text(project.name)))
                      .toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildGpsSwitch() {
    return Row(
      children: [
        Icon(Icons.location_on, color: AppColors.coastalTeal, size: 20),
        const SizedBox(width: 8),
        Text('Use GPS data from file', style: TextStyle(fontSize: 16, color: AppColors.charcoal)),
        const Spacer(),
        Switch(
          value: _hasGpsData,
          onChanged: (value) {
            setState(() {
              _hasGpsData = value;
            });
          },
          activeColor: AppColors.coastalTeal,
        ),
      ],
    );
  }

  IconData _getFileIcon(String path) {
    final extension = path.split('.').last.toLowerCase();

    switch (extension) {
      case 'zip':
      case 'gz':
        return Icons.folder_zip;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _getFileName(String path) {
    return path.split('/').last;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
