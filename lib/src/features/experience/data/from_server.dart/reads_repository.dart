import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_with_meaning/localization/string_hardcoded.dart';
import 'package:read_with_meaning/src/features/experience/data/fake/fake_reads_repository.dart';
import 'package:read_with_meaning/src/features/experience/data/from_server.dart/fetch_get_items.dart';
import 'package:read_with_meaning/src/features/experience/data/from_server.dart/get_items_response.dart';
import 'package:read_with_meaning/src/features/experience/data/types/read.dart';

class ReadsRepository {
  final List<Read> parsedReadList = [];
  final List<GetItem> getItemList = [];
  GetItemsResponse? resObject;

  // TODO turn into abstract class of fake and db reads repository
  Future<List<Read>> fetchReadsFromAPI() async {
    //await Future.delayed(const Duration(seconds: 1));
    try {
      debugPrint("fetching reads");
      var response =
          await getItems(); /* .then((value) => {
            resObject = GetItemsResponse.fromJson(value.body),
            resObject?.items.forEach((element) {
              parsedReadList.add(jsonDecode(element));
            })
          }); */
      GetItemsResponse resObject = GetItemsResponse.fromJson(response.body);

      for (var element in resObject.items) {
        getItemList.add(GetItem.fromMap(element));
      }
      for (var element in getItemList) {
        if (element.type == "read" && element.archived == false) {
          parsedReadList.add(Read(
              id: element.uid,
              author: element.author ?? "unknown".hardcoded,
              createdAt: 13213, // TODO this needs some timestamp parsing
              title: element.title ?? "unknown".hardcoded,
              mainContent: element.content ?? "".hardcoded,
              source: "spile.withmeaning.io".hardcoded,
              link: element.link ?? "".hardcoded));
        }
      }
      return Future.value(parsedReadList);
    } catch (e) {
      return Future.value(parsedReadList);
    }
  }
}

final realReadsRepositoryProvider = Provider<ReadsRepository>((ref) {
  return ReadsRepository();
});

final readRefreshFutureProvider = FutureProvider.autoDispose<void>((ref) async {
  final fakeReadsRepository = ref.watch(readsRepositoryProvider);
  final realReadsRepository = ref.watch(realReadsRepositoryProvider);
  final reads = await realReadsRepository.fetchReadsFromAPI();
  return fakeReadsRepository.replaceReads(reads);
});