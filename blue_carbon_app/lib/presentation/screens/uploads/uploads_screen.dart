import 'package:flutter/material.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/data/models/data_upload_model.dart';
import 'package:blue_carbon_app/presentation/screens/uploads/create_upload_screen.dart';
import 'package:blue_carbon_app/presentation/screens/uploads/upload_detail_screen.dart';
import 'package:blue_carbon_app/presentation/widgets/upload/upload_card.dart';

class UploadsScreen extends StatefulWidget {
  const UploadsScreen({super.key});

  @override
  State<UploadsScreen> createState() => _UploadsScreenState();
}

class _UploadsScreenState extends State<UploadsScreen> {
  bool _isLoading = true;
  List<DataUploadModel> _uploads = [];
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadUploads();
  }

  Future<void> _loadUploads() async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _uploads = [
        DataUploadModel(
          id: '1',
          fileName: 'mangrove_survey_data.zip',
          storagePath: '/uploads/mangrove_survey_data.zip',
          sha256: 'a1b2c3d4e5f6...',
          size: 1024 * 1024 * 5, // 5MB
          capturedAt: DateTime.now().subtract(const Duration(days: 2)),
          metadata: {'projectId': '1', 'location': 'Sundarbans', 'deviceId': 'ABC123'},
          cid: 'Qm123456789...',
          status: UploadStatus.pinned,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        DataUploadModel(
          id: '2',
          fileName: 'seagrass_monitoring.zip',
          storagePath: '/uploads/seagrass_monitoring.zip',
          sha256: 'f6e5d4c3b2a1...',
          size: 1024 * 1024 * 3, // 3MB
          capturedAt: DateTime.now().subtract(const Duration(days: 5)),
          metadata: {'projectId': '2', 'location': 'Gulf of Mannar', 'deviceId': 'DEF456'},
          cid: 'Qm987654321...',
          status: UploadStatus.pinned,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        DataUploadModel(
          id: '3',
          fileName: 'saltmarsh_data.zip',
          storagePath: '/uploads/saltmarsh_data.zip',
          sha256: '1a2b3c4d5e6f...',
          size: 1024 * 1024 * 2, // 2MB
          capturedAt: DateTime.now().subtract(const Duration(hours: 5)),
          metadata: {'projectId': '3', 'location': 'Chilika Lake', 'deviceId': 'GHI789'},
          status: UploadStatus.pending,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
      ];
      _isLoading = false;
    });
  }

  List<DataUploadModel> get _filteredUploads {
    if (_selectedFilter == 'All') {
      return _uploads;
    } else if (_selectedFilter == 'Pending') {
      return _uploads.where((u) => u.status == UploadStatus.pending).toList();
    } else if (_selectedFilter == 'Pinned') {
      return _uploads.where((u) => u.status == UploadStatus.pinned).toList();
    } else if (_selectedFilter == 'Failed') {
      return _uploads.where((u) => u.status == UploadStatus.failed).toList();
    }
    return _uploads;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uploads'), backgroundColor: AppColors.deepOceanBlue),
      body: RefreshIndicator(
        onRefresh: _loadUploads,
        color: AppColors.coastalTeal,
        child: Column(
          children: [
            _buildFilterChips(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _filteredUploads.isEmpty
                  ? _buildEmptyState()
                  : _buildUploadsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.coastalTeal,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateUploadScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All'),
          const SizedBox(width: 8),
          _buildFilterChip('Pending'),
          const SizedBox(width: 8),
          _buildFilterChip('Pinned'),
          const SizedBox(width: 8),
          _buildFilterChip('Failed'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: isSelected ? AppColors.coastalTeal.withOpacity(0.1) : AppColors.sandyBeige,
      selectedColor: AppColors.coastalTeal.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.coastalTeal : AppColors.charcoal,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: AppColors.coastalTeal,
    );
  }

  Widget _buildLoadingState() {
    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.coastalTeal)));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload, size: 80, color: AppColors.deepOceanBlue.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'No uploads found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.charcoal),
          ),
          const SizedBox(height: 8),
          Text('Upload field data to get started', style: TextStyle(color: AppColors.charcoal.withOpacity(0.7))),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateUploadScreen()));
            },
            icon: const Icon(Icons.add),
            label: const Text('Upload Data'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.coastalTeal),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredUploads.length,
      itemBuilder: (context, index) {
        final upload = _filteredUploads[index];
        return UploadCard(
          upload: upload,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UploadDetailScreen(upload: upload)));
          },
        );
      },
    );
  }
}
