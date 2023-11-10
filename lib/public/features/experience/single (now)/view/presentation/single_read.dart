import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/main_swipe_navigation.dart';
import 'package:read_with_meaning/public/constants/app_sizes.dart';
import 'package:read_with_meaning/public/constants/image_strings.dart';
import 'package:read_with_meaning/public/features/experience/single%20(now)/view/application/go_back_and_forth.dart';
import 'package:read_with_meaning/public/features/experience/single%20(now)/view/presentation/action_box.dart';
import 'package:read_with_meaning/public/features/experience/single%20(now)/view/presentation/main_text.dart';
import 'package:read_with_meaning/public/features/experience/single%20(now)/view/presentation/title.dart';

// TODO rename file name
class SingleReadView extends ConsumerStatefulWidget
    implements ScrollableWidget {
  const SingleReadView({super.key, this.scrollController, required this.id});
  final ScrollController? scrollController;
  final String id;
  @override
  Widget rebuildWithScrollController(ScrollController controller) {
    return SingleReadView(scrollController: controller, id: id);
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SingleReadViewState();
}

class _SingleReadViewState extends ConsumerState<SingleReadView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: widget.scrollController,
        physics: const NeverScrollableScrollPhysics(),
        child: Column(children: [
          Container(
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context)
                  .colorScheme
                  .surfaceVariant, //Theme.of(context).colorScheme.background,
              child: Stack(children: [
                Flex(
                  direction: Axis.vertical,
                  children: [
                    // * most important part of the screen
                    const ActionBox(), // not yet implemented
                    ExpandingTitle(id: widget.id),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          goNext(
                              context,
                              ref,
                              widget
                                  .id); // skip, aka. go next without sending resonance
                        },
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    )
                  ],
                ),
              ])),
          const Image(
            image: AssetImage(blackToBackgroundImage),
            fit: BoxFit.fill,
          ),
          MainText(id: widget.id),
          gapH48
        ]));
  }
}
