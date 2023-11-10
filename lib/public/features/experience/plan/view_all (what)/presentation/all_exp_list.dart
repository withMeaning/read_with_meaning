import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_with_meaning/localization/string_hardcoded.dart';
import 'package:read_with_meaning/public/common_widgets/async_value_widget.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/main_swipe_navigation.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/top_label.dart';
import 'package:read_with_meaning/public/features/experience/data/realm_repository.dart';
import 'package:read_with_meaning/public/routing/routes.dart';

class AllExpList extends ConsumerStatefulWidget implements ScrollableWidget {
  const AllExpList({super.key, this.scrollController});
  final ScrollController? scrollController;
  @override
  Widget rebuildWithScrollController(ScrollController controller) {
    return AllExpList(scrollController: controller);
  }

  @override
  ConsumerState<AllExpList> createState() => _AllExpListState();
}

// TODO this should propbably not hold the repository?
class _AllExpListState extends ConsumerState<AllExpList> {
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
    return AsyncValueWidget(
        // TODO try StreamBuilder?
        value: ref.watch(allExpsStreamProvider), //
        placeholder: SizedBox(
          width: 100,
          height: 100,
          child: Container(
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        data: (data) {
          return TopLabel(
              routeName: AppRoute.lakes,
              text: "All Reads".hardcoded,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index].content),
                  );
                },
                itemCount: data.length,
                controller: widget.scrollController,
                physics: const NeverScrollableScrollPhysics(),
              ));
        });
    // ! Drift
    /* final readRepository =
        ref.watch(readsWithOrderListRepositoryStreamProvider);
    return AsyncValueWidget(
        value: readRepository,
        placeholder: SizedBox(
          width: 100,
          height: 100,
          child: Container(
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        data: (List<ReadsWithOrder> onlyReadItems) {
          var list = onlyReadItems
              .map((ReadsWithOrder exp) => Dismissible(
                    key: Key(exp.read.base.id),
                    background: Container(color: Colors.red),
                    secondaryBackground: Container(color: Colors.green),
                    onDismissed: (direction) {},
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        Logger().d("Dismissed to the left");
                      } else {
                        Logger().d("Dismissed to the right");
                      }
                      return false;
                    },
                    child: GestureDetector(
                      onDoubleTap: () {
                        if (!exp.ordered) {
                          ref.read(addToTopProvider(exp.read.base.id));
                          context.pushNamed(AppRoute.exp.name,
                              pathParameters: {"id": exp.read.base.id});
                        } else {
                          context.pushNamed(AppRoute.exp.name,
                              pathParameters: {"id": exp.read.base.id});
                        }
                      },
                      child: ListTile(
                        key: Key(exp.read.base.id),
                        textColor: exp.ordered
                            ? Theme.of(context).colorScheme.onBackground
                            : Theme.of(context).disabledColor,
                        title: Text(exp.read.base.content),
                        onTap: () => {
                          ref.read(addToTopProvider(exp.read.base.id)),
                        },
                        subtitle: Text(exp.read.base.author),
                      ),
                    ),
                  ))
              .toList();

          return TopLabel(
            routeName: AppRoute.lakes,
            text: "All Reads".hardcoded,
            child: ListView(
                controller: widget.scrollController,
                physics: const NeverScrollableScrollPhysics(),
                children: list),
          );
        }); */
  }
}
