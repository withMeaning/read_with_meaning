import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_with_meaning/public/common_widgets/async_value_widget.dart';
import 'package:read_with_meaning/public/common_widgets/navigation/main_swipe_navigation.dart';
import 'package:read_with_meaning/public/constants/app_sizes.dart';
import 'package:read_with_meaning/public/features/experience/data/realm_repository.dart';
import 'package:read_with_meaning/public/features/experience/plan/stream_file%20(which)/data/stream_file_model.dart';
import 'package:realm/realm.dart';

class EditFile extends ConsumerStatefulWidget implements ScrollableWidget {
  const EditFile({super.key, this.scrollController});

  final ScrollController? scrollController;
  @override
  Widget rebuildWithScrollController(ScrollController controller) {
    return EditFile(scrollController: controller);
  }

  @override
  ConsumerState<EditFile> createState() => _EditFileState();
}

class _EditFileState extends ConsumerState<EditFile> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _mainContentController = TextEditingController();
  final _linkController = TextEditingController();
  final FocusNode _firstNode = FocusNode();
  final FocusNode _secondNode = FocusNode();
  final FocusNode _thirdNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var streamFileRepo = ref.watch(streamFileProvider);

    void submit(ObjectId id) {
      var realm = ref.read(realmProvider);
      if (_formKey.currentState!.validate()) {
        realm.write(() {
          realm.add<StreamFile>(
              StreamFile(
                  id, ref.read(userProvider)!.id, _mainContentController.text),
              update: true);
        });
      }
    }

    return AsyncValueWidget(
        value: streamFileRepo,
        placeholder: SizedBox(
          width: 100,
          height: 50,
          child: Container(
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        data: (myStreamFile) {
          _mainContentController.text = myStreamFile!.text;
          return StreamBuilder(
            stream: myStreamFile.changes,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                          controller: _mainContentController,
                          scrollController: widget.scrollController,
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          minLines: 5,
                          maxLines: 20,
                          onFieldSubmitted: (term) {
                            // TODO submit(realm.all<StreamFile>().first.id, realm);
                          },
                          textInputAction: TextInputAction.newline),
                      gapH12,
                      ElevatedButton(
                        onPressed: () {
                          submit(myStreamFile.id);
                        },
                        child: Text(
                            style: Theme.of(context).textTheme.labelLarge,
                            'Save'),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
