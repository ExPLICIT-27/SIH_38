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
      elevation: 4,
      shadowColor: AppColors.deepOceanBlue.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.pearlWhite,
              AppColors.seaFoam.withOpacity(0.3),
            ],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                          Text(project.type,
                              style: TextStyle(fontSize: 14, color: AppColors.charcoal.withOpacity(0.7))),
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
      ),
    );
  }

  Widget _buildProjectTypeIcon() {
    IconData iconData;
    List<Color> gradientColors;

    switch (project.type.toLowerCase()) {
      case 'mangrove':
        iconData = Icons.park;
        gradientColors = [AppColors.mangroveDark, AppColors.kelp];
        break;
      case 'seagrass':
        iconData = Icons.waves;
        gradientColors = AppColors.coastalGradient;
        break;
      case 'saltmarsh':
        iconData = Icons.landscape;
        gradientColors = [AppColors.seagrassGreen, AppColors.algaeGreen];
        break;
      default:
        iconData = Icons.eco;
        gradientColors = AppColors.vegetationGradient.take(2).toList();
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(iconData, color: AppColors.pearlWhite, size: 28),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String label;
    IconData icon;

    switch (project.status) {
      case ProjectStatus.approved:
        backgroundColor = AppColors.sequestrationGreen;
        textColor = AppColors.pearlWhite;
        label = 'Approved';
        icon = Icons.check_circle;
        break;
      case ProjectStatus.draft:
        backgroundColor = AppColors.slateGray;
        textColor = AppColors.pearlWhite;
        label = 'Draft';
        icon = Icons.edit;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
