import 'package:flutter/widgets.dart';
import 'package:time_tracker_app/presentation/screens/home/account/accoun_page.dart';
import 'package:time_tracker_app/presentation/screens/home/cupertino_home_scaffold.dart';
import 'package:time_tracker_app/presentation/screens/home/entry/entries_page.dart';
import 'package:time_tracker_app/presentation/screens/home/jobs_page_screen.dart';
import 'package:time_tracker_app/presentation/screens/home/tab_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };
  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => const JobsPageScreen(),
      TabItem.entries: (_) => EntriesPage.create(context),
      TabItem.account: (_) => const AccounPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onselectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
