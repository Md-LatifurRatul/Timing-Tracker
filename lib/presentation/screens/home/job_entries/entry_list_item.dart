import 'package:flutter/material.dart';
import 'package:time_tracker_app/data/models/entry.dart';
import 'package:time_tracker_app/data/models/job.dart';
import 'package:time_tracker_app/presentation/utility/format.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem(
      {super.key, required this.entry, required this.job, required this.onTap});

  final Entry entry;
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: _buildContents(context),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final dayOfWeek = Format.dayOfWeek(entry.start);
    final startDate = Format.date(entry.start);
    final startTime = TimeOfDay.fromDateTime(entry.start).format(context);
    final endTime = TimeOfDay.fromDateTime(entry.end).format(context);
    final durationFormatted = Format.hours(entry.durationInHours);

    final pay = job.ratePerHour * entry.durationInHours;
    final payFormatted = Format.currency(pay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              dayOfWeek,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              startDate,
              style: const TextStyle(fontSize: 18),
            ),
            if (job.ratePerHour > 0.0) ...[
              Expanded(child: Container()),
              Text(
                payFormatted,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ],
        ),
        Row(
          children: [
            Text(
              '$startTime - $endTime',
              style: const TextStyle(fontSize: 16),
            ),
            Expanded(child: Container()),
            Text(
              durationFormatted,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        if (entry.comment.isNotEmpty)
          Text(
            entry.comment,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
      ],
    );
  }
}
