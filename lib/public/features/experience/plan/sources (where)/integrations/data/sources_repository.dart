// ! Drift

/* import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_with_meaning/public/features/experience/data/database/database.dart';

class SourcesRepository {
  Stream<List<Source>> watchSources(AppDatabase db) async* {
    yield* db.select(db.sources).watch();
  }
}

final sourcesRepositoryProvider =
    Provider.autoDispose<SourcesRepository>((ref) {
  return SourcesRepository();
});
/*  */
final sourcesListRepositoryStreamProvider =
    StreamProvider.autoDispose<List<Source>>((ref) {
  final database = ref.watch(AppDatabase.provider);
  final SourcesRepository repository = ref.watch(sourcesRepositoryProvider);
  return repository.watchSources(database);
});
 */