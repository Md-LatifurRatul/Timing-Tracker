class Entry {
  Entry({
    required this.id,
    required this.jobId,
    required this.start,
    required this.end,
    required this.comment,
  });

  String id;
  String jobId;
  DateTime start;
  DateTime end;
  String comment;

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;

  factory Entry.fromMap(Map<dynamic, dynamic> value, String id) {
    print('Raw data: $value'); // Log the raw data

    try {
      final int? startMilliseconds = value['start'] as int?;
      final int? endMilliseconds = value['end'] as int?;
      final String? jobId = value['jobId'] as String?;
      final String? comment = value['comment'] as String?;

      if (startMilliseconds == null || endMilliseconds == null) {
        throw Exception(
            "Missing or null 'start' or 'end' field in document ID: $id");
      }

      return Entry(
        id: id,
        jobId: jobId ?? '',
        start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
        end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
        comment: comment ?? '',
      );
    } catch (e) {
      print('Error creating Entry from map: $e');
      throw Exception("Failed to parse Entry from map");
    }
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobId': jobId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }
}
