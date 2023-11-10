import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:read_with_meaning/public/common_widgets/full_screen.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/swipeable_icon.dart';
import 'package:read_with_meaning/public/constants/image_strings.dart';
import 'package:read_with_meaning/public/features/experience/single%20(now)/rating/rating_provider.dart';

class MenuItem {
  const MenuItem(
      {required this.icon, required this.label, required this.callback});

  final IconData icon;
  final String label;
  final Function callback;
}

// we first create an abstract class
// that takes a controller, so our child can be ListView, SingleChildScrollView, etc.

abstract class ScrollableWidget extends ConsumerStatefulWidget {
  const ScrollableWidget({super.key});
  Widget rebuildWithScrollController(ScrollController controller);
}

class MainSwipeNavigation extends StatefulWidget {
  const MainSwipeNavigation({
    super.key,
    required this.child,
    this.leftMenuItem,
    required this.centerMenuItem,
    this.rightMenuItem,
    this.gradientImage,
  });

  final Widget child;

  final MenuItem? leftMenuItem;
  final MenuItem centerMenuItem;
  final MenuItem? rightMenuItem;

  final AssetImage? gradientImage;

  @override
  State<MainSwipeNavigation> createState() => _MainSwipeNavigationState();
}

class _MainSwipeNavigationState extends State<MainSwipeNavigation> {
  ScrollController scrollController = ScrollController();
  double scrollVelocityY = 0.0;
  bool noScroller = true;
  double topPosition = 0;
  bool isNewPan = true;
  int isGoingToBeHoritontal = 0;
  double menuXposition =
      0; // determines which of the 3 menu icons is selected, 0 if left, 1 if center, 2 if right, double if in transition

  late Widget eitherChild;
  @override
  void initState() {
    super.initState();
    eitherChild = (widget.child is ScrollableWidget)
        ? (widget.child as ScrollableWidget)
            .rebuildWithScrollController(scrollController)
        : widget.child;
    noScroller = widget.child is ScrollableWidget ? false : true;
    Logger().i("No Scroller: $noScroller");
  }

  reset() {
    setState(() {
      //topPosition = 0;
      //mainTextScrollable = false;
      isNewPan = true;
      isGoingToBeHoritontal = 0;
      menuXposition = 1;
      topPosition = 0;
    });
  }

  onPanStart(DragStartDetails details) {
    Logger().i("Scroll Start ${details.localPosition}");
    final screenWidth = MediaQuery.of(context).size.width;

    // initial position of the menu
    setState(() {
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
    });
  }

  onPanUpdate(DragUpdateDetails details) {
    if (!noScroller) {
      // NORMAL SCROLL
      // we are just normally scrolling the view,
      // when the scrollView is NOT at the top
      // AND the menue is hidden
      // OR when we are at the top and swiping up
      if ((scrollController.offset != 0 && topPosition == 0) ||
          (scrollController.offset == 0 &&
              details.delta.dy < 0 &&
              topPosition == 0)) {
        setState(() {
          isNewPan = false;
        });
        double newOffset = scrollController.offset - details.delta.dy;
        // Clamping scroll offset within the scrollable bounds
        if (newOffset < 0) {
          newOffset = 0;
        } else if (newOffset > scrollController.position.maxScrollExtent) {
          newOffset = scrollController.position.maxScrollExtent;
        }
        scrollController.position.jumpTo(newOffset);
      }
      // NAVIGATION SCROLL
      // if scroll Offset 0 and we are swiping down
      // OR the navigation is still visible
      else if ((scrollController.offset == 0 &&
              isNewPan &&
              details.delta.dy > 0) ||
          (topPosition > 0)) {
        setState(() {
          if (topPosition >= 0) {
            topPosition += details.delta.dy;
          } else {
            topPosition = 0;
          }
        });
      }
    } else {
      setState(() {
        if (topPosition >= 0) {
          topPosition += details.delta.dy;
        } else {
          topPosition = 0;
        }
      });
    }

    final screenWidth = MediaQuery.of(context).size.width;

    // update position of the menu
    setState(() {
      menuXposition = (details.localPosition.dx / screenWidth).clamp(0, 1) * 2;
    });
  }

