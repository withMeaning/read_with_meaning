// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'now.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Now extends $Now with RealmEntity, RealmObjectBase, RealmObject {
  Now(
    ObjectId id,
    String ownerId, {
    Experience? experience,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'owner_id', ownerId);
    RealmObjectBase.set(this, 'experience', experience);
  }

  Now._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get ownerId => RealmObjectBase.get<String>(this, 'owner_id') as String;
  @override
  set ownerId(String value) => RealmObjectBase.set(this, 'owner_id', value);

  @override
  Experience? get experience =>
      RealmObjectBase.get<Experience>(this, 'experience') as Experience?;
  @override
  set experience(covariant Experience? value) =>
      RealmObjectBase.set(this, 'experience', value);

  @override
  Stream<RealmObjectChanges<Now>> get changes =>
      RealmObjectBase.getChanges<Now>(this);

  @override
  Now freeze() => RealmObjectBase.freezeObject<Now>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Now._);
    return const SchemaObject(ObjectType.realmObject, Now, 'Now', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('ownerId', RealmPropertyType.string, mapTo: 'owner_id'),
      SchemaProperty('experience', RealmPropertyType.object,
          optional: true, linkTarget: 'Experience'),
    ]);
  }
}
