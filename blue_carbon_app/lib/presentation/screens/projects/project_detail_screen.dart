import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/data/models/project_model.dart';
import 'package:blue_carbon_app/presentation/screens/uploads/create_upload_screen.dart';
import 'package:blue_carbon_app/presentation/widgets/common/custom_button.dart';

class ProjectDetailScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Overview', 'Uploads', 'Verifications', 'Credits'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.project.name), backgroundColor: AppColors.deepOceanBlue),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(child: _buildSelectedTabContent()),
        ],
      ),
      floatingActionButton: _selectedTabIndex == 1
          ? FloatingActionButton(
              backgroundColor: AppColors.coastalTeal,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateUploadScreen(projectId: widget.project.id)),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final isSelected = _selectedTabIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 24),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: isSelected ? AppColors.coastalTeal : Colors.transparent, width: 2),
                ),
              ),
              child: Text(
                _tabs[index],
                style: TextStyle(
                  color: isSelected ? AppColors.coastalTeal : AppColors.charcoal.withOpacity(0.7),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildUploadsTab();
      case 2:
        return _buildVerificationsTab();
      case 3:
        return _buildCreditsTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Project Details'),
          _buildInfoCard(),
          const SizedBox(height: 24),
          _buildSectionTitle('Location'),
          _buildMapPlaceholder(),
          const SizedBox(height: 24),
          _buildSectionTitle('Status'),
          _buildStatusTimeline(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Project Type', widget.project.type),
            const Divider(),
            _buildInfoRow('Area', '${widget.project.areaHa.toStringAsFixed(1)} hectares'),
            const Divider(),
            _buildInfoRow('Created', DateFormat('dd MMM yyyy').format(widget.project.createdAt)),
            const Divider(),
            _buildInfoRow('Status', widget.project.status == ProjectStatus.approved ? 'Approved' : 'Draft'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.charcoal.withOpacity(0.7))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.oceanFoam,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.deepOceanBlue.withOpacity(0.2)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 48, color: AppColors.deepOceanBlue.withOpacity(0.5)),
            const SizedBox(height: 8),
            Text('Map view', style: TextStyle(color: AppColors.charcoal.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTimeline() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTimelineItem('Created', DateFormat('dd MMM yyyy').format(widget.project.createdAt), true, true),
            _buildTimelineItem(
              'Submitted for Approval',
              DateFormat('dd MMM yyyy').format(widget.project.updatedAt),
              true,
              widget.project.status == ProjectStatus.approved,
            ),
            _buildTimelineItem(
              'Approved',
              widget.project.status == ProjectStatus.approved
                  ? DateFormat('dd MMM yyyy').format(widget.project.updatedAt)
                  : 'Pending',
              widget.project.status == ProjectStatus.approved,
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, bool isCompleted, bool showLine) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.seagrassGreen : AppColors.charcoal.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: isCompleted ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
            ),
            if (showLine)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? AppColors.seagrassGreen : AppColors.charcoal.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: AppColors.charcoal.withOpacity(0.7), fontSize: 14)),
              SizedBox(height: showLine ? 24 : 0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadsTab() {
    // Placeholder for uploads tab
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload, size: 64, color: AppColors.deepOceanBlue.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('No uploads yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Upload field data to get started', style: TextStyle(color: AppColors.charcoal.withOpacity(0.7))),
          const SizedBox(height: 24),
          CustomButton(
            label: 'Upload Data',
            icon: Icons.add,
            width: 200,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateUploadScreen(projectId: widget.project.id)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationsTab() {
    // Placeholder for verifications tab
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified, size: 64, color: AppColors.deepOceanBlue.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('No verifications yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Upload data for verification', style: TextStyle(color: AppColors.charcoal.withOpacity(0.7))),
        ],
      ),
    );
  }

  Widget _buildCreditsTab() {
    // Placeholder for credits tab
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet, size: 64, color: AppColors.deepOceanBlue.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('No carbon credits yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Complete verification to mint credits', style: TextStyle(color: AppColors.charcoal.withOpacity(0.7))),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.deepOceanBlue),
      ),
    );
  }
}