  onPanEnd(DragEndDetails details) {
    for (var i = 0; i < 1; i++) {
      if (menuXposition < 0.5 && topPosition > 150) {
        Logger().i("Left Navigation");
        widget.leftMenuItem!.callback();
        break;
      } else if (menuXposition > 0.5 &&
          menuXposition < 1.5 &&
          topPosition > 150) {
        Logger().i("Center Navigation");
        widget.centerMenuItem.callback();
        break;
      } else if (menuXposition > 1.5 && topPosition > 150) {
        Logger().i("Right Navigation");
        widget.rightMenuItem!.callback();
        break;
      } else {
        Logger().i("Do Nothing");
      }
      if (!noScroller) {
        scrollVelocityY = details.velocity.pixelsPerSecond.dy / 2;
        double finalOffset = scrollController.offset - scrollVelocityY;
        // Clamping scroll offset within the scrollable bounds
        if (finalOffset < 0) {
          finalOffset = 0;
        } else if (finalOffset > scrollController.position.maxScrollExtent) {
          finalOffset = scrollController.position.maxScrollExtent;
        }
        // TODO: lock the direction (up/down)
        scrollController.animateTo(finalOffset,
            duration: const Duration(milliseconds: 700),
            curve: Curves.decelerate);
      }
      Logger().i("Pan End");

      reset();
    }
  }

