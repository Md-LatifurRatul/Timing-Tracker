import 'package:flutter/material.dart';
import 'package:time_tracker_app/data/models/entry.dart';
import 'package:time_tracker_app/data/models/job.dart';
import 'package:time_tracker_app/presentation/screens/home/job_entries/entry_list_item.dart';

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem(
      {super.key,
      required this.entry,
      required this.job,
      required this.onDismissed,
      required this.onTap});

  final Entry entry;
  final Job job;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background: Container(
          color: Colors.red,
        ),
        key: key!,
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => onDismissed(),
        child: EntryListItem(entry: entry, job: job, onTap: onTap));
  }
}
