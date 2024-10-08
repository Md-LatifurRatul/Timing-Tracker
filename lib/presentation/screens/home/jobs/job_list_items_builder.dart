import 'package:flutter/material.dart';
import 'package:time_tracker_app/presentation/widgets/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class JobListItemsBuilder<T> extends StatelessWidget {
  const JobListItemsBuilder({
    super.key,
    required this.snapshot,
    required this.itemBuilder,
  });

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final items = snapshot.data!;
      print("Items in snapshot: $items"); // Debugging print
      if (items.isNotEmpty) {
        return _buildListItems(items);
      } else {
        return const EmptyContent();
      }
    } else if (snapshot.hasError) {
      print("Error in snapshot: ${snapshot.error}"); // Debugging print
      return const EmptyContent(
        title: "Something went wrong",
        message: "Can't load items right now",
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildListItems(List<T> items) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        height: 0.5,
      ),
      itemCount: items.length + 2,
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
