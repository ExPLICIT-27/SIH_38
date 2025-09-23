import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/data/models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildProjectTypeIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(project.type, style: TextStyle(fontSize: 14, color: AppColors.charcoal.withOpacity(0.7))),
                      ],
                    ),
                  ),
                  _buildStatusChip(),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(Icons.area_chart, '${project.areaHa.toStringAsFixed(1)} ha', 'Area'),
                  _buildInfoItem(Icons.calendar_today, _formatDate(project.createdAt), 'Created'),
                  _buildInfoItem(Icons.update, _formatDate(project.updatedAt), 'Updated'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectTypeIcon() {
    IconData iconData;
    Color iconColor;

    switch (project.type.toLowerCase()) {
      case 'mangrove':
        iconData = Icons.park;
        iconColor = AppColors.mangroveDark;
        break;
      case 'seagrass':
        iconData = Icons.waves;
        iconColor = AppColors.coastalTeal;
        break;
      case 'saltmarsh':
        iconData = Icons.landscape;
        iconColor = AppColors.seagrassGreen;
        break;
      default:
        iconData = Icons.forest;
        iconColor = AppColors.deepOceanBlue;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (project.status) {
      case ProjectStatus.approved:
        backgroundColor = AppColors.seagrassGreen.withOpacity(0.1);
        textColor = AppColors.seagrassGreen;
        label = 'Approved';
        break;
      case ProjectStatus.draft:
        backgroundColor = AppColors.charcoal.withOpacity(0.1);
        textColor = AppColors.charcoal;
        label = 'Draft';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(16)),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.coastalTeal),
            const SizedBox(width: 4),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.charcoal.withOpacity(0.7))),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}
