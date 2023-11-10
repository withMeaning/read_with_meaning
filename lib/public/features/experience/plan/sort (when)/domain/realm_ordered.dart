import 'package:read_with_meaning/shared/domain/realm_types/experience.dart';
import 'package:realm/realm.dart';

part 'realm_ordered.g.dart';

@RealmModel()
class $Orders {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  late $Experience? experience;
  late int orderIndex;
}
