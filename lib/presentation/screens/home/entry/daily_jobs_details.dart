import 'package:time_tracker_app/presentation/screens/home/entry/entry_job.dart';

class JobDetails {
  JobDetails({
    required this.name,
    required this.durationInHours,
    required this.pay,
  });
  final String name;
  double durationInHours;
  double pay;
}

class DailyJobsDetails {
  DailyJobsDetails({required this.date, required this.jobsDetails});
  final DateTime date;
  final List<JobDetails> jobsDetails;

  double get pay => jobsDetails
      .map((jobDuration) => jobDuration.pay)
      .reduce((value, element) => value + element);

  double get duration => jobsDetails
      .map((jobDuration) => jobDuration.durationInHours)
      .reduce((value, element) => value + element);

  static Map<DateTime, List<EntryJob>> _entriesByDate(List<EntryJob> entries) {
    Map<DateTime, List<EntryJob>> map = {};
    for (var entryJob in entries) {
      final entryDayStart = DateTime(entryJob.entry.start.year,
          entryJob.entry.start.month, entryJob.entry.start.day);
      if (map[entryDayStart] == null) {
        map[entryDayStart] = [entryJob];
      } else {
        map[entryDayStart]?.add(entryJob);
      }
    }
    return map;
  }

  static List<DailyJobsDetails> all(List<EntryJob> entries) {
    final byDate = _entriesByDate(entries);
    List<DailyJobsDetails> list = [];
    for (var date in byDate.keys) {
      final entriesByDate = byDate[date];
      final byJob = _jobsDetails(entriesByDate!);
      list.add(DailyJobsDetails(date: date, jobsDetails: byJob));
    }
    return list.toList();
  }

  static List<JobDetails> _jobsDetails(List<EntryJob> entries) {
    Map<String, JobDetails> jobDuration = {};
    for (var entryJob in entries) {
      final entry = entryJob.entry;
      final pay = entry.durationInHours * entryJob.job.ratePerHour;
      if (jobDuration[entry.jobId] == null) {
        jobDuration[entry.jobId] = JobDetails(
          name: entryJob.job.name,
          durationInHours: entry.durationInHours,
          pay: pay,
        );
      } else {
        jobDuration[entry.jobId]?.pay += pay;
        jobDuration[entry.jobId]?.durationInHours += entry.durationInHours;
      }
    }
    return jobDuration.values.toList();
  }
}
