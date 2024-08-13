import 'package:time_tracker_app/data/models/entry.dart';
import 'package:time_tracker_app/data/models/job.dart';
import 'package:time_tracker_app/data/services/firestore_service.dart';
import 'package:time_tracker_app/presentation/utility/api_path.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
  Future<void> deleteJob(Job job);
  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job? job});
  Stream<Job> jobStream({required String jobId});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});

  final String uid;

  final FirestoreService _firestoreService = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async => await _firestoreService.setData(
      path: ApiPath.job(uid, job.id), data: job.toMap());

  @override
  Future<void> deleteJob(Job job) async {
    final allEntries = await entriesStream(job: job).first;

    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }

    await _firestoreService.deleteData(path: ApiPath.job(uid, job.id));
  }

  @override
  Stream<Job> jobStream({required String jobId}) =>
      _firestoreService.documentStream(
          path: ApiPath.job(uid, jobId),
          builder: (data, documentId) => Job.fromMap(data, documentId));

  @override
  Stream<List<Job>> jobsStream() => _firestoreService.collectionStream(
      path: ApiPath.jobs(uid),
      builder: (data, documentId) => Job.fromMap(data, documentId));

  @override
  Future<void> setEntry(Entry entry) async => await _firestoreService.setData(
      path: ApiPath.entry(uid, entry.id), data: entry.toMap());

  @override
  Future<void> deleteEntry(Entry entry) async =>
      await _firestoreService.deleteData(path: ApiPath.entry(uid, entry.id));

  @override
  Stream<List<Entry>> entriesStream({Job? job}) =>
      _firestoreService.collectionStream<Entry>(
        path: ApiPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
