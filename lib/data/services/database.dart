import 'package:time_tracker_app/data/models/job.dart';
import 'package:time_tracker_app/data/services/firestore_service.dart';
import 'package:time_tracker_app/presentation/utility/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});

  final String uid;

  final FirestoreService _firestoreService = FirestoreService.instance;

  @override
  Future<void> createJob(Job job) async => await _firestoreService.setData(
      path: ApiPath.databasePath(uid, 'job_abc'), data: job.toMap());

  @override
  Stream<List<Job>> jobsStream() => _firestoreService.collectionStream(
      path: ApiPath.jobs(uid), builder: (data) => Job.fromMap(data));
}
