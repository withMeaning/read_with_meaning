/* import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:read_with_meaning/public/common_widgets/full_screen.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/swipeable_icon.dart';
import 'package:read_with_meaning/public/common_widgets/no_scroll.dart';
import 'package:read_with_meaning/public/constants/image_strings.dart';
import 'package:read_with_meaning/public/features/experience/single/view/application/go_back_and_forth.dart';
import 'package:read_with_meaning/public/features/experience/single/view/presentation/action_box.dart';
import 'package:read_with_meaning/public/features/experience/single/view/presentation/main_text.dart';
import 'package:read_with_meaning/public/features/experience/single/view/presentation/title.dart';
import 'package:read_with_meaning/public/routing/routes.dart';

class SingleExperienceScreen extends StatefulWidget {
  const SingleExperienceScreen({super.key, required this.id});
  final String id;

  @override
  State<SingleExperienceScreen> createState() => _SingleExperienceScreenState();
}

class _SingleExperienceScreenState extends State<SingleExperienceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey _key = GlobalKey();
  final ScrollController _mainTextScrollController = ScrollController();

  double topPosition = 0;
  double leftPosition = 0;
  bool isNewPan = true;
  int isGoingToBeVertical = 0;
  int isGoingToBeHoritontal = 0;
  bool isVertical = false;
  bool isHorizontal = false;
  double panY = 0;
  double panX = 0;
  double menuXposition =
      0; // determines which of the 3 menu icons is selected, 0 if left, 1 if center, 2 if right, double if in transition
  final _image = const AssetImage(colorfulBackgroundImage);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // ? I don't know what this is here
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await precacheImage(_image, context);
    });
  }

  _reset() {
    setState(() {
      //topPosition = 0;
      //mainTextScrollable = false;
      isNewPan = true;
      isGoingToBeVertical = 0;
      isGoingToBeHoritontal = 0;
      panX = 0;
      panY = 0;
      menuXposition = 1;
    });
  }

  _resetPosition() {
    setState(() {
      topPosition = 0;
      leftPosition = 0;
      isVertical = false;
      isHorizontal = false;
    });
  }

  _onPanUpdate(DragUpdateDetails details) {
    //Logger().i("Pan Update: ${details.delta}");
    // this determines the direction of the pan
    final screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      panY += details.delta.dy;
      panX += details.delta.dx;
    });

    if (isNewPan) {
      setState(() {
        if ((details.localPosition.dx / screenWidth).clamp(0, 1) < (1 / 3)) {
          menuXposition = 0;
        } else if ((details.localPosition.dx / screenWidth).clamp(0, 1) >
                (1 / 3) &&
            (details.localPosition.dx / screenWidth).clamp(0, 1) < (2 / 3)) {
          menuXposition = 1;
        } else if ((details.localPosition.dx / screenWidth).clamp(0, 1) >
            (2 / 3)) {
          menuXposition = 2;
        } else {
          menuXposition = 1;
        }
      });

      isGoingToBeVertical += details.delta.dy.toInt();
      isGoingToBeHoritontal += details.delta.dx.toInt();

      if (isGoingToBeVertical.abs() > 10) {
        setState(() {
          isVertical = true;
          isHorizontal = false;
          isNewPan = false;
        });
      } else if (isGoingToBeHoritontal.abs() > 10) {
        setState(() {
          isVertical = false;
          isHorizontal = true;
          isNewPan = false;
        });
      }
    } else {
      setState(() {
        menuXposition =
            (details.localPosition.dx / screenWidth).clamp(0, 1) * 2;
      });
    }
    if (isVertical && panY > 0) {
      setState(() {
        topPosition += details.delta.dy;
      });
    }
    if (isHorizontal) {
      setState(() {
        topPosition = 0;
        leftPosition += details.delta.dx;
      });
    }
  }

  _onPanEnd(ref) {
    Logger().i("Pan End");
    if (isVertical) {
      if (menuXposition < 0.5 && panY > 150) {
        // refresh
        Logger().i("Refresh");
      } else if (menuXposition > 0.5 && menuXposition < 1.5 && panY > 150) {
        // today
        context.pushNamed(AppRoute.stream.name);
      } else if (menuXposition > 1.5 && panY > 150) {
        // search
        Logger().i("Search");
        context.pushNamed(AppRoute.search.name);
      } else {
        // do nothing
        Logger().i("Do Nothing");
      }
      if (panY > 0) {
        _resetPosition();
      }
    }
    if (isHorizontal) {
      // TODO this should a visual animation during the
      // goNext and goPrevious functions
      Logger().i("Horizontal, $panX, $leftPosition");
      if (leftPosition > 100) {
        goNext(context, ref, widget.id);
      }
      if (leftPosition < -100) {
        goNext(context, ref, widget.id);
      }
      _resetPosition();
    }
    _reset();
  }

  // ! TODO Refactor into seperate Top and Side Navigation widgets
  // TODO Solve swiping control issues
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FullScreenNoAppBar(
              child: isVertical
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 6,
                      child: Transform.translate(
                        offset: Offset(
                            0,
                            panY.clamp(
                                    0, MediaQuery.of(context).size.height / 6) -
                                100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SwipeableIcon(
                              isSelected: menuXposition < 0.5 && panY > 150,
                              opacity: menuXposition < 0.5
                                  ? (1.2 - menuXposition.clamp(0.2, 0.5))
                                      .clamp(0.7, 1)
                                  : 0.2,
                              labelText: "Refresh",
                              icon: Icons.refresh,
                            ),
                            SwipeableIcon(
                              isSelected: menuXposition > 0.5 &&
                                  menuXposition < 1.5 &&
                                  panY > 150,
                              opacity:
                                  menuXposition > 0.5 && menuXposition < 1.5
                                      ? (1.2 - (menuXposition - 1).abs())
                                          .clamp(0.7, 1)
                                      : 0.2,
                              labelText: "Today",
                              icon: Icons.density_small_outlined,
                            ),
                            SwipeableIcon(
                              isSelected: menuXposition > 1.5 && panY > 150,
                              opacity: menuXposition > 1.5
                                  ? (1.2 - (menuXposition - 2).abs())
                                      .clamp(0.7, 1)
                                  : 0.2,
                              labelText: "Search",
                              icon: Icons.search,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Image(fit: BoxFit.cover, image: _image),
            ),
            Consumer(builder: (context, ref, child) {
              return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  // Implementing the GestureDetector to detect the user drag
                  key: _key,
                  onPanUpdate: (details) {
                    _onPanUpdate(details);
                  },
                  onPanEnd: (_) {
                    _onPanEnd(ref);
                  },
                  child: Transform.translate(
                      offset: Offset(
                          leftPosition,
                          topPosition.clamp(-MediaQuery.of(context).size.height,
                              MediaQuery.of(context).size.height / 6)),
                      child: Stack(
                        children: [
                          FullScreenNoAppBar(
                              child: Container(
                            color: Theme.of(context).colorScheme.background,
                            child: Stack(
                              children: [
                                Flex(direction: Axis.vertical, children: [
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
                                          ))),
                                ]),
                              ],
                            ),
                          )),
                          DraggableScrollableSheet(
                              initialChildSize: 1 / 6,
                              minChildSize: 1 / 6,
                              maxChildSize: 1,
                              builder:
                                  (BuildContext context, myscrollController) {
                                return Container(
                                  child: NoScrollBar(
                                      child: SingleChildScrollView(
                                          controller: myscrollController,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  6,
                                              bottom: 24,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(
                                                                20))),
                                            child: Column(
                                              children: [
                                                MainText(id: widget.id)
                                              ],
                                            ),
                                          ))),
                                );
                              }),
                        ],
                      )));
            })
          ],
        ),
      ),
    );
  }
}
                    

/*         child: ResponsiveCenter(
            child: NoScroll(
                child:
                    Padding(padding: padding32, child: SingleStream(id: id))),
          ), */
 */