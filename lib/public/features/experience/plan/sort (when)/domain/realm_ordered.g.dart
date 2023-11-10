// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_ordered.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Orders extends $Orders with RealmEntity, RealmObjectBase, RealmObject {
  Orders(
    ObjectId id,
    int orderIndex, {
    Experience? experience,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'experience', experience);
    RealmObjectBase.set(this, 'orderIndex', orderIndex);
  }

  Orders._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  Experience? get experience =>
      RealmObjectBase.get<Experience>(this, 'experience') as Experience?;
  @override
  set experience(covariant Experience? value) =>
      RealmObjectBase.set(this, 'experience', value);

  @override
  int get orderIndex => RealmObjectBase.get<int>(this, 'orderIndex') as int;
  @override
  set orderIndex(int value) => RealmObjectBase.set(this, 'orderIndex', value);

  @override
  Stream<RealmObjectChanges<Orders>> get changes =>
      RealmObjectBase.getChanges<Orders>(this);

  @override
  Orders freeze() => RealmObjectBase.freezeObject<Orders>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Orders._);
    return const SchemaObject(ObjectType.realmObject, Orders, 'Orders', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('experience', RealmPropertyType.object,
          optional: true, linkTarget: 'Experience'),
      SchemaProperty('orderIndex', RealmPropertyType.int),
    ]);
  }
}