  void onMouseScroll(PointerScrollEvent pointerSignal) {
    double newScroll = scrollController.offset + pointerSignal.scrollDelta.dy;
    Logger().i("new Scroll $newScroll");
    scrollController.position.jumpTo(newScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Listener(
          onPointerSignal: (pointerSignal) {
            if (pointerSignal is PointerScrollEvent) {
              onMouseScroll(pointerSignal);
            }
          },
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: onPanStart,
              onPanUpdate: onPanUpdate,
              onPanEnd: onPanEnd,
              child: Transform.translate(
                offset: !noScroller
                    ? Offset(
                        0,
                        topPosition.clamp(
                            0, MediaQuery.of(context).size.height / 6))
                    : const Offset(0, 0),
                child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: FullScreenNoAppBar(child: eitherChild)),
              )),
        ),
        Transform.translate(
          offset: Offset(
              0,
              topPosition.clamp(0, MediaQuery.of(context).size.height / 6) -
                  (MediaQuery.of(context).size.height / 6)),
          child: Stack(
            children: [
              widget.gradientImage != null
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 6,
                      child: Image(
                          image: widget.gradientImage!,
                          fit: BoxFit.cover,
                          alignment: Alignment(
                              (menuXposition < 1.4
                                  ? (menuXposition < 0.6 ? 0.8 : 0)
                                  : -0.8),
                              0)),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.leftMenuItem is MenuItem
                        ? SwipeableIcon(
                            isSelected:
                                menuXposition < 0.6 && topPosition > 150,
                            opacity: menuXposition < 0.6
                                ? (1.2 - menuXposition.clamp(0.2, 0.5))
                                    .clamp(0.7, 1)
                                : 0.2,
                            labelText: widget.leftMenuItem!.label,
                            icon: widget.leftMenuItem!.icon,
                          )
                        : Container(),
                    SwipeableIcon(
                      isSelected: menuXposition > 0.6 &&
                          menuXposition < 1.4 &&
                          topPosition > 150,
                      opacity: menuXposition > 0.6 && menuXposition < 1.4
                          ? (1.2 - (menuXposition - 1).abs()).clamp(0.7, 1)
                          : 0.2,
                      labelText: widget.centerMenuItem.label,
                      icon: widget.centerMenuItem.icon,
                    ),
                    widget.rightMenuItem is MenuItem
                        ? SwipeableIcon(
                            isSelected:
                                menuXposition > 1.4 && topPosition > 150,
                            opacity: menuXposition > 1.4
                                ? (1.2 - (menuXposition - 2).abs())
                                    .clamp(0.7, 1)
                                : 0.2,
                            labelText: widget.rightMenuItem!.label,
                            icon: widget.rightMenuItem!.icon,
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MainSwipeNavigationAllDirections extends ConsumerStatefulWidget {
  const MainSwipeNavigationAllDirections(
      {super.key,
      required this.child,
      this.leftMenuItem,
      required this.centerMenuItem,
      this.rightMenuItem,
      this.hasGradient,
      this.leftTopSwipeItem,
      this.leftCenterSwipeItem,
      this.leftBottomSwipeItem,
      this.rightTopSwipeItem,
      this.rightCenterSwipeItem,
      this.rightBottomSwipeItem,
      required this.rightBackgroundImage,
      required this.leftBackgroundImage});

  final Widget child;
  final bool? hasGradient;

  final MenuItem? leftMenuItem;
  final MenuItem centerMenuItem;
  final MenuItem? rightMenuItem;

  final MenuItem? leftTopSwipeItem;
  final MenuItem? leftCenterSwipeItem;
  final MenuItem? leftBottomSwipeItem;

  final MenuItem? rightTopSwipeItem;
  final MenuItem? rightCenterSwipeItem;
  final MenuItem? rightBottomSwipeItem;

  final AssetImage rightBackgroundImage;
  final AssetImage leftBackgroundImage;

  @override
  ConsumerState<MainSwipeNavigationAllDirections> createState() =>
      _MainSwipeNavigationAllDirectionsState();
}

class _MainSwipeNavigationAllDirectionsState
    extends ConsumerState<MainSwipeNavigationAllDirections> {
  ScrollController scrollController = ScrollController();
  double topPosition = 0;
  double leftPosition = 0;
  bool isNewPan = true;
  int isGoingToBeVertical = 0;
  int isGoingToBeHoritontal = 0;
  bool isVertical = false;
  bool isNewVertical = true;
  bool isHorizontal = false;
  double panY = 0;
  double panX = 0;
  double dismissX = 0.0;
  double scrollVelocityY = 0.0;
  bool noScroller = true;
  double menuXposition =
      0; // determines which of the 3 menu icons is selected, 0 if left, 1 if center, 2 if right, double if in transition
  int scale = 150;
  double dismissThreshold = 0.2;
  late Widget eitherChild;
  @override
  void initState() {
    super.initState();
    eitherChild = (widget.child is ScrollableWidget)
        ? (widget.child as ScrollableWidget)
            .rebuildWithScrollController(scrollController)
        : widget.child;
    noScroller = widget.child is ScrollableWidget ? false : true;
    Logger().i("No Scroller: $noScroller");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await precacheImage(widget.rightBackgroundImage, context);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await precacheImage(widget.leftBackgroundImage, context);
    });
  }

  void reset() {
    setState(() {
      //topPosition = 0;
      //mainTextScrollable = false;
      isNewPan = true;
      isGoingToBeVertical = 0;
      isGoingToBeHoritontal = 0;
      panX = 0;
      panY = 0;
      menuXposition = 1;
      topPosition = 0;
      leftPosition = 0;
      isNewVertical = true;
      isVertical = false;
      isHorizontal = false;
    });
  }

  // TODO void before all functions
  onPanStart(DragStartDetails details) {
    Logger().i("Scroll Start ${details.localPosition}");
    final screenWidth = MediaQuery.of(context).size.width;

    // initial position of the menu
    setState(() {
      // TODO ???
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
    });
  }

  onPanUpdate(DragUpdateDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;

    setState(() {
      panY += details.delta.dy;
      panX += details.delta.dx;
      dismissX = panX / screenWidth;
    });

    if (isNewPan) {
      isGoingToBeVertical += details.delta.dy.toInt();
      isGoingToBeHoritontal += details.delta.dx.toInt();

      if (isGoingToBeVertical.abs() > 10) {
        Logger().i("newSwipe: is Vertical");
        setState(() {
          isVertical = true;
          isHorizontal = false;
          isNewPan = false;
        });
      } else if (isGoingToBeHoritontal.abs() > 10) {
        Logger().i("newSwipe: is Horizontal");
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
        Logger().i("newSwipe: Menu X Position: $menuXposition");
      });
    }
    if (isHorizontal) {
      setState(() {
        topPosition = 0;
        leftPosition += details.delta.dx;
        Logger().i("newSwipe: Left Position: $leftPosition");
      });
    }

    ///////
    if (!noScroller && isVertical) {
      // NORMAL SCROLL
      // we are just normally scrolling the view,
      // when the scrollView is NOT at the top
      // AND the menue is hidden
      // OR when we are at the top and swiping up
      Logger().i(
          "newSwipe: Normal Scroll: Off: ${scrollController.offset} Top: $topPosition Delta: ${details.delta.dy}");
      if ((scrollController.offset != 0 &&
              topPosition == 0 &&
              details.globalPosition.dy > 150) ||
          (scrollController.offset == 0 && details.delta.dy < 0)) {
        setState(() {
          isNewVertical = false;
        });
        Logger().i("newSwipe: Normal Scroll");
        double newOffset = scrollController.offset - details.delta.dy;
        // Clamping scroll offset within the scrollable bounds
        if (newOffset < 0) {
          newOffset = 0;
        } else if (newOffset > scrollController.position.maxScrollExtent) {
          newOffset = scrollController.position.maxScrollExtent;
        }
        scrollController.position.jumpTo(newOffset);
      }
      // NAVIGATION SCROLL
      // if scroll Offset 0 and we are swiping down
      // OR the navigation is still visible
      else if ((scrollController.offset == 0 &&
              details.delta.dy > 0 &&
              isNewVertical) ||
          (topPosition > 0) ||
          details.globalPosition.dy <= 150) {
        setState(() {
          if (topPosition >= 0) {
            topPosition += details.delta.dy;
          } else {
            topPosition = 0;
          }
        });
      }
    }
  }

  onPanEnd(DragEndDetails details) {
    for (var i = 0; i < 1; i++) {
      if (isVertical) {
        Logger().i("Pan End");
        if (menuXposition < 0.5 && topPosition > 150) {
          Logger().i("Left Navigation");
          widget.leftMenuItem!.callback();
          break;
        } else if (menuXposition > 0.5 &&
            menuXposition < 1.5 &&
            topPosition > 150) {
          Logger().i("Center Navigation");
          widget.centerMenuItem.callback();
          break;
        } else if (menuXposition > 1.5 && topPosition > 150) {
          Logger().i("Right Navigation");
          widget.rightMenuItem!.callback();
          break;
        } else {
          Logger().i("Do Nothing");
        }
        if (!noScroller) {
          scrollVelocityY = details.velocity.pixelsPerSecond.dy / 2;
          double finalOffset = scrollController.offset - scrollVelocityY;
          // Clamping scroll offset within the scrollable bounds
          if (finalOffset < 0) {
            finalOffset = 0;
          } else if (finalOffset > scrollController.position.maxScrollExtent) {
            finalOffset = scrollController.position.maxScrollExtent;
          }
          // TODO: lock the direction (up/down)
          scrollController.animateTo(finalOffset,
              duration: const Duration(milliseconds: 700),
              curve: Curves.decelerate);
        }
      }
      if (isHorizontal) {
        if (dismissX > dismissThreshold) {
          int clampedDragExtend =
              ((dismissX - dismissThreshold) * scale).clamp(0, 100) ~/ 2;
          ref.watch(ratingProvider.notifier).state = 50 + clampedDragExtend;
          setState(() {
            scrollController.jumpTo(0.0);
          });
          widget.leftCenterSwipeItem?.callback();
        }
        if (dismissX < -dismissThreshold) {
          int clampedDragExtend =
              ((-dismissX - dismissThreshold) * scale).clamp(0, 100) ~/ 2;
          ref.watch(ratingProvider.notifier).state = 50 - clampedDragExtend;
          setState(() {
            scrollController.jumpTo(0.0);
          });
          widget.rightCenterSwipeItem?.callback();
        }
      }
      reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isVertical // TODO create Widget, rename isVertical to Swipe
            ? Container(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Transform.translate(
                  offset: Offset(
                      0,
                      topPosition.clamp(
                              0, MediaQuery.of(context).size.height / 6) -
                          (MediaQuery.of(context).size.height / 6)),
                  child: Stack(
                    children: [
                      widget.hasGradient != null
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height / 6,
                              child: Image(
                                  image: const AssetImage(
                                      navigationBackgroundImageOnBlack),
                                  fit: BoxFit.cover,
                                  alignment: Alignment(
                                      (menuXposition < 1.4
                                          ? (menuXposition < 0.6 ? 0.8 : 0)
                                          : -0.8),
                                      0)),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.leftMenuItem is MenuItem
                                ? SwipeableIcon(
                                    isSelected: menuXposition < 0.6 &&
                                        topPosition > 150,
                                    opacity: menuXposition < 0.6
                                        ? (1.2 - menuXposition.clamp(0.2, 0.5))
                                            .clamp(0.7, 1)
                                        : 0.2,
                                    labelText: widget.leftMenuItem!.label,
                                    icon: widget.leftMenuItem!.icon,
                                  )
                                : Container(),
                            SwipeableIcon(
                              isSelected: menuXposition > 0.6 &&
                                  menuXposition < 1.4 &&
                                  topPosition > 150,
                              opacity:
                                  menuXposition > 0.6 && menuXposition < 1.4
                                      ? (1.2 - (menuXposition - 1).abs())
                                          .clamp(0.7, 1)
                                      : 0.2,
                              labelText: widget.centerMenuItem.label,
                              icon: widget.centerMenuItem.icon,
                            ),
                            widget.rightMenuItem is MenuItem
                                ? SwipeableIcon(
                                    isSelected: menuXposition > 1.4 &&
                                        topPosition > 150,
                                    opacity: menuXposition > 1.4
                                        ? (1.2 - (menuXposition - 2).abs())
                                            .clamp(0.7, 1)
                                        : 0.2,
                                    labelText: widget.rightMenuItem!.label,
                                    icon: widget.rightMenuItem!.icon,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : FullScreenNoAppBar(
                child: (leftPosition < 0)
                    ? Image(
                        image: widget.leftBackgroundImage,
                        fit: BoxFit.cover,
                        alignment:
                            Alignment((dismissX * 4.5 + 2).clamp(-1, 1), 0))
                    : Image(
                        image: widget.rightBackgroundImage,
                        fit: BoxFit.cover,
                        alignment:
                            Alignment((dismissX * 4.5 - 2).clamp(-1, 1), 0)),
              ),
        GestureDetector(
            // TODO could be parent of the stack
            behavior: HitTestBehavior.opaque,
            onPanStart: onPanStart,
            onPanUpdate: onPanUpdate,
            onPanEnd: onPanEnd,
            child: Transform.translate(
              offset: Offset(leftPosition,
                  topPosition.clamp(0, MediaQuery.of(context).size.height / 6)),
              child: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: FullScreen(child: eitherChild)),
            ))
      ],
    );
  }
}
