/// API constants for the Blue Carbon MRV app
class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  /// Base URL for the API
  // static const String baseUrl = 'http://localhost:3000/v1';
  static const String baseUrl = 'http://10.203.172.18:3000/v1'; // Mi 11X Pro

  /// Authentication endpoints
  static const String login = '/auth/login';
  static const String requestOtp = '/auth/request-otp';

  /// Organization endpoints
  static const String organizations = '/orgs';
  static const String organizationById = '/orgs/';

  /// Project endpoints
  static const String projects = '/projects';
  static const String projectById = '/projects/';
  static const String approveProject = '/approve';

  /// Upload endpoints
  static const String uploads = '/uploads';
  static const String uploadById = '/uploads/';

  /// Verification/Registry endpoints
  // Verifications are handled under registry in backend
  static const String registry = '/registry';
  static const String registryProjects = '/registry/projects/';
  static const String registryBatches = '/registry/batches/';

  /// WebSocket topics
  static const String wsUploadStatus = 'upload.status';
  static const String wsVerificationStatus = 'verification.status';
  static const String wsChainTx = 'chain.tx';
  static const String wsBatchMinted = 'batch.minted';
  static const String wsBatchRetired = 'batch.retired';
}
