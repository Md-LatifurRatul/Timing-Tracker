import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/data/services/database.dart';
import 'package:time_tracker_app/presentation/screens/home/entry/entries_bloc.dart';
import 'package:time_tracker_app/presentation/screens/home/entry/entries_list_tile.dart';
import 'package:time_tracker_app/presentation/screens/home/jobs/job_list_items_builder.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({super.key});

  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Provider<EntriesBloc>(
      create: (_) => EntriesBloc(database: database),
      child: const EntriesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
        elevation: 2.0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(context, listen: false);
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error in snapshot: ${snapshot.error}"); // Debugging print
        }
        return JobListItemsBuilder<EntriesListTileModel>(
          snapshot: snapshot,
          itemBuilder: (context, model) => EntriesListTile(model: model),
        );
      },
    );
  }
}
