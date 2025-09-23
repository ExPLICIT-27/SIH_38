import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/data/models/data_upload_model.dart';

class UploadCard extends StatelessWidget {
  final DataUploadModel upload;
  final VoidCallback onTap;

  const UploadCard({super.key, required this.upload, required this.onTap});

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
              AppColors.lightGray.withOpacity(0.3),
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
                    _buildFileTypeIcon(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            upload.fileName,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatFileSize(upload.size),
                            style: TextStyle(fontSize: 14, color: AppColors.charcoal.withOpacity(0.7)),
                          ),
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
                    _buildInfoItem(
                      Icons.calendar_today,
                      _formatDate(upload.capturedAt ?? upload.createdAt),
                      upload.capturedAt != null ? 'Captured' : 'Uploaded',
                    ),
                    if (upload.cid != null) _buildInfoItem(Icons.link, _formatCid(upload.cid!), 'CID'),
                    _buildInfoItem(Icons.fingerprint, _formatHash(upload.sha256), 'SHA-256'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileTypeIcon() {
    IconData iconData;
    List<Color> gradientColors;

    final extension = upload.fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'zip':
      case 'gz':
        iconData = Icons.folder_zip;
        gradientColors = AppColors.coastalGradient;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
        iconData = Icons.image;
        gradientColors = [AppColors.seagrassGreen, AppColors.kelp];
        break;
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        gradientColors = [AppColors.coralPink, AppColors.warning];
        break;
      default:
        iconData = Icons.insert_drive_file;
        gradientColors = [AppColors.deepOceanBlue, AppColors.abyssalBlue];
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

    switch (upload.status) {
      case UploadStatus.pinned:
        backgroundColor = AppColors.sequestrationGreen;
        textColor = AppColors.pearlWhite;
        label = 'Pinned';
        icon = Icons.push_pin;
        break;
      case UploadStatus.pending:
        backgroundColor = AppColors.monitoringPurple;
        textColor = AppColors.pearlWhite;
        label = 'Processing';
        icon = Icons.hourglass_empty;
        break;
      case UploadStatus.failed:
        backgroundColor = AppColors.coralPink;
        textColor = AppColors.pearlWhite;
        label = 'Failed';
        icon = Icons.error;
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

  String _formatCid(String cid) {
    if (cid.length <= 10) return cid;
    return '${cid.substring(0, 5)}...';
  }

  String _formatHash(String hash) {
    if (hash.length <= 10) return hash;
    return '${hash.substring(0, 5)}...';
  }
}
