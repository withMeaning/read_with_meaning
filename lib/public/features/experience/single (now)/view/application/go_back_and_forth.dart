import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:read_with_meaning/public/features/experience/plan/sort%20(when)/domain/realm_ordered.dart';
import 'package:read_with_meaning/public/features/experience/data/realm_repository.dart';
import 'package:read_with_meaning/public/features/experience/single%20(now)/view/domain/now.dart';
import 'package:read_with_meaning/public/routing/routes.dart';
import 'package:read_with_meaning/shared/domain/realm_types/experience.dart';
import 'package:realm/realm.dart';

void goNext(BuildContext context, WidgetRef ref, String id) {
  Now now = ref.watch(nowProvider);
  // get the index of the current experience
  int currentIndex = ref
      .read(realmProvider)
      .query<Orders>("experience = \$0", [now.experience])
      .firstOrNull!
      .orderIndex;
  // select the experience with a higher index
  String currentUserId = ref.read(userProvider)!.id;
  var exps = ref
      .read(realmProvider)
      .query<Orders>("orderIndex > \$0", [currentIndex]).query(
          "experience.owner_id = \$0 OR experience.owner_id == 'public'",
          [currentUserId]);
  var sorted = exps.query("TRUEPREDICATE SORT(orderIndex ASC)");
  Logger().i(sorted.map((e) => e.experience?.content).toList());
  Experience? nextExperience = sorted.firstOrNull?.experience;
  // change the now experience to the next one or go to Done
  if (nextExperience != null) {
    ref.read(changeNowProvider(nextExperience));
  } else {
    context.pushNamed(AppRoute.done.name);
  }
}

  /* // TODO replace with db order solution
  final db = ref.read(AppDatabase.provider);
  Order currentIndex = await (db.select(db.orders)
        ..where((tbl) => tbl.id.equals(id)))
      .getSingle();
  try {
    String nextId = await (db.select(db.orders)
          ..where((tbl) => tbl.orderIndex.equals(currentIndex.orderIndex + 1)))
        .getSingle()
        .then((value) => value.id);
    context.pushNamed(AppRoute.exp.name, pathParameters: {"id": nextId});
  } catch (e) {
    context.pushNamed(AppRoute.done.name);
    return;
  } */
  /* (db.select(db.readExtras)..where((tbl) => tbl.id.equals(id)))
      .getSingle()
      .then((value) => db
          .customSelect(
              "SELECT * FROM read_entries WHERE id > '${value.id}' ORDER BY id ASC LIMIT 1")
          .getSingle())
      .then((value) => context.pushNamed(AppRoute.exp.name,
          pathParameters: {"id": value.data["id"]})); */


/* void goPrevious(BuildContext context, WidgetRef ref, String id) {
  context.pop();
  /*final db = ref.read(AppDatabase.provider);
  (db.select(db.readEntries)..where((tbl) => tbl.id.equals(id)))
      .getSingle()
      .then((value) => db
          .customSelect(
              "SELECT * FROM read_entries WHERE id < '${value.id}' ORDER BY id DESC LIMIT 1")
          .getSingle())
      .then((value) => context.goNamed(AppRoute.exp.name,
          pathParameters: {"id": value.data["id"]}));*/
} */
