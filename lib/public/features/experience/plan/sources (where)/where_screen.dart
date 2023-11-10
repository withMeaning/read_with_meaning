import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:read_with_meaning/public/common_widgets/full_screen.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/main_swipe_navigation.dart';
import 'package:read_with_meaning/public/common_widgets/responsive/responsive_center.dart';
import 'package:read_with_meaning/public/constants/app_sizes.dart';
import 'package:read_with_meaning/public/constants/icomoon_icons.dart';
import 'package:read_with_meaning/public/features/experience/plan/sources%20(where)/integrations/presentation/add_source.dart';
import 'package:read_with_meaning/public/routing/navigation.dart';

import 'package:read_with_meaning/public/routing/routes.dart';

class WhereScreen extends StatelessWidget {
  const WhereScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ResponsiveCenter(child: Consumer(
      builder: (context, ref, child) {
        return MainSwipeNavigation(
            centerMenuItem: MenuItem(
              label: NavOptions.overview.label,
              icon: Icomoon.menu,
              callback: () {
                context.pushNamed(AppRoute.overview.name);
              },
            ),
            leftMenuItem: MenuItem(
              label: NavOptions.add.label,
              icon: Icomoon.addText,
              callback: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return const SingleChildScrollView(
                        child: AddSourceForm(),
                      );
                    });
              },
            ),
            rightMenuItem: MenuItem(
              label: NavOptions.command.label,
              icon: Icomoon.magicSearch,
              callback: () {
                context.pushNamed(AppRoute.search.name);
              },
            ),
            child: const WhereOverview());
      },
    )));
  }
}

class WhereOverview extends ConsumerStatefulWidget implements ScrollableWidget {
  const WhereOverview({super.key, this.scrollController});
  final ScrollController? scrollController;
  @override
  Widget rebuildWithScrollController(ScrollController controller) {
    return WhereOverview(scrollController: controller);
  }

  @override
  ConsumerState<WhereOverview> createState() => _WhereOverviewState();
}

// TODO this should propbably not hold the repository?
class _WhereOverviewState extends ConsumerState<WhereOverview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final readRepository = ref.watch(readsListRepositoryStreamProvider);

/*     final readRepository = ref.watch(dbStreamProvider).map(
        data: (value) => {value.value.map((e) => Read.fromReadEntry(e))},
        error: (asyncError) => placeholderRead,
        loading: (asyncLoading) => placeholderRead); */
    return FullScreenNoAppBar(
      child: Center(
        child: ListView(
            shrinkWrap: true,
            controller: widget.scrollController,
            children: [
              Text(
                "Friends",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              gapH12,
              Text(
                "Communities",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              gapH12,
              Text(
                "Integrations",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ]),
      ),
    );
    /* gapH20,
          Text(
            "The Cloud",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Text(
            "From Where?",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          gapH20,
          Container(
            color: Colors.grey,
            height: 200,
          ),
          gapH20,
          const Text("Where does"),
          gapH64, */
  }
}
