import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:read_with_meaning/shared/domain/all_types_definition.dart';
import 'package:read_with_meaning/shared/domain/realm_types/do.dart';
import 'package:read_with_meaning/shared/domain/realm_types/experience.dart';
import 'package:realm/realm.dart';

import '../../plan/sort (when)/domain/realm_ordered.dart';
import '../../data/realm_repository.dart';

class AddReadModel {
  final String content;
  final AllTypes type;
  final String? extra;

  const AddReadModel({
    required this.content,
    required this.type,
    this.extra,
  });
}

final addReadToRealmProvider =
    FutureProvider.family<void, AddReadModel>((ref, add) async {
  ObjectId id = ObjectId();
  //bool linkOnly = (add.title == "" && add.mainContent == "" && add.link != "");

  Realm realm = ref.read(realmProvider.notifier).state;
  try {
    Experience newExp = Experience(
      id,
      ref.read(userProvider)!.id,
      DateTime.now(),
      add.content,
      add.type.name,
    );
    realm.write(() {
      realm.add<Experience>(newExp, update: true);
      realm.add<Orders>(
          Orders(
              id,
              1 +
                  (realm
                          .query<Orders>('TRUEPREDICATE SORT(orderIndex ASC)')
                          .lastOrNull
                          ?.orderIndex ??
                      0),
              experience: newExp),
          update: true);
    });
    realm.write(() {
      switch (add.type) {
        case AllTypes.doit:
          realm.add<DoIt>(
              DoIt(id, ref.read(userProvider)!.id, add.extra!, "undone",
                  experience: newExp),
              update: true);
          break;
        default:
      }
    });
  } on Exception catch (e) {
    Logger().e(e);
  }
});
