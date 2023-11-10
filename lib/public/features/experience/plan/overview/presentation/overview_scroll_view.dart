import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/main_swipe_navigation.dart';
import 'package:read_with_meaning/public/constants/app_sizes.dart';
import 'package:read_with_meaning/public/constants/image_strings.dart';
import 'package:read_with_meaning/public/routing/routes.dart';

class OverviewScrollView extends ConsumerStatefulWidget
    implements ScrollableWidget {
  const OverviewScrollView({super.key, this.scrollController});
  final ScrollController? scrollController;
  @override
  Widget rebuildWithScrollController(ScrollController controller) {
    return OverviewScrollView(scrollController: controller);
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OverviewScrollViewState();
}

class _OverviewScrollViewState extends ConsumerState<OverviewScrollView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: widget.scrollController,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  bigMenuBackgroundImage), // Replace 'assets/images/your_image.jpg' with actual path of your image.
              fit: BoxFit.cover,
              alignment: Alignment
                  .center, // It will place the image at the center of the container.
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 8,
                    bottom: MediaQuery.of(context).size.height / 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Consumer(builder: (context, ref, _) {
                    //bool hasInfo = ref.watch(infoProvider);
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () =>
                                    context.pushNamed(AppRoute.sources.name),
                              )
                              /* InfoCard(
                                title: "From Where?".hardcoded,
                                onTap: () =>
                                    context.pushNamed(AppRoute.sources.name),
                                icon: Icons.cloud_queue_outlined), */
                              ),
                          gapH12,
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () =>
                                    context.pushNamed(AppRoute.lakes.name),
                              )
                              /* InfoCard(
                                title: "What?".hardcoded,
                                onTap: () =>
                                    context.pushNamed(AppRoute.all.name),
                                icon: Icons.waves_sharp),*/
                              ),
                          gapH12,
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () =>
                                    context.pushNamed(AppRoute.spile.name),
                              )
                              /* InfoCard(
                                title: "When?".hardcoded,
                                text: "".hardcoded,
                                onTap: () =>
                                    context.pushNamed(AppRoute.spile.name),
                                icon: Icons.filter_alt_outlined),*/
                              ),
                          gapH12,
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () =>
                                    context.pushNamed(AppRoute.stream.name),
                              )
                              /* InfoCard(
                                title: "Today".hardcoded,
                                text:
                                    "Your final list of what you could be doing today."
                                        .hardcoded,
                                onTap: () {
                                  Logger().d("Today");
                                  context.pushNamed(AppRoute.stream.name);
                                },
                                icon: Icons.add_road),*/
                              ),
                          gapH12,
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () =>
                                    context.pushNamed(AppRoute.now.name),
                              )
                              /* InfoCard(
                                title: "When?".hardcoded,
                                text: "".hardcoded,
                                onTap: () =>
                                    context.pushNamed(AppRoute.spile.name),
                                icon: Icons.filter_alt_outlined),*/
                              ),
                          /* gapH12, // TODO archive
                            Text("Archive".hardcoded,
                        style: Theme.of(context).textTheme.headlineMedium), */
                        ]);
                  }),
                ),
              ),
              //const NowAsDraggableSheet(),
            ],
          ),
        ));
  }
}
