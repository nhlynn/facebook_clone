import '../providers/controller_provider.dart';
import '../utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/app_colors.dart';
import '../widgets/round_icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(controllerProvider);

    _tabController.index = currentIndex;
    return DefaultTabController(
      length: 5,
      initialIndex: currentIndex,
      child: Scaffold(
        backgroundColor: AppColors.greyColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          title: _buildTitle(),
          actions: [_buildSearchWidget(), _buildMessengerWidget()],
          bottom: TabBar(
            tabs: Constants.getHomeScreenTabs(_tabController.index),
            controller: _tabController,
            onTap: (index) {
              ref.read(controllerProvider.notifier).state =
                  _tabController.index;
              setState(() {});
            },
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: Constants.screens,
        ),
      ),
    );
  }

  Widget _buildTitle() => const Text(
        'Facebook',
        style: TextStyle(
          color: AppColors.blueColor,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _buildSearchWidget() => const RoundIconButtonWidget(
        icon: FontAwesomeIcons.magnifyingGlass,
      );

  Widget _buildMessengerWidget() => const RoundIconButtonWidget(
        icon: FontAwesomeIcons.facebookMessenger,
      );
}
