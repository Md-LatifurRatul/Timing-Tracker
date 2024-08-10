import 'package:time_tracker_app/data/models/job.dart';
import 'package:time_tracker_app/data/services/firestore_service.dart';
import 'package:time_tracker_app/presentation/utility/api_path.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
  Future<void> deleteJob(Job job);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});

  final String uid;

  final FirestoreService _firestoreService = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async => await _firestoreService.setData(
      path: ApiPath.databasePath(uid, job.id), data: job.toMap());

  @override
  Future<void> deleteJob(Job job) async => await _firestoreService.deleteData(
      path: ApiPath.databasePath(uid, job.id));

  @override
  Stream<List<Job>> jobsStream() => _firestoreService.collectionStream(
      path: ApiPath.jobs(uid),
      builder: (data, documentId) => Job.fromMap(data, documentId));
}
