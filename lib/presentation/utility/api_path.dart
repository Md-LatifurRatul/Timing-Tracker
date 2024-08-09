class ApiPath {
  static String databasePath(String uid, String jobId) =>
      'users/$uid/jobs/$jobId';
  static String jobs(String uid) => 'users/$uid/jobs';
}
