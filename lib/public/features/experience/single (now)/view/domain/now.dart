import 'package:read_with_meaning/shared/domain/realm_types/experience.dart';
import 'package:realm/realm.dart';

part 'now.g.dart';

@RealmModel()
class $Now {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  @MapTo('owner_id')
  late String ownerId;

  late $Experience? experience;
}
