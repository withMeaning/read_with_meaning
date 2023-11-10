import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:read_with_meaning/public/constants/app_sizes.dart';
import 'package:read_with_meaning/public/features/experience/add/application/add_to_realm.dart';
import 'package:read_with_meaning/public/features/experience/single%20(now)/rating/rating_provider.dart';
import 'package:read_with_meaning/shared/domain/all_types_definition.dart';

// ? is there a cleaner way to pass the ref to application add_exp_to_db.dart?
class AddExpForm extends ConsumerStatefulWidget {
  const AddExpForm({super.key});

  @override
  ConsumerState<AddExpForm> createState() => _AddExpFormState();
}

class _AddExpFormState extends ConsumerState<AddExpForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _mainContentController = TextEditingController();
  final _linkController = TextEditingController();
  final FocusNode _firstNode = FocusNode();
  final FocusNode _secondNode = FocusNode();
  final FocusNode _thirdNode = FocusNode();
  bool isNotLink = false;

  @override
  Widget build(BuildContext context) {
    ref.watch(ratingProvider);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title or Link'),
                autofocus: true,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _firstNode, _secondNode);
                },
                textInputAction: TextInputAction.next,
                focusNode: _firstNode,
                onChanged: (value) {
                  setState(() {
                    Logger().i(!value.startsWith("http"));
                    Logger().i(value.length > 4);
                    isNotLink =
                        (!value.startsWith("http")) && (value.length > 4);
                  });
                },
              ),
              gapH8,
              isNotLink
                  ? TextFormField(
                      controller: _mainContentController,
                      minLines: 6,
                      maxLines: 10,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(context, _secondNode, _thirdNode);
                      },
                      textInputAction: TextInputAction.newline,
                      focusNode: _secondNode,
                    )
                  : Container(),
              gapH12,
              ElevatedButton(
                onPressed: () {
                  _submit();
                },
                child: Text(
                    style: Theme.of(context).textTheme.labelLarge,
                    'Add ${!isNotLink ? 'Link' : ''}'),
              )
            ],
          ),
        ),
      ),
    );
  }

  _submit() {
    /* addReadToDB(ref, _titleController.text, _mainContentController.text,
        _linkController.text); */
    /* ref.read(addReadToDBandServerProvider(
      addReadModel(
          title: _titleController.text,
          mainContent: _mainContentController.text,
          link: _linkController.text),
    )); */
    if (!isNotLink) {
      ref.read(addReadToRealmProvider(
        AddReadModel(
          content: _titleController.text,
          type: AllTypes.read,
        ),
      ));
    } else if (_mainContentController.text != "") {
      ref.read(addReadToRealmProvider(
        AddReadModel(
          content: _titleController.text,
          type: AllTypes.doit,
          extra: _mainContentController.text,
        ),
      ));
    } else {
      ref.read(addReadToRealmProvider(
        AddReadModel(
          content: _titleController.text,
          type: AllTypes.see,
        ),
      ));
    }

    context.pop(""); // ?
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _mainContentController.dispose();
    _linkController.dispose();
    super.dispose();
  }
}
