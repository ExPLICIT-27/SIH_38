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
    );
  }

  Widget _buildFileTypeIcon() {
    IconData iconData;
    Color iconColor;

    final extension = upload.fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'zip':
      case 'gz':
        iconData = Icons.folder_zip;
        iconColor = AppColors.coastalTeal;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
        iconData = Icons.image;
        iconColor = AppColors.seagrassGreen;
        break;
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = AppColors.coralAccent;
        break;
      default:
        iconData = Icons.insert_drive_file;
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

    switch (upload.status) {
      case UploadStatus.pinned:
        backgroundColor = AppColors.seagrassGreen.withOpacity(0.1);
        textColor = AppColors.seagrassGreen;
        label = 'Pinned';
        break;
      case UploadStatus.pending:
        backgroundColor = AppColors.coastalTeal.withOpacity(0.1);
        textColor = AppColors.coastalTeal;
        label = 'Pending';
        break;
      case UploadStatus.failed:
        backgroundColor = AppColors.coralAccent.withOpacity(0.1);
        textColor = AppColors.coralAccent;
        label = 'Failed';
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
