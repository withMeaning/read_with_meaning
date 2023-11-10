import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_with_meaning/public/common_widgets/async_value_widget.dart';
import 'package:read_with_meaning/public/common_widgets/launch_url_and_route.dart';
import 'package:read_with_meaning/public/features/experience/data/realm_repository.dart';
import 'package:read_with_meaning/shared/domain/realm_types/do.dart';
import 'package:read_with_meaning/shared/domain/realm_types/experience.dart';
import 'package:read_with_meaning/shared/domain/realm_types/read.dart';

class MainText extends ConsumerWidget {
  const MainText({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //var repo = ref.watch(readFutureProvider(id));
    late String selection = "";
    var extras = ref.watch(extraProvider.notifier).state;

    return Container(
      child: Center(
        child: StreamBuilder(
            stream: ref.watch(nowProvider).changes,
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                      child: SelectionArea(
                          onSelectionChanged: (text) {
                            if (text != null) {
                              selection = text.plainText;
                            }
                          },
                          contextMenuBuilder: (context, editableTextState) {
                            return AdaptiveTextSelectionToolbar.buttonItems(
                                anchors: editableTextState.contextMenuAnchors,
                                buttonItems:
                                    editableTextState.contextMenuButtonItems
                                // TODO replace with Super Editor Selection
                                /* ..insertAll(0, [
                                      ContextMenuButtonItem(
                                          onPressed: () {
                                            highlight(selection);
                                          },
                                          type: ContextMenuButtonType.custom,
                                          label: "Highlight"),
                                    ]), */
                                );
                          },
                          focusNode: FocusNode(),
                          child: AsyncValueWidget(
                            value: ref.watch(extraStreamProvider),
                            data: (extra) => MarkdownBody(
                              styleSheet: MarkdownStyleSheet(
                                blockquoteDecoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(10),
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              onTapLink: (text, url, title) {
                                LaunchUrlAndRoute.launch(context, url!);
                              },
                              data: extra is Read
                                  ? extra.mainContent +
                                      (extra.link != ""
                                          ? "\n Original Article: ${extra.link}"
                                          : "")
                                  : extra is DoIt
                                      ? extra.description
                                      : extra is PureExperience
                                          ? ""
                                          : "",
                            ),
                          )),
                    )
                  ],
                ),
              );
            }),
        /* AsyncValueWidget(
            value: repo,
            data: (currentItem) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                      child: SelectionArea(
                        onSelectionChanged: (text) {
                          if (text != null) {
                            selection = text.plainText;
                          }
                        },
                        contextMenuBuilder: (context, editableTextState) {
                          return AdaptiveTextSelectionToolbar.buttonItems(
                              anchors: editableTextState.contextMenuAnchors,
                              buttonItems:
                                  editableTextState.contextMenuButtonItems
                              // TODO replace with Super Editor Selection
                              /* ..insertAll(0, [
                                      ContextMenuButtonItem(
                                          onPressed: () {
                                            highlight(selection);
                                          },
                                          type: ContextMenuButtonType.custom,
                                          label: "Highlight"),
                                    ]), */
                              );
                        },
                        focusNode: FocusNode(),
                        child: MarkdownBody(
                            styleSheet: MarkdownStyleSheet(
                              blockquoteDecoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withAlpha(10),
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            onTapLink: (text, url, title) {
                              LaunchUrlAndRoute.launch(context, url!);
                            },
                            data: currentItem.mainContent +
                                (currentItem.link != ""
                                    ? "\n Original Article: ${currentItem.link}"
                                    : "")),
                      ),
                    ),
                  ],
                ),
              );
            }), */
      ),
    );
  }
}
