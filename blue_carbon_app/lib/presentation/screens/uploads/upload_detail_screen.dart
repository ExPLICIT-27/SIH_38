import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/data/models/data_upload_model.dart';
import 'package:blue_carbon_app/presentation/widgets/common/custom_button.dart';
import 'package:blue_carbon_app/data/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadDetailScreen extends StatelessWidget {
  final DataUploadModel upload;

  const UploadDetailScreen({super.key, required this.upload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Details'), backgroundColor: AppColors.deepOceanBlue),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFileInfoCard(context),
            const SizedBox(height: 12),
            if ((upload.publicUrl ?? '').isNotEmpty)
              CustomButton(
                label: 'Open File',
                icon: Icons.open_in_new,
                onPressed: () async {
                  final uri = Uri.parse(upload.publicUrl!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open file'), backgroundColor: Colors.red),
                    );
                  }
                },
              ),
            const SizedBox(height: 24),
            _buildSectionTitle('Upload Details'),
            _buildDetailsCard(context),
            const SizedBox(height: 24),
            if (upload.metadata != null) ...[
              _buildSectionTitle('Metadata'),
              _buildMetadataCard(context),
              const SizedBox(height: 24),
            ],
            _buildSectionTitle('Verification Status'),
            _buildVerificationCard(context),
            const SizedBox(height: 32),
            if (upload.status == UploadStatus.pinned)
              CustomButton(
                label: 'Request Verification',
                icon: Icons.verified,
                onPressed: () async {
                  try {
                    final api = ApiService();
                    await api.createVerification({'uploadId': upload.id});
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Verification request sent'), backgroundColor: Colors.green),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                    }
                  }
                },
              ),
          ],
        ),
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

  Widget _buildFileInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _getFileIconColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_getFileIcon(), color: _getFileIconColor(), size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(upload.fileName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    _formatFileSize(upload.size),
                    style: TextStyle(fontSize: 14, color: AppColors.charcoal.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusChip(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow(context, 'Upload Date', DateFormat('dd MMM yyyy, HH:mm').format(upload.createdAt)),
            const Divider(),
            if (upload.capturedAt != null) ...[
              _buildDetailRow(context, 'Captured Date', DateFormat('dd MMM yyyy, HH:mm').format(upload.capturedAt!)),
              const Divider(),
            ],
            _buildDetailRow(context, 'SHA-256 Hash', upload.sha256, isCopiable: true),
            if (upload.cid != null) ...[
              const Divider(),
              _buildDetailRow(context, 'IPFS CID', upload.cid!, isCopiable: true),
            ],
            if ((upload.publicUrl ?? '').isNotEmpty) ...[
              const Divider(),
              _buildDetailRow(context, 'Public URL', upload.publicUrl!, isCopiable: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...upload.metadata!.entries.map((entry) {
              return Column(
                children: [
                  _buildDetailRow(context, _formatMetadataKey(entry.key), entry.value.toString()),
                  if (entry != upload.metadata!.entries.last) const Divider(),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pending_actions, color: AppColors.coastalTeal),
                const SizedBox(width: 8),
                const Text('Pending Verification', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'This upload is waiting for verification by an authorized verifier.',
              style: TextStyle(color: AppColors.charcoal.withOpacity(0.7)),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.5,
              backgroundColor: AppColors.seaFoam,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.coastalTeal),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Uploaded', style: TextStyle(fontSize: 12, color: AppColors.charcoal.withOpacity(0.7))),
                Text('Verified', style: TextStyle(fontSize: 12, color: AppColors.charcoal.withOpacity(0.7))),
                Text('Anchored', style: TextStyle(fontSize: 12, color: AppColors.charcoal.withOpacity(0.7))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isCopiable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: AppColors.charcoal.withOpacity(0.7))),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              if (isCopiable)
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$label copied to clipboard'), duration: const Duration(seconds: 1)),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
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
        backgroundColor = AppColors.coralPink.withOpacity(0.1);
        textColor = AppColors.coralPink;
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

  IconData _getFileIcon() {
    final extension = upload.fileName.split('.').last.toLowerCase();

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

  Color _getFileIconColor() {
    final extension = upload.fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'zip':
      case 'gz':
        return AppColors.coastalTeal;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return AppColors.seagrassGreen;
      case 'pdf':
        return AppColors.coralPink;
      default:
        return AppColors.deepOceanBlue;
    }
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

  String _formatMetadataKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .replaceAllMapped(RegExp(r'_([a-z])'), (match) => ' ${match.group(1)?.toUpperCase()}')
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }
}
