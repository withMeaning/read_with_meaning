import 'package:realm/realm.dart';

part 'stream_file_model.g.dart';

@RealmModel()
class _StreamFile {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  @MapTo('owner_id')
  late String ownerId;

  late String text;
}
