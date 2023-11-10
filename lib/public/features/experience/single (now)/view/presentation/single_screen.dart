import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:read_with_meaning/public/common_widgets/errors/snack_bar.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/main_swipe_navigation.dart';
import 'package:read_with_meaning/public/common_widgets/responsive/responsive_center.dart';
import 'package:read_with_meaning/public/constants/image_strings.dart';
import 'package:read_with_meaning/public/features/experience/data/from_server.dart/add_item.dart';
import 'package:read_with_meaning/public/features/experience/single%20(now)/rating/rating_provider.dart';
import 'package:read_with_meaning/public/features/experience/single%20(now)/view/application/go_back_and_forth.dart';
import 'package:read_with_meaning/public/features/experience/single%20(now)/view/presentation/single_read.dart';
import 'package:read_with_meaning/public/routing/navigation.dart';
import 'package:read_with_meaning/public/routing/routes.dart';
import 'package:read_with_meaning/public/constants/icomoon_icons.dart';
import 'package:read_with_meaning/public/features/experience/add/presentation/add_exp.dart';

class SingleExperienceScreen extends StatefulWidget {
  const SingleExperienceScreen({super.key, required this.id});

  final String id;
  @override
  State<SingleExperienceScreen> createState() => _SingleExperienceScreenState();
}

class _SingleExperienceScreenState extends State<SingleExperienceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ResponsiveCenter(
      child: Consumer(
        builder: (context, ref, child) => MainSwipeNavigationAllDirections(
          centerMenuItem: MenuItem(
            label: NavOptions.stream.label,
            icon: Icomoon.when,
            callback: () {
              context.pushNamed(AppRoute.stream.name);
            },
          ),
          /* leftMenuItem: MenuItem(
            label: NavOptions.add.label,
            icon: Icons.add,
            callback: () {
              /* showModalBottomSheet(
                        context: context, 
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return const SingleChildScrollView(
                            child: AddSourceForm(),
                          );
                        }); */
            },
          ),
          rightMenuItem: MenuItem(
            label: NavOptions.command.label,
            icon: Icomoon.magic_search,
            callback: () {
              context.pushNamed(AppRoute.search.name);
            },
          ), */
          hasGradient: true,
          rightBackgroundImage: const AssetImage(goodRatingBackgroundImage),
          leftBackgroundImage: const AssetImage(badRatingBackgroundImage),
          leftCenterSwipeItem: MenuItem(
            label: "",
            icon: Icons.thumb_down_alt_outlined,
            callback: () {
              int rating = ref.watch(ratingProvider);
              Logger().i("Rating: $rating");
              snackBar(context, "Rated Experience with $rating");

              // call an animation here?

              goNext(context, ref, widget.id);
              //
              try {
                addResonance(widget.id, rating);
              } catch (e) {
                snackBar(context, e.toString());
              }
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
                      child: AddExpForm(),
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
          child: SingleReadView(id: widget.id),
        ),
      ),
    ));
  }
}
